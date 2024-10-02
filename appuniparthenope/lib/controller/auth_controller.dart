import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/service/api_login_service.dart';
import 'package:appuniparthenope/model/user_data_login.dart';

import '../widget/alertDialog.dart';
import '../widget/carrerSelectorDialog.dart';

class AuthController {
  final ApiService apiService = ApiService();

  /// Autentica l'utente utilizzando username e password.
  /// Se l'autenticazione ha successo, ritorna un oggetto [UserInfo].
  Future<UserInfo> authUser(
      BuildContext context, String username, String password) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.login(username, password, context);

      final String authToken = responseData['authToken'] ?? '';

      final Map<String, dynamic>? userData = responseData['user'];
      if (userData == null) {
        throw Exception('Dati utente mancanti');
      }

      final List<dynamic> trattiCarrieraDynamic =
          userData['trattiCarriera'] ?? [];

      if (trattiCarrieraDynamic.isNotEmpty) {
        String? selectedCareerId;

        if (trattiCarrieraDynamic.length > 1) {
          selectedCareerId = await showCareerSelectionDialog(
              context, trattiCarrieraDynamic.cast<Map<String, dynamic>>());
          if (selectedCareerId == null) {
            throw Exception('Carriera non selezionata');
          }
        } else {
          selectedCareerId = trattiCarrieraDynamic[0]['cdsId'].toString();
        }

        final selectedCareer = trattiCarrieraDynamic.firstWhere(
            (career) => career['cdsId'].toString() == selectedCareerId,
            orElse: () => throw Exception('Carriera selezionata non trovata'));

        return UserInfo(
          authToken: authToken,
          user: User.fromJson(userData),
          selectedCareer: TrattiCarriera.fromJson(selectedCareer),
        );
      } else if (userData['grpDes'] == 'Docenti') {
        return UserInfo(
          authToken: authToken,
          user: User.fromJson(userData),
          selectedCareer: null,
        );
      } else if (userData['grpDes'] == 'PTA') {
        return UserInfo(
          authToken: authToken,
          user: User.fromJson(userData),
          selectedCareer: null,
        );
      } else if (userData['grpDes'] == 'Ipot. Immatricolati' ||
          userData['grpDes'] == 'Preiscritti' ||
          userData['grpDes'] == 'Iscritti') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlertDialog(
              title: 'Area Riservata Non Disponibile',
              content:
                  'Gentile utente, attualmente non puoi ancora accedere alla tua area personale. Non preoccuparti, non appena la tua immatricolazione sarà completata, avrai accesso completo ai servizi. Grazie per la tua pazienza!',
              buttonText: 'OK',
              color: Colors.orange,
              icon: Icons.info_outline,
            );
          },
        );
        throw Exception('Utente non ancora immatricolato');
      } else if (userData.values.any((value) => value == null || value == '')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlertDialog(
              title: 'Dati Mancanti',
              content:
                  'Alcune informazioni nel tuo profilo risultano mancanti o incomplete. '
                  'Si prega di contattare il supporto per risolvere il problema.',
              buttonText: 'OK',
              color: Colors.orange,
              icon: Icons.warning,
            );
          },
        );
        throw Exception('Dati utenti mancanti');
      } else {
        throw Exception('Nessuna carriera trovata');
      }
    } catch (e) {
      if (e.toString().contains('Errore Credenziali Invalide')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlertDialog(
              title: 'Errore',
              content:
                  'Le credenziali fornite non sono valide. Per favore riprova.',
              buttonText: 'OK',
              color: Colors.red,
              icon: Icons.error,
            );
          },
        );
      }
      rethrow;
    }
  }

  /// Mostra un dialogo per la selezione della carriera.
  /// Ritorna l'ID della carriera selezionata.
  Future<String?> showCareerSelectionDialog(
      BuildContext context, List<Map<String, dynamic>> careers) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CustomCareerSelectionDialog(careers: careers);
      },
    );
  }

  /// Imposta i dati anagrafici dello studente.
  /// Ritorna un oggetto [UserAnagrafe].
  Future<UserAnagrafe> setAnagrafe(BuildContext context, User student) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.userAnagrafe(student, context);

      UserAnagrafe userAnagrafe = UserAnagrafe.fromJson(responseData);

      return userAnagrafe;
    } catch (e) {
      print('Error during controller setAnagrafe: $e');
      throw Exception('Errore nella fase di acquisizione dei dati anagrafici');
    }
  }

  /// Ottiene l'immagine di profilo dello studente.
  /// Ritorna una stringa con il percorso dell'immagine.
  Future<String> getUserProfileImage(User student, BuildContext context) async {
    try {
      final String profileImage =
          await apiService.userProfileImage(student, context);

      return profileImage;
    } catch (e) {
      print('Error during getUserProfileImage$e');
      throw Exception('Errore durante il recupero dell\'immagine di profilo');
    }
  }

  /// Ottiene il QR-Code dello studente.
  /// Ritorna una stringa con il QR-Code.
  Future<String> getUserQRCode(User student, BuildContext context) async {
    try {
      final String qrCode = await apiService.userQRCode(student, context);

      return qrCode;
    } catch (e) {
      print('\nError during getUserQRCode(): $e');
      throw Exception('\nErrore durante il recupero del QR-Code');
    }
  }
}
