import "package:appuniparthenope/widget/bottomNavBar.dart";
import "package:appuniparthenope/widget/navbar.dart";
import "package:flutter/material.dart";

class WatherUniPage extends StatefulWidget {
  const WatherUniPage({super.key});

  @override
  State<WatherUniPage> createState() => _WatherUniState();
}

class _WatherUniState extends State<WatherUniPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavbarComponent(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Benvenuto nella pagina del meteo!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Meteo Parthenope',
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
