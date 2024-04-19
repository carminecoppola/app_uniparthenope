import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/service/api_service.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:provider/provider.dart';

class AuthController {
  final ApiService apiService = ApiService(); //Richiamo il servizio

  // Funzione per l'autenticazione dell'utente
  /*Future<User> authUser(
      BuildContext context, String username, String password) async {
    try {
      // Effettua il login chiamando il servizio API
      final Map<String, dynamic> responseData = await apiService.login(username, password);

      print('\n\nResponse data: $responseData');

      // Estrae il token e i dati dell'utente dalla risposta
      final String authToken = responseData['authToken'];
      
      print('\n-authToken: $authToken');

      final Map<String, dynamic> userData = responseData['user'];

      final int persId = userData['persId'] as int;
      print('\n-PersId: $persId');

      // Costruisce un oggetto User con i dati ottenuti
      final User authenticatedUser = User(
        id: userData['id'],
        name: userData['firstName'],
        surname: userData['lastName'],
        username: userData['userId'],
        password: password,
        role: userData['grpDes'],
        persId: userData['persId'], 
        authToken: authToken,
      );
      
      
      // Naviga alla schermata corretta in base al ruolo dell'utente
      await navigateByRole(context, authenticatedUser.role);

      return authenticatedUser;
    } catch (e) {
      // Gestisce gli errori durante l'autenticazione
      print('Error during authentication: $e');
      // Mostra una finestra di dialogo con un messaggio di errore
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Errore'),
            content: const Text('Credenziali non valide'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Solleva un'eccezione con un messaggio di errore
      throw Exception('Credenziali non valide');
    }
  }
  */
  // Funzione per navigare in base al ruolo dell'utente

  Future<User> authUser(
      BuildContext context, String username, String password) async {
    try {
      // Effettua il login chiamando il servizio API
      final Map<String, dynamic> responseData =
          await apiService.login(username, password);

      // Estrae il token e i dati dell'utente dalla risposta
      final String authToken = responseData['authToken'];
      final Map<String, dynamic> userData = responseData['user'];

      print('User: $userData');

      // Costruisce un oggetto User con i dati ottenuti
      final User authenticatedUser = User(
        id: userData['id'],
        name: userData['firstName'],
        surname: userData['lastName'],
        username: userData['userId'],
        password: password,
        role: userData['grpDes'],
        persId: userData['persId'],
        authToken: authToken,
        aliasName: userData['aliasName'],
        codFis: userData['codFis'],
        trattiCarriera: [],
      );

      print('User: \n ${authenticatedUser} \n\n');

      // Naviga alla schermata corretta in base al ruolo dell'utente
      await navigateByRole(context, authenticatedUser.role);

      return authenticatedUser;
    } catch (e) {
      // Gestisce gli errori durante l'autenticazione
      throw Exception('Credenziali non valide');
    }
  }

  Future<void> navigateByRole(BuildContext context, String role) async {
    switch (role) {
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

  // Funzione per il logout
  Future<void> logout(String authToken) async {
    try {
      await apiService.logout(authToken);
    } catch (e) {
      print('Errore durante il logout: $e');
    }
  }
}
