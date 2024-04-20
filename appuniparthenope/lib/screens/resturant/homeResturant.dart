import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

class HomeRestaurateursPage extends StatelessWidget {
  const HomeRestaurateursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Benvenuti Ristoratori',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
