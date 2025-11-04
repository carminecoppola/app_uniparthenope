import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';

import '../widget/ServicesWidget/PersonalCardWidget/minibox-personal-widget.dart';
import '../widget/ServicesWidget/PersonalCardWidget/profile_info_display.dart';
import '../widget/ServicesWidget/PersonalCardWidget/tabbar_custom.dart';
import '../widget/bottomNavBarProf.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({super.key});

  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final userAnagrafe = Provider.of<AuthProvider>(context).anagrafeUser;

    if (authenticatedUser == null) {
      return Scaffold(
        body: Container(
          color: AppColors.backgroundColor,
          child: const Center(
            child: Text("User not authenticated"),
          ),
        ),
      );
    }

    final trattiCarriera = authenticatedUser.user.trattiCarriera;
    final selectedCareer = Provider.of<AuthProvider>(context).selectedCareer;
    final idStud = selectedCareer != null ? selectedCareer['matricola'] : null;
    final identificativoProf = authenticatedUser.user.docenteId;
    final facCod = trattiCarriera.isNotEmpty
        ? trattiCarriera[0].dettaglioTratto.facCod
        : null;
    final role = authenticatedUser.user.grpDes;
    final identificativoLabel = role == 'Docenti' ? 'ID Docente' : 'Matricola';

    final String backgroundConfig = facCod != null
        ? _chooseBackground(facCod)
        : 'assets/university/uni_monte.jpg';

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.asset(
                backgroundConfig,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (userAnagrafe != null) ...[
                      if (role == 'Studenti') ...[
                        PersonalMiniBoxWidget(
                          nome: userAnagrafe.nome,
                          cognome: userAnagrafe.cognome,
                          identificativoLabel: identificativoLabel,
                          identificativo: idStud.toString(),
                        ),
                      ] else ...[
                        PersonalMiniBoxWidget(
                            nome: userAnagrafe.nome,
                            cognome: userAnagrafe.cognome,
                            identificativoLabel: identificativoLabel,
                            identificativo: identificativoProf.toString()),
                      ],
                    ] else ...[
                      const Center(
                        child: PersonalMiniBoxWidget(
                          nome: 'Nome non disponibile',
                          cognome: 'Cognome non disponibile',
                          identificativoLabel: 'N/A',
                          identificativo: 'N/A',
                        ),
                      )
                    ],
                    const SizedBox(height: 10),
                    CustomTabBar(
                      selectedIndex: _selectedIndex,
                      onTabTapped: _onTabTapped,
                    ),
                    const SizedBox(height: 20),
                    IndexedStack(
                      index: _selectedIndex,
                      children: const [
                        ProfileInfoDisplay(index: 0),
                        ProfileInfoDisplay(index: 1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }

  // Metodo per scegliere lo sfondo in base al codice della facoltà
  String _chooseBackground(String? facCod) {
    switch (facCod) {
      case 'S1':
        return 'assets/university/uni_monte.jpg';
      case 'S2':
        return 'assets/university/uni_cdn.png';
      case 'S3':
        return 'assets/university/uni_medina.jpeg';
      case 'S4':
        return 'assets/university/uni_centrale.png';
      case 'S5':
        return 'assets/university/uni_nola.jpeg';
      case 'S6':
        return 'assets/university/uni_villadoria.jpeg';
      default:
        return 'assets/university/uni_monte.jpg';
    }
  }
}
