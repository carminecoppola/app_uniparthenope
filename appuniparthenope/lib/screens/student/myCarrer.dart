import "package:appuniparthenope/widget/bottomNavBar.dart";
import "package:appuniparthenope/widget/navbar.dart";
import "package:flutter/material.dart";

class StudentCarrerPage extends StatefulWidget {
  const StudentCarrerPage({super.key});

  @override
  State<StudentCarrerPage> createState() => _CarrerStudentState();
}

class _CarrerStudentState extends State<StudentCarrerPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavbarComponent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Benvenuto nella pagina della carriera dello studente!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Qui potresti visualizzare informazioni riguardo alla tua carriera accademica, come voti, crediti acquisiti, ecc.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarComponent(),
    );
  }
}
