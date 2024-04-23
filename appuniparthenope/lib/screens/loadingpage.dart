import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/screens/loginpage.dart';
import 'package:flutter/material.dart';

class LoadingFristPage extends StatelessWidget {
  const LoadingFristPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 180,
              width: 180,
            ),
            const SizedBox(height: 120), // Spazio tra l'immagine e il bottone
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginForm()),
                ); // Naviga alla pagina LoginForm quando il bottone viene premuto
              },
              child: Text(
                'Entra con le credenziali di Ateneo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
