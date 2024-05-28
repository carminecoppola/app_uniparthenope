import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';

import '../widget/ServicesWidget/PersonalCardWidget/personal_card.dart';
import '../widget/ServicesWidget/PersonalCardWidget/profile_info_display.dart';
import '../widget/ServicesWidget/PersonalCardWidget/tabbar_custom.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({Key? key});

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

    final trattiCarriera = authenticatedUser?.user.trattiCarriera;
    final identificativo = trattiCarriera != null && trattiCarriera.isNotEmpty
        ? trattiCarriera[0].matricola
        : 'N/A';
    final facCod = trattiCarriera != null && trattiCarriera.isNotEmpty
        ? trattiCarriera[0].dettaglioTratto.facCod
        : null;
    final role = authenticatedUser?.user.grpDes;
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
                    PersonalCardWidget(
                      nome: userAnagrafe?.nome ?? 'Nome non disponibile',
                      cognome:
                          userAnagrafe?.cognome ?? 'Cognome non disponibile',
                      identificativoLabel: identificativoLabel,
                      identificativo: identificativo != null
                          ? identificativo.toString()
                          : 'N/A',
                    ),
                    const SizedBox(height: 8),
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
      bottomNavigationBar: const BottomNavBarComponent(),
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
