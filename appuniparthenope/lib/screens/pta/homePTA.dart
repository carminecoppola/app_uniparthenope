import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../utilityFunctions/studentUtilsFunction.dart';
import '../../utilityFunctions/weatherFunction.dart';
import '../../widget/HomeWidget/sectionTitle.dart';
import '../../widget/HomeWidget/serviceUserGroup.dart';
import '../../widget/ServicesWidget/PTAWidget/ptaCard.dart';
import '../../widget/bottomNavBarPTA.dart';

class PTAHomePage extends StatefulWidget {
  const PTAHomePage({super.key});

  @override
  _PTAHomePageState createState() => _PTAHomePageState();
}

class _PTAHomePageState extends State<PTAHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authenticatedUser = authProvider.authenticatedUser;

    if (authenticatedUser == null) {
      return const Scaffold(
        appBar: NavbarComponent(
          role: 'PTA',
          showBackButton: false,
        ),
        body: Center(
          child: Text(
            'Nessun utente autenticato',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.errorColor,
            ),
          ),
        ),
      );
    }

    List<List<Widget>> pages = [
      [
        GestureDetector(
          onTap: () {
            StudentUtils.allRooms(context);
            Navigator.pushNamed(context, '/classroomTeachers');
          },
          child: const ServiceCard(
            imagePath: 'assets/icon/services/classroom3.png',
            title: 'Aule',
            description: 'Qui è possibile visualizzare e prenotare le aule.',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/libraryPage');
          },
          child: const ServiceCard(
            imagePath: 'assets/icon/services/libraryService.png',
            title: 'Biblioteca',
            description:
                'Qui puoi visualizzare e registrare gli accessi alle biblioteche dell\'ateneo.',
          ),
        ),
      ],
      [
        GestureDetector(
          onTap: () {
            StudentUtils.allEvents(context);
            Navigator.pushNamed(context, '/eventsTeachers');
          },
          child: const ServiceCard(
            imagePath: 'assets/icon/services/events2.png',
            title: 'Eventi',
            description:
                'Qui puoi visualizzare gli eventi che sono stati organizzati.',
          ),
        ),
      ],
      // Aggiungi ulteriori pagine di card qui se necessario
    ];

    return Scaffold(
      appBar: const NavbarComponent(
        role: 'PTA',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Logo Parthenope
            const SizedBox(height: 20),
            PtaCard(user: authenticatedUser.user, fotoUrl: 'assets/pta.png'),
            const SizedBox(height: 50),
            const SectionTitle(title: 'Servizi'),
            const SizedBox(height: 10),
            // PageView con le card e i pallini di navigazione
            Container(
              height: 300, // Imposta l'altezza del PageView
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: pages[index].map((card) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: card,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Indicatori circolari per la navigazione delle pagine
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarPTAComponent(),
    );
  }
}
