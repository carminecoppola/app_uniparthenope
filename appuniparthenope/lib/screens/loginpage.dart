import 'package:flutter/material.dart';
import 'package:appuniparthenope/controller/auth_controller.dart'; // Importa il controller di autenticazione

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Creazione di un'istanza del controller di autenticazione
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
            // Qui puoi gestire l'input dell'utente per lo username
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
            // Qui puoi gestire l'input dell'utente per la password
          ),
          ElevatedButton(
            onPressed: () {
              // Chiamata al metodo di autenticazione quando l'utente preme il pulsante
              _authUser();
            },
            child: const Text('Accedi'),
          ),
        ],
      ),
    );
  }

  // Metodo per gestire l'autenticazione
  void _authUser() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Chiamata al metodo di autenticazione del controller di autenticazione
    _authController.authUser(context, username, password);
  }
}
