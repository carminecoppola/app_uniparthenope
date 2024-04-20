import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

class HomePhDPage extends StatelessWidget {
  const HomePhDPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Benvenuti Dottornadi',
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
