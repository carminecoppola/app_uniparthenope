import 'package:appuniparthenope/widget/ServicesWidget/profileWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<BottomNavBarProvider>(context);

    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final matricola = authenticatedUser?.user.trattiCarriera[0].matricola;

    final userAnagrafe = Provider.of<AuthProvider>(context).anagrafeUser;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Center(
        child: Card(
          color: AppColors.primaryColor,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 430,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const HeaderWidget(),
                if (userAnagrafe != null) ...[
                  const AvatarWidget(),
                  UserInfoWidget(userAnagrafe),
                  InfoGridView(
                    userAnagrafe,
                    matricola: matricola,
                  ),
                  EmailWidget(userAnagrafe),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
