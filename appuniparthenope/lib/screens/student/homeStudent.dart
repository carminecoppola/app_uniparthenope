// Aggiorna la HomePage
import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeStudentPage extends StatefulWidget {
  const HomeStudentPage({super.key});

  @override
  _HomeStudentPageState createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends State<HomeStudentPage> {
  int _currentIndex = 0;

  final AuthController _anagrafeController = AuthController();

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
      body: Column(
        children: [
          const SizedBox(
            height: 70, // Spazio sopra la card
          ),
          GestureDetector(
            onTap: () {
              _anagrafeStudent(authenticatedUser!);
            },
            child: Container(
              width: 350, //Dimensioni card
              height: 120,
              //Card Studente
              padding: const EdgeInsets.all(20), // Padding interno
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30), // Bordi arrotondati
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${authenticatedUser?.name ?? ''} ${authenticatedUser?.surname ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // Mostra l'id dell'utente
                        '\t\t\t- Id: ${authenticatedUser?.id ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/user_profile.jpg'), //Immagine presa dalla richiesta
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(20.0),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(20.0),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  void _anagrafeStudent(User authenticatedUser) async {
    try {
      final anagrafeUser =
          await _anagrafeController.setAnagrafe(context, authenticatedUser);

      // Utilizza il provider per impostare l'anagrafica dell'utente
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAnagrafeUser(anagrafeUser);

      print(anagrafeUser);
      // Penso di settare in un altro provider i dati dell'utente in maniera globale
    } catch (e) {
      print('Error during setAnagrafe: $e');
    }
  }
}
