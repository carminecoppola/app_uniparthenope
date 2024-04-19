// Aggiorna il LoginForm
import 'package:flutter/material.dart';
import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              _authUser(context); // Passa il contesto al metodo _authUser
            },
            child: const Text('Accedi'),
          ),
        ],
      ),
    );
  }

  void _authUser(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

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
