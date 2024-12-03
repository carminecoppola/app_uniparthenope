import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:appuniparthenope/provider/weather_provider.dart';
import 'package:appuniparthenope/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/app_routes.dart';
import 'package:provider/provider.dart';

import 'provider/rooms_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ExamDataProvider()),
        ChangeNotifierProvider(create: (context) => ProfessorDataProvider()),
        ChangeNotifierProvider(create: (context) => WeatherDataProvider()),
        ChangeNotifierProvider(create: (context) => TaxesDataProvider()),
        ChangeNotifierProvider(create: (context) => RoomsProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavBarProvider()),
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
        theme: ThemeData.light(),
        routes: AppRoutes.routes,
        initialRoute: '/',
        debugShowCheckedModeBanner: false);
  }
}

class AppColors {
  //static const Color primaryColor = Color.fromRGBO(54, 126, 168, 1);
  static const Color primaryColor = Color.fromRGBO(69, 139, 177, 1);
  static const Color accentColor = Color.fromARGB(255, 206, 134, 11);
  static const Color detailsColor = Color.fromRGBO(231, 171, 27, 1);
  static const Color errorColor = Color.fromRGBO(178, 31, 31, 1);
  static const Color successColor = Color.fromRGBO(48, 186, 23, 1);
  static const Color textColor = Colors.black;
  static const Color lightGray = Colors.grey;
  static const Color backgroundColor = Colors.white;

  Widget gradientText(String text, TextStyle style, bool isBold) {
    if (isBold) {
      return ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            AppColors.detailsColor,
            Color.fromARGB(255, 153, 117, 35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          text,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color.fromARGB(255, 98, 160, 193),
          Color.fromARGB(255, 20, 94, 129)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
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
