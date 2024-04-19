// Aggiorna la HomePage
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeStudentPage extends StatefulWidget {
  const HomeStudentPage({Key? key}) : super(key: key);

  @override
  _HomeStudentPageState createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends State<HomeStudentPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ottieni l'utente autenticato dal provider AuthProvider
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${authenticatedUser?.name ?? ''} ${authenticatedUser?.surname ?? ''}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                // Mostra l'id dell'utente
                'Matricola: ${authenticatedUser?.id ?? ''}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                 Navigator.pushReplacementNamed(context, '/profileStudent');
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
