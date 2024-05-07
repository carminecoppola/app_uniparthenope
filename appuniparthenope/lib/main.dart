import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:appuniparthenope/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ExamDataProvider()),
        ChangeNotifierProvider(create: (context) => TaxesDataProvider()),
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
      home: const Scaffold(
        body: LoginForm(),
      ),
      theme: ThemeData.light(),
      routes: AppRoutes.routes,
      initialRoute: '/',
    );
  }
}

class AppColors {
  //static const Color primaryColor = Color.fromRGBO(54, 126, 168, 1);
  static const Color primaryColor = Color.fromRGBO(69, 139, 177, 1);
  static const Color accentColor = Colors.orange;
  static const Color detailsColor = Color.fromRGBO(231, 171, 27, 1);
  static const Color errorColor = Color.fromRGBO(178, 31, 31, 1);
  static const Color successColor = Color.fromRGBO(48, 186, 23, 1);
  static const Color textColor = Colors.black;
  static const Color lightGray = Colors.grey;
  static const Color backgroundColor = Colors.white;
}
