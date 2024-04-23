import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/infoStudentTemplate.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);

    final userAnagrafe = Provider.of<AuthProvider>(context).anagrafeUser;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Center(
        child: Card(
          color: AppColors.primaryColor,
          elevation: 10,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 580,
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Student Card',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.detailsColor,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          const AssetImage('assets/user_profile.jpg'),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/user_profile.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                if (userAnagrafe != null) ...[
                  Center(
                    child: Text(
                      '${userAnagrafe.nome.toUpperCase()} ${userAnagrafe.cognome.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColors.detailsColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: Text(
                      ' ${userAnagrafe.codFis}',
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0, // Ridurre lo spazio tra le colonne
                      mainAxisSpacing: 0, // Ridurre lo spazio tra le righe
                      childAspectRatio: 1.8,
                      shrinkWrap: true,
                      children: [
                        const GridTile(
                          child: InfoStudentTemplate(
                            idText: '\u2022 Id',
                            contentText: '\t\t\t\t0124002379',
                          ),
                        ),
                        const GridTile(
                          child: InfoStudentTemplate(
                            idText: '\u2022 Ruolo',
                            contentText: '\t\t\t\tSTUDENT',
                          ),
                        ),
                        GridTile(
                          child: InfoStudentTemplate(
                            idText: '\u2022 Data Nascita',
                            contentText: '\t\t\t\t${userAnagrafe.dataNascita}',
                          ),
                        ),
                        GridTile(
                          child: InfoStudentTemplate(
                            idText: '\u2022 Cellulare',
                            contentText: '\t\t\t\t${userAnagrafe.telRes}',
                          ),
                        ),
                        GridTile(
                          child: InfoStudentTemplate(
                            idText: '\u2022 Username',
                            contentText: '\t\t\t\t${userAnagrafe.nome}',
                          ),
                        ),
                        GridTile(
                          child: InfoStudentTemplate(
                            idText: '\u2022 Sesso',
                            contentText: '\t\t\t\t${userAnagrafe.sesso}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: InfoStudentTemplate(
                      idText: '\u2022 E-mail Universitaria',
                      contentText: userAnagrafe.emailAte,
                    ),
                  ),
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
