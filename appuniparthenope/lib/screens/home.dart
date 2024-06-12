import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarCard.dart';
import 'package:appuniparthenope/widget/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/studentUtilsFunction.dart';
import '../widget/HomeWidget/sectionTitle.dart';
import '../widget/ServicesWidget/AppointmentsWidget/homeAppointmentsWidget.dart';
import '../widget/HomeWidget/personalHomeWidget.dart';
import '../widget/HomeWidget/serviceUserGroup.dart';
import '../widget/bottomNavBar.dart';
import '../widget/bottomNavBarProf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

    if (authenticatedUser != null) {
      // Ensure that context is still mounted before performing operations
      if (!mounted) return;

      // Se l'utente è autenticato, ed è uno Studente carica le sue prenotazioni
      if (authenticatedUser.user.grpDes == 'Studenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        if (!mounted) return;
        await StudentUtils.allReservationStudent(
            context, authenticatedUser.user);
      } else if (authenticatedUser.user.grpDes == 'Docenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        //Nel caso carico
      } else {
        if (!mounted) return;
        const CustomAlertDialog(
            title: 'Errore Anagrafica',
            content:
                'Si è verificato un errore nel caricamento dei tuoi dati personali, ci scusiamo.',
            buttonText: 'Chiudi',
            color: AppColors.errorColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final anagrafeUser = Provider.of<AuthProvider>(context).anagrafeUser;
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

    if (authenticatedUser == null) {
      return Scaffold(
        body: Container(
          color: Colors.white,
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            if (authenticatedUser.user.grpDes == 'Studenti') ...[
              PersonalCardUser(
                onTap: () async {
                  if (authenticatedUser != null) {
                    await StudentUtils.anagrafeUser(
                        context, authenticatedUser.user);
                    AuthUtilsFunction.userImg(context);
                    if (anagrafeUser != null) {
                      Navigator.pushReplacementNamed(context, '/profileStudent',
                          arguments: anagrafeUser);
                    } else {
                      const CustomLoadingIndicator(
                        text: 'Caricamento dei tuoi dati personali',
                        myColor: AppColors.primaryColor,
                      );
                    }
                  }
                },
                firstName: authenticatedUser.user.firstName ?? '',
                lastName: authenticatedUser.user.lastName ?? '',
                identificativoLabel: 'Matricola:',
                id: authenticatedUser.user.trattiCarriera[0].matricola
                    .toString(),
                profileImage: profileImage,
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Prenotazioni'),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/reservationStudent');
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Mostra tutte',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const HomeAppointmentsCard(),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Servizi'),
              ServiceGroupStudentCard(
                authenticatedUser: authenticatedUser,
              ),
              const SizedBox(height: 10),
            ] else ...[
              PersonalCardUser(
                onTap: () async {
                  if (authenticatedUser != null) {
                    await StudentUtils.anagrafeUser(
                        context, authenticatedUser.user);
                    if (anagrafeUser != null) {
                      Navigator.pushReplacementNamed(context, '/profileStudent',
                          arguments: anagrafeUser);
                    } else {
                      const CustomLoadingIndicator(
                          text: 'Caricamento dei tuoi dati personali',
                          myColor: AppColors.primaryColor);
                    }
                  }
                },
                firstName: authenticatedUser.user.firstName ?? '',
                lastName: authenticatedUser.user.lastName ?? '',
                identificativoLabel: 'Id Docente:',
                id: authenticatedUser.user.docenteId != null
                    ? authenticatedUser.user.docenteId.toString()
                    : 'N/A',
                profileImage: profileImage,
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Calendario'),
              const CalendarCard(),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Servizi'),
              ServiceGroupProfCard(
                authenticatedUser: authenticatedUser,
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }
}
