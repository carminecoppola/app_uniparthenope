import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/serviceStudentGroup.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/ServicesWidget/calendarCard.dart';
import 'package:appuniparthenope/widget/ServicesWidget/pesonalCardUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeStudentPage extends StatefulWidget {
  const HomeStudentPage({super.key});

  @override
  _HomeStudentPageState createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends State<HomeStudentPage> {
  final AuthController _anagrafeController = AuthController();

  @override
  Widget build(BuildContext context) {
    // Ottieni l'utente autenticato dal provider AuthProvider
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            //Widget dati personali utente
            PersonalCardUser(
              onTap: () {
                _anagrafeStudent(authenticatedUser!);
              },
              firstName: authenticatedUser?.user.firstName ?? '',
              lastName: authenticatedUser?.user.lastName ?? '',
              id: authenticatedUser?.user.trattiCarriera[0].matricola
                  .toString(),
            ),
            const SizedBox(height: 20),
            //Calendario
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Calendario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: const CalendarCard(),
            ),
            const SizedBox(height: 20),
            //Service
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Service',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ServiceGroupStudentCard(
              authenticatedUser: authenticatedUser!,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  void _anagrafeStudent(UserInfo authenticatedUser) async {
    try {
      final anagrafeUser = await _anagrafeController.setAnagrafe(
          context, authenticatedUser.user);

      // Utilizza il provider per impostare l'anagrafica dell'utente
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAnagrafeUser(anagrafeUser);

      print(anagrafeUser);
      // Penso di settare in un altro provider i dati dell'utente in maniera globale
    } catch (e) {
      print('Error during _setAnagrafe: $e');
    }
  }
}
