import "package:appuniparthenope/widget/bottomNavBar.dart";
import "package:appuniparthenope/widget/navbar.dart";
import "package:flutter/material.dart";

class CourseStudentPage extends StatefulWidget {
  const CourseStudentPage({super.key});

  @override
  State<CourseStudentPage> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavbarComponent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Benvenuto nella pagina dei corsi dello studente!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Qui potresti visualizzare informazioni riguardo ai corsi dello studente',
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
