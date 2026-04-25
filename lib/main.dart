import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/core/service_locator.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottom_nav_bar_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:appuniparthenope/provider/weather_provider.dart';
import 'package:appuniparthenope/provider/update_provider.dart';
import 'package:appuniparthenope/screens/loginpage.dart';
import 'package:appuniparthenope/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/app_routes.dart';
import 'package:provider/provider.dart';

import 'provider/check_exam_provider.dart';
import 'provider/rooms_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

// 🧪 Per testare le notifiche, decommenta questa riga e usa TestGradesHelper nel terminale
// import 'package:appuniparthenope/service/test_grades_helper.dart';

void main() async {
  // Inizializza i binding di Flutter PRIMA di tutto
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza Dependency Injection
  setupServiceLocator();

  // Inizializza il servizio di notifiche
  final notificationService = getIt<NotificationService>();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ExamDataProvider()),
        ChangeNotifierProvider(create: (context) => CheckDateExamProvider()),
        ChangeNotifierProvider(create: (context) => ProfessorDataProvider()),
        ChangeNotifierProvider(create: (context) => WeatherDataProvider()),
        ChangeNotifierProvider(create: (context) => TaxesDataProvider()),
        ChangeNotifierProvider(create: (context) => RoomsProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (context) => UpdateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: const [
          Locale('en'), // Inglese
          Locale('it'), // Italiano
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const LoginForm(),
        theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.primaryColor, // Cambia il colore del cursore
            selectionColor: AppColors.primaryColor
                .withValues(alpha: 0.5), // Cambia colore selezione
            selectionHandleColor: AppColors
                .primaryColor, // Cambia colore delle maniglie di selezione
          ),
        ),
        routes: AppRoutes.routes,
        initialRoute: '/',
        debugShowCheckedModeBanner: false);
  }
}

class AppColors {
  //static const Color primaryColor = Color.fromRGBO(54, 126, 168, 1);
  static const Color primaryLightColor = Color.fromARGB(255, 98, 160, 193);
  static const Color primaryColor = Color.fromRGBO(69, 139, 177, 1);
  static const Color primaryDarkColor = Color.fromARGB(255, 20, 94, 129);
  static const Color accentColor = Color.fromARGB(255, 206, 134, 11);
  static const Color detailsColor = Color.fromRGBO(231, 171, 27, 1);
  static const Color detailsDarkColor = Color.fromARGB(255, 153, 117, 35);
  static const Color errorColor = Color.fromRGBO(178, 31, 31, 1);
  static const Color successColor = Color.fromRGBO(48, 186, 23, 1);
  static const Color textColor = Colors.black;
  static const Color lightGray = Colors.grey;
  static const Color backgroundColor = Colors.white;

  static const LinearGradient blueGradient = LinearGradient(
    colors: [
      primaryLightColor,
      primaryColor,
      primaryDarkColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [
      detailsColor,
      detailsDarkColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Widget gradientBlueText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => blueGradient.createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }

  Widget gradientYellowText(String text, TextStyle style,
      {FontWeight? weight}) {
    return ShaderMask(
      shaderCallback: (bounds) => yellowGradient.createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(
          color: Colors.white,
          fontWeight: weight ?? style.fontWeight,
        ),
      ),
    );
  }

  Widget gradientText(String text, TextStyle style, bool isBold) {
    if (isBold) {
      return gradientYellowText(text, style, weight: FontWeight.w500);
    }

    return gradientBlueText(text, style);
  }
}

String toCamelCase(String? text) {
  return text!.toLowerCase().split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    }
    return '';
  }).join(' ');
}
