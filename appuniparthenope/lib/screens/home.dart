import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarCard.dart';
import 'package:appuniparthenope/widget/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/studentUtilsFunction.dart';
import '../widget/ServicesWidget/AppointmentsWidget/homeAppointmentsWidget.dart';
import '../widget/ServicesWidget/personalHomeWidget.dart';
import '../widget/ServicesWidget/serviceUserGroup.dart';
import '../widget/bottomNavBar.dart';
import '../widget/bottomNavBarProf.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
      // Se l'utente è autenticato, esegui altre azioni come caricare i dati dell'utente
      if (authenticatedUser.user.grpDes == 'Studenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        await StudentUtils.allReservationStudent(
            context, authenticatedUser.user);
      } else if (authenticatedUser.user.grpDes == 'Docenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
      } else {
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            if (authenticatedUser?.user.grpDes == 'Studenti')
              PersonalCardUser(
                onTap: () async {
                  StudentUtils.anagrafeUser(context, authenticatedUser!.user);
                  AuthUtilsFunction.userImg(context);
                  Navigator.pushReplacementNamed(context, '/profileStudent',
                      arguments: anagrafeUser);
                },
                firstName: authenticatedUser?.user.firstName ?? '',
                lastName: authenticatedUser?.user.lastName ?? '',
                identificativoLabel: 'Matricola:',
                id: authenticatedUser?.user.trattiCarriera[0].matricola
                    .toString(),
                profileImage: profileImage,
              )
            else
              PersonalCardUser(
                onTap: () async {
                  StudentUtils.anagrafeUser(context, authenticatedUser.user);
                  //StudentUtils.userImg(context);
                  Navigator.pushReplacementNamed(context, '/profileStudent',
                      arguments: anagrafeUser);
                },
                firstName: authenticatedUser?.user.firstName ?? '',
                lastName: authenticatedUser?.user.lastName ?? '',
                identificativoLabel: 'Id Docente:',
                id: authenticatedUser!.user.docenteId != null
                    ? authenticatedUser.user.docenteId.toString()
                    : 'N/A',
                profileImage: profileImage,
              ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Prenotazioni',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
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
            //Prenotazione
            if (authenticatedUser?.user.grpDes == 'Studenti')
              const HomeAppointmentsCard()
            else
              const CalendarCard(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Servizi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            // Renderizza i widget dei servizi in base al ruolo dell'utente
            if (authenticatedUser?.user.grpDes == 'Studenti')
              ServiceGroupStudentCard(
                authenticatedUser: authenticatedUser!,
              )
            else
              ServiceGroupProfCard(
                authenticatedUser: authenticatedUser!,
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }
}
