import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/serviceUserGroup.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/ServicesWidget/personalHomeWidget.dart';
import '../widget/bottomNavBarProf.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            if (authenticatedUser?.user.grpDes == 'Studenti')
              PersonalCardUser(
                onTap: () async {
                  StudentUtils.anagrafeStudent(
                      context, authenticatedUser!.user);
                  StudentUtils.userImg(context);
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
                  StudentUtils.anagrafeStudent(context, authenticatedUser.user);
                  //StudentUtils.userImg(context);
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
