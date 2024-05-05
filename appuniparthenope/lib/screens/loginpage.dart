import 'package:appuniparthenope/model/studentService/calendar_data.dart';
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

  List<EventsInfo>? events;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            height: 20.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
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
          const SizedBox(height: 10.0),
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
            height: 30.0,
          ),
          ElevatedButton(
            onPressed: () {
              _authUser(
                  context, _usernameController.text, _passwordController.text);
              //_userImg(context);
            },
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
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
            onPressed: () {
              // Azione per gestire il click su "PasswordDimenticata?"
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
        ],
      ),
    );
  }

  void _authUser(BuildContext context, String username, String password) async {
    //Credenziali HardCore
    username = "carmine.coppola";
    password = "CppCmn01_";

    try {
      final authenticatedUser =
          await _authController.authUser(context, username, password);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuthenticatedUser(authenticatedUser, password);
    } catch (e) {
      print('Error during authentication: $e');
    }
  }

  void _userImg(BuildContext context) async {
    try {
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
      if (authenticatedUser != null) {
        final profileImage = await _authController.getUserProfileImage(
            authenticatedUser.user, context);

        // Utilizza il provider per impostare l'immagine di profilo
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setProfileImage(profileImage);
      } else {
        print('Authenticated user is null');
      }
    } catch (e) {
      print('Error during _userImg(): $e');
    }
  }
}
