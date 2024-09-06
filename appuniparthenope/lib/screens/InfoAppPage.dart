import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../widget/bottomNavBar.dart';
import '../widget/navbar.dart';

class InfoAppPage extends StatelessWidget {
  const InfoAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo dell'università
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
              ],
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
              'Version: 4.0.1',
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
                      children: _buildDeveloperInfoList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.email,
                        color: AppColors.primaryColor, size: 30),
                    onPressed: () {
                      _sendEmail();
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Contatta gli sviluppatori se hai notato\nun problema nell\'applicazione',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  List<Widget> _buildDeveloperInfoList() {
    final developers = [
      {
        'name': 'Raffaele Montela',
        'asset': 'assets/team/team_leader.jpg',
        'role': 'Team leader'
      },
      {
        'name': 'Carmine Coppola',
        'asset': 'assets/team/cc.png',
        'role': 'Developer'
      },
      {
        'name': 'Ciro Giuseppe De Vita',
        'asset': 'assets/team/cgdv.png',
        'role': 'Developer'
      },
      {
        'name': 'Gennaro Mellone',
        'asset': 'assets/team/gm.jpg',
        'role': 'Developer'
      },
    ];

    List<Widget> developerInfoList = [];
    for (var i = 0; i < developers.length; i++) {
      developerInfoList.add(DeveloperInfo(
        name: developers[i]['name']!,
        asset: developers[i]['asset']!,
        role: developers[i]['role']!,
      ));
      if (i < developers.length - 1) {
        developerInfoList.add(const SizedBox(height: 5));
        developerInfoList.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26.0),
            child: const Divider(
              color: Colors.white,
              thickness: 0.5,
            ),
          ),
        );
        developerInfoList.add(const SizedBox(height: 5));
      }
    }
    return developerInfoList;
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'prova@developer.it',
      queryParameters: {
        'subject': 'Richiesta di Supporto',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
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
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
