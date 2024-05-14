import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/controller/weather_controller.dart';
import 'package:appuniparthenope/provider/weather_provider.dart';
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

  static Future<void> logout(BuildContext context) async {
    final ApiService logoutController = ApiService();
    try {
      await logoutController.logout(context);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  static Future<void> getWeather(BuildContext context) async {
    final WeatherController weatherController = WeatherController();

    const latitude = 40.7;
    const longitude = 14.17;

    try {
      final allTimeSeries = await weatherController.getAllWeatherTime(
          context, latitude, longitude);
      final weatherDataProvider =
          Provider.of<WeatherDataProvider>(context, listen: false);
      weatherDataProvider.setWeatherInfo(allTimeSeries);
    } catch (e) {
      print('Error during getWeather(): $e');
    }
  }
}
