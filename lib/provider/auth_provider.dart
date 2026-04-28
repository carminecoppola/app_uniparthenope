import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/core/service_locator.dart';
import 'package:appuniparthenope/service/api_login_service.dart';
import 'package:appuniparthenope/service/local_grades_service.dart';
import 'package:appuniparthenope/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_nav_bar_provider.dart';
import 'check_exam_provider.dart';
import 'exam_provider.dart';
import 'professor_provider.dart';
import 'rooms_provider.dart';
import 'taxes_provider.dart';
import 'update_provider.dart';
import 'weather_provider.dart';

/*
Questo provider deve gestire i cambiamenti di stato, ovvero:
- quando l'utente è loggato deve salvare le info dell'utente nel modello User
- deve quidni salvare il token che è fondamentale essere sempre autenticato
- deve permettermi di utilizzare le informazioni dell'utente in diverse pagine
*/
class AuthProvider with ChangeNotifier {
  UserInfo? _authenticatedUser; // Utente autenticato
  UserAnagrafe? _anagrafeUser; // Utente autenticato
  String? _password; //Password dell'utente
  String? _authToken; // Token di autenticazione
  String? _profileImage; // Immagine di profilo dell'utente
  String? _qrCode; // Immagine di profilo dell'utente
  Map<String, dynamic>? _selectedCareer;

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

  // Metodo per ottenere il QR-Code
  String? get qrCode => _qrCode;

  Map<String, dynamic>? get selectedCareer => _selectedCareer;

  // Metodo per impostare l'utente autenticato e il token di autenticazione
  void setAuthenticatedUser(UserInfo user, String myPassword) {
    _authenticatedUser = user;
    _password = myPassword;
    notifyListeners();
  }

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  void setSelectedCareer(TrattiCarriera career) {
    _selectedCareer = career.toJson();
    notifyListeners();
  }

  // Metodo per impostare l'anagrafica dell'utente
  void setAnagrafeUser(UserAnagrafe anagrafeUser) {
    _anagrafeUser = anagrafeUser;
    notifyListeners();
  }

  void setProfileImage(String image) {
    _profileImage = image;
    AppLogger.info(
      'IMG PROVIDER setProfileImage len=${image.length} prefix=${image.length > 32 ? image.substring(0, 32) : image}',
    );
    notifyListeners();
  }

  void setQRCode(String qrCode) {
    _qrCode = qrCode;
    notifyListeners();
  }

  // Metodo per effettuare il logout
  Future<void> logout(BuildContext context) async {
    _authenticatedUser = null;
    _password = null;
    _authToken = null;
    _anagrafeUser = null;
    await ApiService().deleteProfileImage();
    _profileImage = null;
    _qrCode = null;
    _selectedCareer = null;

    // Ripulisci provider stato/sessione
    Provider.of<ExamDataProvider>(context, listen: false).clearCareerData();
    Provider.of<CheckDateExamProvider>(context, listen: false).clearAppelli();
    Provider.of<ProfessorDataProvider>(context, listen: false)
        .clearProfessorData();
    Provider.of<WeatherDataProvider>(context, listen: false).clearWeather();
    Provider.of<TaxesDataProvider>(context, listen: false).clearTaxes();
    Provider.of<RoomsProvider>(context, listen: false).clearRooms();
    Provider.of<UpdateProvider>(context, listen: false).reset();
    Provider.of<BottomNavBarProvider>(context, listen: false).reset();

    // Ripulisci cache locale voti + notifiche
    await getIt<LocalGradesService>().clearAllScopedGrades();
    await getIt<NotificationService>().cancelAll();

    // Ripulisci credenziali salvate/remember-me
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.setBool('rememberMe', false);

    notifyListeners();
  }
}
