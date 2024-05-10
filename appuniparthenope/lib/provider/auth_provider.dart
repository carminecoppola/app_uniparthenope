import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/model/user_data_login.dart';

/*
Questo provider deve gestire i cambiamenti di stato, ovvero:
- quando l'utente è loggato deve salvare le info dell'utente nel modello User
- deve quidni salvare il token che è fondamentale essere sempre autenticato
- deve permettermi di utilizzare le informazioni dell'utente in diverse pagine
*/

// Definisci una classe per il provider
class AuthProvider with ChangeNotifier {
  UserInfo? _authenticatedUser; // Utente autenticato
  UserAnagrafe? _anagrafeUser; // Utente autenticato
  String? _password; //Password dell'utente
  String? _authToken; // Token di autenticazione
  String? _profileImage; // Immagine di profilo dell'utente

  // Metodo per ottenere l'utente autenticato
  UserInfo? get authenticatedUser => _authenticatedUser;

  // Metodo per ottenere l'anagrafica dell'utente
  UserAnagrafe? get anagrafeUser => _anagrafeUser;

  // Metodo per ottenere il token di autenticazione
  String? get password => _password;

  // Metodo per ottenere il token di autenticazione
  String? get authToken => _authToken;

  // Metodo per ottenere l'immagine di profilo
  String? get profileImage => _profileImage;

  // Metodo per impostare l'utente autenticato e il token di autenticazione
  void setAuthenticatedUser(UserInfo user, String myPassword) {
    _authenticatedUser = user;
    _password = myPassword;
    notifyListeners();
  }

  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  // Metodo per impostare l'anagrafica dell'utente
  void setAnagrafeUser(UserAnagrafe anagrafeUser) {
    _anagrafeUser = anagrafeUser;
    notifyListeners();
  }

  void setProfileImage(String image) {
    _profileImage = image;
    notifyListeners();
  }

  // Metodo per effettuare il logout
  void logout() {
    _authenticatedUser = null;
    _password = null;
    _authToken = null;
    _anagrafeUser = null;
    notifyListeners();
  }
}
