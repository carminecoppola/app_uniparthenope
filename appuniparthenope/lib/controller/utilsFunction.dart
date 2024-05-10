import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/service/api_login_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class UtilsFunction {
  static Future<void> authUser(
      BuildContext context, String username, String password) async {
    final AuthController authController = AuthController();
    //Credenziali HardCore
    username = "carmine.coppola";
    password = "CppCmn01_";

    try {
      final authenticatedUser =
          await authController.authUser(context, username, password);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuthenticatedUser(authenticatedUser, password);
      authProvider.setAuthToken(authenticatedUser.authToken); //Setto il token
    } catch (e) {
      print('Error during authentication: $e');
    }
  }

  //Occhio qui
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
      print('Error during _userImg(): $e');
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
