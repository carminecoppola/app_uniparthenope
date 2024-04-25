import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/service/api_service.dart';
import 'package:appuniparthenope/model/user_data_login.dart';

class AuthController {
  final ApiService apiService = ApiService(); //Richiamo il servizio

  Future<User> authUser(
      BuildContext context, String username, String password) async {
    try {
      // Effettua il login chiamando il servizio API
      final Map<String, dynamic> responseData =
          await apiService.login(username, password);

      // Estrae il token e i dati dell'utente dalla risposta
      final String authToken = responseData['authToken'];
      final Map<String, dynamic> userData = responseData['user'];

      // Costruisce un oggetto User con i dati ottenuti
      final User authenticatedUser = User(
        id: userData['id'],
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        username: userData['userId'],
        password: password,
        role: userData['grpDes'],
        persId: userData['persId'],
        authToken: authToken,
        aliasName: userData['aliasName'],
        codFis: userData['codFis'],
        trattiCarriera: [],
      );

      // Naviga alla schermata corretta in base al ruolo dell'utente
      await navigateByRole(context, authenticatedUser.role);

      return authenticatedUser;
    } catch (e) {
      // Gestisce gli errori durante l'autenticazione
      if (e is Exception && e.toString() == 'Errore durante il login') {
        throw Exception('Credenziali non valide');
      } else {
        rethrow;
      }
    }
  }

  Future<void> navigateByRole(BuildContext context, String role) async {
    switch (role) {
      //else if(_result.user.grpDes === "Registrati" || _result.user.grpDes === "Dottorandi" || _result.user.grpDes === "Ipot. Immatricolati" || _result.user.grpDes === "Preiscritti" || _result.user.grpDes=== "Iscritti"){
      case 'Docenti':
        Navigator.pushReplacementNamed(context, '/homeTeacher');
        break;
      case 'Studenti':
        Navigator.pushReplacementNamed(context, '/homeStudent');
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
          await apiService.studentAnagrafe(student);

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

  getUserProfileImage(User user) {}

  //Nuova funzione che salva l'immagine
}
