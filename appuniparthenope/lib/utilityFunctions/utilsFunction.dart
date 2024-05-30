import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'studentUtilsFunction.dart';

class UtilsFunction {
  static Future<void> authUser(
      BuildContext context, String username, String password) async {
    final AuthController authController = AuthController();

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
      await StudentUtils.userImg(context);

      Navigator.pushReplacementNamed(context, '/homePage');
    } catch (e) {
      print('Errore durante l\'autenticazione: $e');
    }
  }
}
