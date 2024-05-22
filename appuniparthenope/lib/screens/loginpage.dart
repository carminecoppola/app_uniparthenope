import 'dart:async';
import 'dart:math';
import 'package:appuniparthenope/utilityFunctions/utilsFunction.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> universityImages = [
    'assets/university/uni_monte.jpg',
    'assets/university/uni_cdn.png',
    'assets/university/uni_centrale.png',
    'assets/university/uni_medina.jpeg',
    'assets/university/uni_nola.jpeg',
    'assets/university/uni_villadoria.jpeg',
  ];

  late String currentImage;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    currentImage = universityImages[Random().nextInt(universityImages.length)];
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentImage =
            universityImages[Random().nextInt(universityImages.length)];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () async {
                    UtilsFunction.authUser(context, _usernameController.text,
                        _passwordController.text);
                  },
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
