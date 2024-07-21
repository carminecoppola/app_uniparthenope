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
      final String authToken = responseData['authToken'];
      final Map<String, dynamic> userData = responseData['user'];

      final List<dynamic> trattiCarrieraDynamic = userData['trattiCarriera'];

      if (trattiCarrieraDynamic.isNotEmpty) {
        String? selectedCareerId;

        // Se ci sono più carriere, mostra il dialogo di selezione
        if (trattiCarrieraDynamic.length > 1) {
          selectedCareerId = await showCareerSelectionDialog(
              context, trattiCarrieraDynamic.cast<Map<String, dynamic>>());
          if (selectedCareerId == null) {
            throw Exception('Carriera non selezionata');
          }
        } else {
          selectedCareerId = trattiCarrieraDynamic[0]['cdsId'].toString();
        }

        // Filtra la carriera selezionata
        final selectedCareer = trattiCarrieraDynamic.firstWhere(
            (career) => career['cdsId'].toString() == selectedCareerId);

        // Costruisce un oggetto User con i dati ottenuti
        final UserInfo authenticatedUser = UserInfo(
          authToken: authToken,
          user: User.fromJson(userData),
          selectedCareer: TrattiCarriera.fromJson(selectedCareer),
        );

        return authenticatedUser;
      } else if (userData['grpDes'] == 'Docenti') {
        // Costruisce un oggetto User senza carriera per i docenti
        final UserInfo authenticatedUser = UserInfo(
          authToken: authToken,
          user: User.fromJson(userData),
          selectedCareer: null,
        );
        return authenticatedUser;
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
