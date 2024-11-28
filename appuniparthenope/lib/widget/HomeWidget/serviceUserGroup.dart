import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/utilityFunctions/weatherFunction.dart';
import '../../provider/bottomNavBar_provider.dart';
import '../../utilityFunctions/professorUtilsFunction.dart';

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 180,
        child: Column(
          children: [
            const SizedBox(height: 2),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: kIsWeb ? 250 : 150,
                height: kIsWeb ? 250 : 150,
                alignment: Alignment.center,
                child: Image.asset(imagePath),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 150, // Larghezza fissa per la descrizione
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Gruppo Card Studenti
class ServiceGroupStudentCard extends StatefulWidget {
  const ServiceGroupStudentCard({
    super.key,
    required this.authenticatedUser,
  });

  final UserInfo authenticatedUser;

  @override
  _ServiceGroupStudentCardState createState() =>
      _ServiceGroupStudentCardState();
}

class _ServiceGroupStudentCardState extends State<ServiceGroupStudentCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = (_pageController.page ?? 0).round();
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> pages = [
      [
        GestureDetector(
          onTap: () {
            StudentUtils.fetchDataAndUpdateStats(
                context, widget.authenticatedUser.user);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(1);
            Navigator.pushNamed(context, '/carrerStudent');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/careerStudent.png',
            title: AppLocalizations.of(context).translate('career'),
            description: AppLocalizations.of(context).translate('career_dsc'),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await StudentUtils.allCourseStudent(
                context, widget.authenticatedUser.user);
            await StudentUtils.allReservationStudent(
                context, widget.authenticatedUser.user);
            Navigator.pushNamed(context, '/courseStudent');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/courses2.png',
            title: AppLocalizations.of(context).translate('courses'),
            description: AppLocalizations.of(context).translate('courses_dsc'),
          ),
        ),
      ],
      [
        GestureDetector(
          onTap: () {
            StudentUtils.taxesStudent(context, widget.authenticatedUser.user);
            Navigator.pushNamed(context, '/feesStudent');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/tax2.png',
            title: AppLocalizations.of(context).translate('fees'),
            description: AppLocalizations.of(context).translate('fees_dsc'),
          ),
        ),
        GestureDetector(
          onTap: () {
            WeatherFunctions.getWeather(context);
            Navigator.pushNamed(context, '/watherPage');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/weather2.png',
            title: AppLocalizations.of(context).translate('weather'),
            description: AppLocalizations.of(context).translate('weather_dsc'),
          ),
        ),
      ],
      [
        GestureDetector(
          onTap: () {
            StudentUtils.allRooms(context);
            Navigator.pushNamed(context, '/classroomTeachers');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/classroom3.png',
            title: AppLocalizations.of(context).translate('classroom'),
            description:
                AppLocalizations.of(context).translate('classroom_dsc'),
          ),
        ),
        GestureDetector(
          onTap: () {
            StudentUtils.allEvents(context);
            Navigator.pushNamed(context, '/eventsTeachers');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/events2.png',
            title: AppLocalizations.of(context).translate('events'),
            description: AppLocalizations.of(context).translate('events_dsc'),
          ),
        ),
      ],
    ];

    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(
            height: 300, // Imposta l'altezza del PageView
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length, // Numero totale di pagine
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
    );
  }
}

// Gruppo Card Docenti
class ServiceGroupProfCard extends StatefulWidget {
  const ServiceGroupProfCard({
    super.key,
    required this.authenticatedUser,
  });

  final UserInfo authenticatedUser;

  @override
  _ServiceGroupProfCardState createState() => _ServiceGroupProfCardState();
}

class _ServiceGroupProfCardState extends State<ServiceGroupProfCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = (_pageController.page ?? 0).round();
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> pages = [
      [
        GestureDetector(
          onTap: () {
            StudentUtils.allRooms(context);
            Navigator.pushNamed(context, '/classroomTeachers');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/classroom3.png',
            title: AppLocalizations.of(context).translate('classroom'),
            description:
                AppLocalizations.of(context).translate('classroom_dsc'),
          ),
        ),
        GestureDetector(
          onTap: () {
            ProfessorUtils.allCourseProfessor(
                context, widget.authenticatedUser.user);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(1);
            Navigator.pushNamed(context, '/courseTeachers');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/courses2.png',
            title: AppLocalizations.of(context).translate('courses_prof'),
            description:
                AppLocalizations.of(context).translate('courses_prof_dsc'),
          ),
        ),
      ],
      [
        GestureDetector(
          onTap: () {
            StudentUtils.allEvents(context);
            Navigator.pushNamed(context, '/eventsTeachers');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/events2.png',
            title: AppLocalizations.of(context).translate('events'),
            description: AppLocalizations.of(context).translate('events_dsc'),
          ),
        ),
        GestureDetector(
          onTap: () {
            WeatherFunctions.getWeather(context);
            Navigator.pushNamed(context, '/watherPage');
          },
          child: ServiceCard(
            imagePath: 'assets/icon/services/weather2.png',
            title: AppLocalizations.of(context).translate('weather'),
            description: AppLocalizations.of(context).translate('weather_dsc'),
          ),
        ),
      ],
    ];

    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(
            height: 300, // Imposta l'altezza del PageView
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length, // Numero totale di pagine
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
    );
  }
}
