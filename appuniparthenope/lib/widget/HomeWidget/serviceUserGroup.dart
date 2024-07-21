import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/utilityFunctions/weatherFunction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/bottomNavBar_provider.dart';
import '../../utilityFunctions/professorUtilsFunction.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

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
                  color: AppColors.primaryColor),
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

//Gruppo Card Studenti
class ServiceGroupStudentCard extends StatelessWidget {
  const ServiceGroupStudentCard({
    super.key,
    required this.authenticatedUser,
  });

  final UserInfo authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                StudentUtils.fetchDataAndUpdateStats(
                    context, authenticatedUser.user);

                final bottomNavBarProvider =
                    Provider.of<BottomNavBarProvider>(context, listen: false);
                bottomNavBarProvider.updateIndex(1);
                Navigator.pushNamed(context, '/carrerStudent');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/careerStudent.png',
                title: 'Carriera',
                description:
                    'Qui puoi visualizzare i dettagli relativi agli esami che hai superato.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5),
            GestureDetector(
              onTap: () async {
                StudentUtils.allCourseStudent(context, authenticatedUser.user);
                StudentUtils.allReservationStudent(
                    context, authenticatedUser.user);
                Navigator.pushNamed(context, '/courseStudent');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/courses2.png',
                title: 'Corsi',
                description:
                    'Puoi visualizzare i corsi da seguire per ogni anno accademico previsti.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5), // Spazio tra le card
            GestureDetector(
              onTap: () {
                StudentUtils.taxesStudent(context, authenticatedUser.user);
                Navigator.pushNamed(context, '/feesStudent');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/tax2.png',
                title: 'Tasse',
                description:
                    'Puoi tenere sotto controllo la situazione delle tasse universitarie.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5), // Spazio tra le card
            GestureDetector(
              onTap: () {
                WeatherFunctions.getWeather(context);
                Navigator.pushNamed(context, '/watherPage');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/weather2.png',
                title: 'Meteo',
                description:
                    'Puoi utilizzare il servizio meteo dell\'Università Parthenope.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5),
          ],
        ),
      ),
    );
  }
}

//Gruppo Card Docenti
class ServiceGroupProfCard extends StatelessWidget {
  const ServiceGroupProfCard({
    super.key,
    required this.authenticatedUser,
  });

  final UserInfo authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                StudentUtils.allRooms(context);
                Navigator.pushNamed(context, '/classroomTeachers');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/classroom3.png',
                title: 'Aule',
                description:
                    'Qui è possibile visualizzare e prenotare le aule.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5),
            GestureDetector(
              onTap: () {
                ProfessorUtils.allCourseProfessor(
                    context, authenticatedUser.user);
                //Aggiornamento bottomNavBarProvider
                final bottomNavBarProvider =
                    Provider.of<BottomNavBarProvider>(context, listen: false);
                bottomNavBarProvider.updateIndex(1);
                Navigator.pushNamed(context, '/courseTeachers');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/courses2.png',
                title: 'Corsi',
                description:
                    'È possibile visualizzare i propri corsi dell\'anno accademico.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5),
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
            const SizedBox(width: kIsWeb ? 50 : 5),
            GestureDetector(
              onTap: () {
                WeatherFunctions.getWeather(context);
                Navigator.pushNamed(context, '/watherPage');
              },
              child: const ServiceCard(
                imagePath: 'assets/icon/services/weather2.png',
                title: 'Meteo',
                description:
                    'Puoi utilizzare il servizio meteo dell\'Università Parthenope.',
              ),
            ),
            const SizedBox(width: kIsWeb ? 50 : 5),
          ],
        ),
      ),
    );
  }
}
