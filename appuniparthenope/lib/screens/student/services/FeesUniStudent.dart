import "package:appuniparthenope/widget/bottomNavBar.dart";
import "package:appuniparthenope/widget/navbar.dart";
import "package:flutter/material.dart";

class FeesUniStudentPage extends StatefulWidget {
  const FeesUniStudentPage({super.key});

  @override
  State<FeesUniStudentPage> createState() => _FeesUniStudentState();
}

class _FeesUniStudentState extends State<FeesUniStudentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavbarComponent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Benvenuto nella pagina delle tasse universitarie!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Qui potresti visualizzare informazioni riguardo alle tasse universitarie',
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
