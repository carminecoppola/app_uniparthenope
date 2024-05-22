import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/service/api_login_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'studentUtilsFunction.dart';

class UtilsFunction {
  static Future<void> authUser(
      BuildContext context, String username, String password) async {
    final AuthController authController = AuthController();

    username = "carmine.coppola";
    password = "CppCmn01_";

    try {
      final authenticatedUser =
          await authController.authUser(context, username, password);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuthenticatedUser(authenticatedUser, password);
      authProvider
          .setAuthToken(authenticatedUser.authToken); // Imposta il token

      // Imposta la carriera selezionata
      authProvider.setSelectedCareer(authenticatedUser.selectedCareer);

      // Precarica i dati necessari per la homepage
      await StudentUtils.userImg(context);

      // Naviga alla schermata corretta in base al ruolo dell'utente
      await AuthController.navigateByRole(
          context, authenticatedUser.user.grpDes);
    } catch (e) {
      print('Errore durante l\'autenticazione: $e');
    }
  }

  static Future<void> logout(BuildContext context) async {
    final ApiService logoutController = ApiService();
    try {
      await logoutController.logout(context);
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
