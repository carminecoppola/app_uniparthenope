// Aggiorna il LoginForm
import 'package:appuniparthenope/controller/exam_controller.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController _authController = AuthController();
  final ExamController _examTotController = ExamController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform(
          transform: Matrix4.skewY(-0.10)..rotateX(0.0),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/university/uni_monte.jpg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          radius: 40,
          child: Image.asset(
            'assets/logo.png',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 20.0, // Ridotto lo spazio tra il cerchio e i campi di testo
        ),
        const Padding(
          padding:
              EdgeInsets.only(left: 20.0), // Aggiungi spazio solo a sinistra
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
            height: 10.0), // Spazio tra il testo "Login" e i campi di form
        SizedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
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
        const SizedBox(
          height:
              30.0, // Ridotto lo spazio tra il bottone login e i campi di testo
        ),
        ElevatedButton(
          onPressed: () {
            _authUser(context); // Passa il contesto al metodo _authUser
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: AppColors.primaryColor,
            elevation: 10, // Aumenta l'elevazione del bottone
            shadowColor: Colors.white, // Imposta il colore dell'ombra
          ),
          child: const Text(
            'Accedi',
            style: TextStyle(
              color: Colors.white, // Imposta il colore del testo su bianco
              fontWeight: FontWeight.bold, // Imposta il testo in grassetto
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Azione per gestire il click su "PasswordDimenticata?"
          },
          child: const Text(
            'Password Dimenticata?',
            style: TextStyle(
              color: Colors.grey, // Imposta il colore del testo su grigio
              fontWeight: FontWeight.bold, // Imposta il testo in grassetto
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
              color: Colors.grey, // Imposta il colore del testo su grigio
              fontWeight: FontWeight.bold,
              // Imposta il testo in grassetto
            ),
          ),
        ),
      ],
    );
  }

  void _authUser(BuildContext context) async {
    //Questi sono per il form, adesso per testare mi scoccio di inserirli sempre
    // String username = _usernameController.text;
    // String password = _passwordController.text;

    String username = "carmine.coppola";
    String password = "CppCmn01_";

    try {
      final authenticatedUser =
          await _authController.authUser(context, username, password);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.setAuthenticatedUser(
          authenticatedUser, authenticatedUser.authToken);
    } catch (e) {
      print('Error during authentication: $e');
    }
  }
}
