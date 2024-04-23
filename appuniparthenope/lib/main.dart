import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
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
      routes: AppRoutes.routes,
      initialRoute: '/',
    );
  }
}

class AppColors {
  static const Color primaryColor = Color.fromRGBO(54, 126, 168, 1);
  static const Color accentColor = Colors.orange;
  static const Color detailsColor = Color.fromRGBO(237, 204, 27, 1);
  static const Color textColor = Colors.black;
  static const Color lightGray = Colors.grey;
  static const Color backgroundColor = Colors.white;
}
