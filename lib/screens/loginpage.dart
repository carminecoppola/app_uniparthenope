import 'dart:async';
import 'dart:math';
import 'package:appuniparthenope/utilityFunctions/auth_utils_function.dart';
import 'package:appuniparthenope/widget/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../app_localizations.dart';
import '../main.dart';
import '../widget/wave_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
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
  Timer? _timer;
  bool _biometricAvailable = false;
  BiometricType? _biometricType;
  bool _loading = false;
  bool _rememberMe = false; // Variabile per il salvataggio delle credenziali
  bool _obscurePassword = true; // Variabile per la visibilità della password
  bool _authInProgress = false;

  @override
  void initState() {
    super.initState();
    currentImage = universityImages[Random().nextInt(universityImages.length)];
    // Lasciamo respirare il primo frame prima di attività non critiche.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBackgroundLoginUiTasks();
    });
  }

  void _startBackgroundLoginUiTasks() {
    if (!mounted) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      setState(() {
        currentImage =
            universityImages[Random().nextInt(universityImages.length)];
      });
    });

    _loadSavedCredentials();
    _checkBiometricAvailability();
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
    try {
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      final isDeviceSupported = await _localAuthentication.isDeviceSupported();
      if (!mounted) return;
      if (canCheckBiometrics || isDeviceSupported) {
        final availableBiometrics =
            await _localAuthentication.getAvailableBiometrics();
        if (!mounted) return;
        if (availableBiometrics.isNotEmpty) {
          setState(() {
            _biometricAvailable = true;
            _biometricType = availableBiometrics.first;
          });
        }
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _biometricAvailable = false;
        _biometricType = null;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _authenticateBiometric() async {
    if (_authInProgress) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedUsername = prefs.getString('username');
    final String? savedPassword = prefs.getString('password');

    if (!mounted) return;

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
      _authInProgress = true;
    });

    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (_) {
      authenticated = false;
    } catch (_) {
      authenticated = false;
    }

    if (!mounted) return;

    setState(() {
      _loading = false; // Nascondi il dialogo di caricamento
      _authInProgress = false;
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

    if (!mounted) return;

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
    final localizations = AppLocalizations.of(context);
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF6FAFE),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: kIsWeb ? 430 : 310,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(42),
                          bottomRight: Radius.circular(42),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Stack(
                            key: ValueKey<String>(currentImage),
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                currentImage,
                                fit: BoxFit.cover,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.16),
                                      AppColors.primaryDarkColor
                                          .withValues(alpha: 0.64),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            topInset + 18,
                            24,
                            28,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              Container(
                                width: 86,
                                height: 86,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset('assets/logoWhite.png'),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                localizations.translate('login'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          cursorColor: AppColors.primaryColor,
                          controller: _usernameController,
                          decoration: _buildInputDecoration(
                            context,
                            label: localizations.translate('username'),
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          decoration: _buildInputDecoration(
                            context,
                            label: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                localizations.translate('rememberme'),
                                style: const TextStyle(
                                  color: AppColors.lightGray,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: AppColors.primaryColor,
                              elevation: 0,
                            ),
                            child: Text(
                              localizations.translate('login'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        if (_biometricAvailable) ...[
                          const SizedBox(height: 14),
                          Center(
                            child: TextButton.icon(
                              onPressed: _authenticateBiometric,
                              icon: Image.asset(
                                _biometricType == BiometricType.face
                                    ? 'assets/icon/faceid.png'
                                    : 'assets/icon/fingerprint.png',
                                color: AppColors.primaryColor,
                                width: 26,
                                height: 26,
                              ),
                              label: Text(
                                localizations.translate('login'),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSecondaryAction(
                  title: localizations.translate('resetpsw'),
                  onTap: () async {
                    final uri =
                        Uri.parse('https://passwordreset.microsoftonline.com');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      throw 'Impossibile aprire l\'URL: $uri';
                    }
                  },
                  icon: Icons.lock_reset_rounded,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/homeGuest');
                  },
                  icon: const Icon(
                    Icons.explore_outlined,
                    color: AppColors.primaryColor,
                  ),
                  label: Text(
                    localizations.translate('loginguest'),
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          if (_loading)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
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
            ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 78,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.0,
                ),
                painter: BottomWavePainter(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Text(
                'app@Uniparthenope',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context, {
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.primaryColor,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FBFF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor.withValues(alpha: 0.10),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildSecondaryAction({
    required String title,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightGray,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
