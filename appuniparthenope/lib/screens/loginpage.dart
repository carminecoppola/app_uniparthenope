import 'dart:async';
import 'package:appuniparthenope/utilityFunctions/authUtilsFunction.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../widget/loginPhoto.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  late ImageLogic imageLogic;
  late String currentImage;

  @override
  void initState() {
    super.initState();
    imageLogic = ImageLogic(_onImageChange);
    currentImage = imageLogic.getCurrentImage();
  }

  @override
  void dispose() {
    imageLogic.stopTimer();
    super.dispose();
  }

  void _onImageChange() {
    setState(() {
      currentImage = imageLogic.getCurrentImage();
    });
  }

  Future<void> _authenticateBiometric() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedUsername = prefs.getString('username');
    final String? savedPassword = prefs.getString('password');

    if (savedUsername == null || savedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Salva le credenziali prima di usare l\'autenticazione biometrica'),
        ),
      );
      return;
    }

    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return;
    }

    List<BiometricType> availableBiometrics =
        await _localAuthentication.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      return;
    }

    bool authenticated = await _localAuthentication.authenticate(
      localizedReason: 'Please authenticate to login',
    );

    if (authenticated) {
      _usernameController.text = savedUsername;
      _passwordController.text = savedPassword;
      _login();
    }
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: CustomLoadingIndicator(
                text: 'Autenticazione in corso, per favore attendi...',
                myColor: AppColors.primaryColor,
              ),
            ),
          ),
        );
      },
    );

    await AuthUtilsFunction.authUser(context, username, password);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Transform(
                  transform: Matrix4.skewY(-0.10)..rotateX(0.0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    currentImage,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 45,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 75,
                    width: 75,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: AppColors.primaryColor,
                    elevation: 10,
                    shadowColor: Colors.white,
                  ),
                  child: const Text(
                    'Accedi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: _authenticateBiometric,
                  child: Image.asset(
                    'assets/icon/faceid.png',
                    color: AppColors.lightGray,
                    width: 40,
                    height: 40,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    const url = 'https://passwordreset.microsoftonline.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Impossibile aprire l\'URL: $url';
                    }
                  },
                  child: const Text(
                    'Password Dimenticata?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/homeGuest');
                  },
                  child: const Text(
                    'Accedi come ospite',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
