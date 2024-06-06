import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class AuthUtilsFunction {
  static Future<void> authUser(
      BuildContext context, String username, String password) async {
    final AuthController authController = AuthController();

    username = 'carmine.coppola';
    password = 'CppCmn01_';
    // username = 'MNTRFL72E10F839I';
    // password = 'Sarima44iv\$!';

    try {
      final authenticatedUser =
          await authController.authUser(context, username, password);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuthenticatedUser(authenticatedUser, password);
      authProvider.setAuthToken(authenticatedUser.authToken);

      // Se il gruppo dell'utente è 'Docenti', non impostare la carriera
      if (authenticatedUser.user.grpDes != 'Docenti') {
        // Imposta la carriera selezionata
        authProvider.setSelectedCareer(authenticatedUser.selectedCareer!);
      }

      // Precarica i dati necessari per la homepage
      await AuthUtilsFunction.userImg(context);

      Navigator.pushReplacementNamed(context, '/homePage');
    } catch (e) {
      print('Errore durante l\'autenticazione: $e');
    }
  }

  static Future<void> userImg(BuildContext context) async {
    final AuthController authController = AuthController();
    try {
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
      if (authenticatedUser != null) {
        final profileImage = await authController.getUserProfileImage(
            authenticatedUser.user, context);

        // Utilizza il provider per impostare l'immagine di profilo
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setProfileImage(profileImage);
      } else {
        print('Authenticated user is null');
      }
    } catch (e) {
      print('\nError during userImg(): $e');
    }
  }

  static Future<void> qrCodeImg(BuildContext context) async {
    final AuthController authController = AuthController();
    try {
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
      if (authenticatedUser != null) {
        final qrCode =
            await authController.getUserQRCode(authenticatedUser.user, context);

        // Utilizza il provider per impostare l'immagine di profilo
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
