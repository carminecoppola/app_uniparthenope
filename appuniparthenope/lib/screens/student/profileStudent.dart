import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informazioni personali',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Nome: John Doe',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Matricola: 123456',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Corso di Laurea: Ingegneria Informatica',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Contatti',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: john.doe@example.com',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Telefono: +1234567890',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarComponent(
        currentIndex: -1, // Nessun bottone selezionato
        onTap: (index) => _onNavBarItemTapped(context, index),
      ),
    );
  }

  // Funzione per gestire il tocco sui bottoni della barra di navigazione
  void _onNavBarItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Torna alla pagina precedente
        Navigator.of(context).pushNamed('/homeStudent');
        break;
      case 1:
        // Naviga alla pagina '/myCareer'
        Navigator.of(context).pushNamed('/myCareer');
        break;
      case 2:
        //Apre il menu in overlay
        // Implementa il codice per aprire il menu
        break;
    }
  }
}
