import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/serviceUserGroup.dart';
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
  @override
  Widget build(BuildContext context) {
    // Ottieni l'utente autenticato dal provider AuthProvider
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            //Widget dati personali utente
            PersonalCardUser(
              onTap: () async {
                StudentUtils.anagrafeStudent(context, authenticatedUser!.user);
                StudentUtils.userImg(context);
                // if (authenticatedUser != null) {
                //   StudentUtils.fetchAnagrafeDataAndProfileImage(
                //       context, authenticatedUser.user);
                // }
              },
              firstName: authenticatedUser?.user.firstName ?? '',
              lastName: authenticatedUser?.user.lastName ?? '',
              id: authenticatedUser?.user.trattiCarriera[0].matricola
                  .toString(),
              profileImage: profileImage,
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
}
