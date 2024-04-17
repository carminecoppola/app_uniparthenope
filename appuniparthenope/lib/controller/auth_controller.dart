import 'package:flutter/material.dart';
import 'package:appuniparthenope/service/api_service.dart';
import 'package:appuniparthenope/model/user_data.dart';

class AuthController {
  final ApiService apiService = ApiService(); //Richiamo il mio servizio

  // Funzione per navigare in base al ruolo dell'utente
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

  // Funzione per l'autenticazione dell'utente
  Future<User> authUser(
      BuildContext context, String username, String password) async {
    try {
      // Effettua il login chiamando il servizio API
      final Map<String, dynamic> responseData =
          await apiService.login(username, password);

      print('\n\nResponse data: $responseData');

      // Estrae il token e i dati dell'utente dalla risposta
      final String authToken = responseData['authToken'];
      final Map<String, dynamic> userData = responseData['user'];

      // Costruisce un oggetto User con i dati ottenuti
      final User authenticatedUser = User(
        id: userData['id'].toString(),
        name: userData['firstName'],
        surname: userData['lastName'],
        username: userData['userId'],
        password: password,
        role: userData['grpDes'],
      );

      print('\n\nAuthenticated user: $authenticatedUser');

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
  
}
