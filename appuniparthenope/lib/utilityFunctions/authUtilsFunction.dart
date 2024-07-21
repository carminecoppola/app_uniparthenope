import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

/// Classe di utility per le operazioni di autenticazione e gestione dell'utente.
class AuthUtilsFunction {
  /// Gestisce l'autenticazione dell'utente e la navigazione alla homepage.
  static Future<void> authUser(
      BuildContext context, String username, String password) async {
    final AuthController authController = AuthController();

    try {
      // Autentica l'utente con il controller specificato.
      final authenticatedUser =
          await authController.authUser(context, username, password);

      // Ottiene il provider per impostare i dati dell'utente autenticato.
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Imposta l'utente autenticato e il token di autenticazione nel provider.
      authProvider.setAuthenticatedUser(authenticatedUser, password);
      authProvider.setAuthToken(authenticatedUser.authToken);

      // Se l'utente non è un docente, imposta la carriera selezionata.
      if (authenticatedUser.user.grpDes != 'Docenti') {
        authProvider.setSelectedCareer(authenticatedUser.selectedCareer!);
      }

      // Carica l'immagine dell'utente per la homepage.
      await AuthUtilsFunction.userImg(context);

      // Naviga alla homepage dopo l'autenticazione.
      Navigator.pushReplacementNamed(context, '/homePage');
    } catch (e) {
      print('Errore durante l\'autenticazione: $e');
    }
  }

  /// Carica l'immagine del profilo dell'utente autenticato.
  static Future<void> userImg(BuildContext context) async {
    final AuthController authController = AuthController();
    try {
      // Ottiene l'utente autenticato dal provider.
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

      // Se l'utente è valido, carica l'immagine del profilo.
      if (authenticatedUser != null) {
        final profileImage = await authController.getUserProfileImage(
            authenticatedUser.user, context);

        // Aggiorna l'immagine di profilo nel provider.
        if (context.mounted) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          authProvider.setProfileImage(profileImage);
        }
      } else {
        print('Authenticated user is null');
      }
    } catch (e) {
      print('\nError during userImg(): $e');
    }
  }

  /// Carica il codice QR dell'utente autenticato.
  static Future<void> qrCodeImg(BuildContext context) async {
    final AuthController authController = AuthController();
    try {
      // Ottiene l'utente autenticato dal provider.
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

      // Se l'utente è valido, carica il codice QR.
      if (authenticatedUser != null) {
        final qrCode =
            await authController.getUserQRCode(authenticatedUser.user, context);

        // Aggiorna il codice QR nel provider.
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setQRCode(qrCode);
      } else {
        print('Authenticated user is null');
      }
    } catch (e) {
      print('\nError during qrCodeImg(): $e');
    }
  }
}
