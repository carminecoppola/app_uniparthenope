import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

class HomeGuestPage extends StatelessWidget {
  const HomeGuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const NavbarComponent(),
        body: Container(
          color: Colors.white, // Colore di sfondo bianco
          child: const Center(
            child: Text(
              'Benvenuto Ospite',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
