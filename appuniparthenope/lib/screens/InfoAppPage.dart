import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import '../widget/bottomNavBar.dart';
import '../widget/navbar.dart';

class InfoAppPage extends StatelessWidget {
  const InfoAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/logo.png',
            width: 150, // Imposta la larghezza desiderata
            height: 150, // Imposta l'altezza desiderata
          ),
          const SizedBox(height: 12),
          const Text(
            'app@Uniparthenope',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Version: 3.0.6',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Container(
            width: 190,
            height: 2,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 50),
          // Card Meteo
          Center(
            child: SizedBox(
              width: 360,
              height: 300,
              child: Card(
                color: AppColors.primaryColor,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: const [
                      DeveloperInfo(
                        name: 'Raffaele Montela',
                        asset: 'assets/team/team_leader.jpg',
                        role: 'Team leader',
                      ),
                      SizedBox(height: 20),
                      DeveloperInfo(
                        name: 'Carmine Coppola',
                        asset: 'assets/team/cc.png',
                        role: 'Developer',
                      ),
                      SizedBox(height: 20),
                      DeveloperInfo(
                        name: 'Ciro Giuseppe De Vita',
                        asset: 'assets/team/cgdv.png',
                        role: 'Developer',
                      ),
                      SizedBox(height: 20),
                      DeveloperInfo(
                        name: 'Gennaro Mellone',
                        asset: 'assets/team/gm.jpg',
                        role: 'Developer',
                      ),
                      SizedBox(height: 20),
                      DeveloperInfo(
                        name: 'Nunzio Napolitano',
                        asset: 'assets/team/nn.jpg',
                        role: 'Responsabile Mobile Store',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String role;
  final String asset;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.asset,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.detailsColor,
          child: CircleAvatar(
            radius: 38,
            backgroundImage: AssetImage(asset),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.detailsColor,
              ),
            ),
            Text(
              '\t\t\t$role',
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ],
    );
  }
}
