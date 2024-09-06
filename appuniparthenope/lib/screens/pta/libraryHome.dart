import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/LibraryWidget/libraryCard.dart';
import 'package:flutter/material.dart';
import '../../widget/navbar.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(role: 'PTA'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/logo.png',
                      height: 80,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Biblioteca',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LibraryCard(
                imagePath: 'assets/addUser.jpg',
                title: 'Registrazione Utente',
                subtitle: 'Qui puoi registrare un nuovo utente',
                imageSize: 100,
                onTap: () {
                  Navigator.pushNamed(context, '/registrationLibrary');
                },
              ),
              const SizedBox(height: 16),
              LibraryCard(
                imagePath: 'assets/scanCode.jpg',
                title: 'Ingressi giornalieri',
                subtitle:
                    'Visualizza gli accessi giornalieri degli utenti nella biblioteca',
                imageSize: 200,
                onTap: () {
                  Navigator.pushNamed(context, '/viewAllAccessLibrary');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
