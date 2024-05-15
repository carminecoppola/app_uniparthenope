import 'package:appuniparthenope/model/studentService/taxes_data.dart';
import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/service/api_login_service.dart';
import 'package:appuniparthenope/model/user_data_login.dart';

import '../widget/alertDialog.dart';

class AuthController {
  final ApiService apiService = ApiService(); //Richiamo il servizio

  Future<UserInfo> authUser(
      BuildContext context, String username, String password) async {
    try {
      // Effettua il login chiamando il servizio API
      final Map<String, dynamic> responseData =
          await apiService.login(username, password, context);

      // Estrae il token e i dati dell'utente dalla risposta
      final String authToken = responseData['authToken'];
      final Map<String, dynamic> userData = responseData['user'];

      // Costruisce un oggetto User con i dati ottenuti
      final UserInfo authenticatedUser = UserInfo(
        authToken: authToken,
        user: User.fromJson(userData),
      );

      return authenticatedUser;
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
            );
          },
        );
      }

      rethrow;
    }
  }

  static Future<void> navigateByRole(BuildContext context, String role) async {
    switch (role) {
      //else if(_result.user.grpDes === "Registrati" || _result.user.grpDes === "Dottorandi" || _result.user.grpDes === "Ipot. Immatricolati" || _result.user.grpDes === "Preiscritti" || _result.user.grpDes=== "Iscritti"){
      case 'Docenti':
        //Navigator.pushReplacementNamed(context, '/homeStudent');
        Navigator.pushReplacementNamed(context, '/homeTeacher');
        break;
      case 'Studenti':
        Navigator.pushReplacementNamed(context, '/homeStudent');
        //Navigator.pushReplacementNamed(context, '/homeTeacher');
        break;
      case 'Ristoranti':
        Navigator.pushReplacementNamed(
            context, '/homeRestaurant'); //Da implementare
        break;
      default:
        Navigator.pushReplacementNamed(context, '/homeGuest'); //Da implementare
        break;
    }
  }

  Future<UserAnagrafe> setAnagrafe(BuildContext context, User student) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.studentAnagrafe(student, context);

      final UserAnagrafe anagrafeUser = UserAnagrafe(
        nome: responseData['nome'],
        cognome: responseData['cognome'],
        codFis: responseData['codFis'],
        dataNascita: responseData['dataNascita'],
        desCittadinanza: responseData['desCittadinanza'],
        email: responseData['email'],
        emailAte: responseData['emailAte'],
        sesso: responseData['sesso'],
        telRes: responseData['telRes'],
      );

      Navigator.pushReplacementNamed(context, '/profileStudent',
          arguments: anagrafeUser);

      return anagrafeUser;
    } catch (e) {
      print('Error during setAnagrafe: $e');
      throw Exception('Errore nella fase di acquisizione dei dati anagrafici');
    }
  }

  Future<String> getUserProfileImage(User student, BuildContext context) async {
    try {
      // Chiamata all'API per ottenere l'immagine di profilo dello studente
      final String profileImage =
          await apiService.userProfileImage(student, context);

      //print('\n\n-Controller:$profileImage');

      //Qui restituisce correttamente la posizione dell'immagine

      return profileImage;
    } catch (e) {
      print('Error during getUserProfileImage$e');
      throw Exception('Errore durante il recupero dell\'immagine di profilo');
    }
  }

  Future<TaxesInfo> setTaxes(BuildContext context, User student) async {
    try {
      // Chiamata all'API per ottenere le tasse dello studente
      final Map<String, dynamic> taxesData =
          await apiService.getTaxes(student, context);

      // Estrai i dati necessari dalle tasse ricevute
      final String semaforo = taxesData['semaforo'];
      final List<Payed> payed = List<Payed>.from(
        taxesData['payed'].map((x) => Payed.fromJson(x)),
      );
      final List<ToPay> toPay = List<ToPay>.from(
        taxesData['to_pay'].map((x) => ToPay.fromJson(x)),
      );

      // Costruisci un oggetto TaxesInfo con i dati ottenuti
      final TaxesInfo taxesInfo = TaxesInfo(
        semaforo: semaforo,
        payed: payed,
        toPay: toPay,
      );

      // Ritorna l'oggetto TaxesInfo
      return taxesInfo;
    } catch (e) {
      print('Error during setTaxes: $e');
      throw Exception(
          'Errore durante il recupero delle informazioni sulle tasse');
    }
  }
}
