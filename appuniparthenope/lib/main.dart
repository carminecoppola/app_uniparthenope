import 'package:appuniparthenope/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uniparthenope'),
        ),
        body: const LoginForm(),
      ),
      routes: AppRoutes.routes,
      initialRoute: '/',
    );
  }
}

class AppColors {
  static const Color primaryColor = Color.fromRGBO(54, 126, 168, 1);
  static const Color accentColor = Colors.orange;
  static const Color textColor = Colors.black;
  static const Color lightGray = Colors.grey;
  static const Color backgroundColor = Colors.white;
}