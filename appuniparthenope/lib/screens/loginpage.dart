import 'dart:async';
import 'dart:math';
import 'package:appuniparthenope/utilityFunctions/authUtilsFunction.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../app_localizations.dart';
import '../main.dart';
import '../widget/waveWidget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  final List<String> universityImages = [
    'assets/university/uni_monte.jpg',
    'assets/university/uni_cdn.png',
    'assets/university/uni_centrale.png',
    'assets/university/uni_medina.jpeg',
    'assets/university/uni_nola.jpeg',
    'assets/university/uni_villadoria.jpeg',
    'assets/university/caroselloSedi/SedeC2.png',
    'assets/university/caroselloSedi/SedeC3.png',
    'assets/university/caroselloSedi/SedeCD2.png',
    'assets/university/caroselloSedi/SedeCD3.png',
    'assets/university/caroselloSedi/SedeCD4.png',
    'assets/university/caroselloSedi/SedePaca2.png',
    'assets/university/caroselloSedi/SedePaca3.png',
    'assets/university/caroselloSedi/SedeVDA1.png',
    'assets/university/caroselloSedi/SedeVDA2.png',
    'assets/university/caroselloSedi/SedeVDA3.png',
  ];

  late String currentImage;
  late Timer _timer;
  bool _biometricAvailable = false;
  BiometricType? _biometricType;
  bool _loading = false;
  bool _rememberMe = false; // Variabile per il salvataggio delle credenziali
  bool _obscurePassword = true; // Variabile per la visibilità della password

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
    _checkBiometricAvailability();
    _loadSavedCredentials(); // Carica le credenziali salvate al lancio dell'app
  }

  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _checkBiometricAvailability() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        setState(() {
          _biometricAvailable = true;
          _biometricType = availableBiometrics.first;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _authenticateBiometric() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedUsername = prefs.getString('username');
    final String? savedPassword = prefs.getString('password');

    if (savedUsername == null || savedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: AppColors.detailsColor,
            content: Text(
              AppLocalizations.of(context).translate('no_bioauth_saved'),
            )),
      );
      return;
    }

    setState(() {
      _loading = true; // Mostra il dialogo di caricamento
    });

    bool authenticated = await _localAuthentication.authenticate(
      localizedReason: 'Please authenticate to login',
    );

    setState(() {
      _loading = false; // Nascondi il dialogo di caricamento
    });

    if (authenticated) {
      _usernameController.text = savedUsername;
      _passwordController.text = savedPassword;
      _login();
    }
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.detailsColor,
          content: Text(
              AppLocalizations.of(context).translate('insert_credentials')),
        ),
      );
      return;
    }

    setState(() {
      _loading = true; // Mostra il dialogo di caricamento
    });

    await AuthUtilsFunction.authUser(context, username, password);

    setState(() {
      _loading = false; // Nascondi il dialogo di caricamento
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('username', username);
      await prefs.setString('password', password);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
    await prefs.setBool('rememberMe', _rememberMe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      // Tipo di animazione
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      currentImage,
                      key: ValueKey<String>(currentImage),
                      height: kIsWeb ? 400 : 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: kIsWeb ? 35 : 45,
                  child: Image.asset(
                    'assets/logo.png',
                    height: kIsWeb ? 150 : 75,
                    width: kIsWeb ? 150 : 75,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: kIsWeb ? 50.0 : 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      AppLocalizations.of(context).translate('login'),
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
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
                            labelText: AppLocalizations.of(context)
                                .translate('username'),
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText:
                              _obscurePassword, // Controlla la visibilità
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryColor,
                              shape:
                                  const CircleBorder(), // Rende il checkbox rotondo
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('rememberme'),
                              style: const TextStyle(
                                color: AppColors.lightGray,
                              ),
                            ),
                          ],
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
                        horizontal: kIsWeb ? 100.0 : 70.0,
                        vertical: kIsWeb ? 20.0 : 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: AppColors.primaryColor,
                    elevation: 10,
                    shadowColor: Colors.white,
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('login'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_biometricAvailable)
                  TextButton(
                    onPressed: _authenticateBiometric,
                    child: Image.asset(
                      _biometricType == BiometricType.face
                          ? 'assets/icon/faceid.png'
                          : 'assets/icon/fingerprint.png',
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
                  child: Text(
                    AppLocalizations.of(context).translate('resetpsw'),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/homeGuest');
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('loginguest'),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Aggiungi CustomPaint per disegnare l'onda inferiore senza bord
          // Dialogo di caricamento
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomLoadingIndicator(
                      text: AppLocalizations.of(context).translate('loading'),
                      myColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      // bottomNavigationBar: CustomPaint(
      //   size: Size(MediaQuery.of(context).size.width,
      //       MediaQuery.of(context).size.height * 0.1), // Altezza dell'onda
      //   painter: BottomWavePainter(),
      // ),
    );
  }
}
