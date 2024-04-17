import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

class HomeTeacherPage extends StatelessWidget {
  const HomeTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Benvenuto Professore!',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
