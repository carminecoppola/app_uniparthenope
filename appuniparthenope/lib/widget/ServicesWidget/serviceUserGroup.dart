import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/utilityFunctions/utilsFunction.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/utilityFunctions/weatherFunction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/bottomNavBar_provider.dart';

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  //final String root;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    //required this.root,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.pushNamed(context, root);
      // },
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            const SizedBox(height: 2),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 170,
                height: 170,
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
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 160,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      StudentUtils.fetchDataAndUpdateStats(
                          context, authenticatedUser.user);

                      final bottomNavBarProvider =
                          Provider.of<BottomNavBarProvider>(context,
                              listen: false);
                      bottomNavBarProvider.updateIndex(1);
                      Navigator.pushNamed(context, '/carrerStudent');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/student.png',
                      title: 'Carriera',
                      description:
                          'Qui puoi visualizzare i dettagli relativi agli esami che hai superato.',
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () async {
                      StudentUtils.allCourseStudent(
                          context, authenticatedUser.user);

                      Navigator.pushNamed(context, '/courseStudent');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/courses.png',
                      title: 'Corsi',
                      description:
                          'Puoi visualizzare per ogni anno accademico i corsi da seguire.',
                    ),
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  GestureDetector(
                    onTap: () {
                      StudentUtils.taxesStudent(
                          context, authenticatedUser.user);
                      Navigator.pushNamed(context, '/feesStudent');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/tax.png',
                      title: 'Tasse',
                      description:
                          'Puoi tenere sotto controllo la situazione delle tasse universitarie.',
                    ),
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  GestureDetector(
                    onTap: () {
                      WeatherFunctions.getWeather(context);
                      Navigator.pushNamed(context, '/watherPage');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/weather.png',
                      title: 'Meteo',
                      description:
                          'Puoi utilizzare il servizio meteo dell\'Università Parthenope.',
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            )
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/classroomTeachers');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/classroom.png',
                      title: 'Aule',
                      description:
                          'Qui è possibile prenotare le aule per le lezioni e per gli esami.',
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/courseTeachers');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/courses.png',
                      title: 'Corsi',
                      description:
                          'Puoi visualizzare per ogni anno accademico i corsi da seguire.',
                    ),
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  GestureDetector(
                    onTap: () {
                      final bottomNavBarProvider =
                          Provider.of<BottomNavBarProvider>(context,
                              listen: false);
                      bottomNavBarProvider.updateIndex(1);
                      StudentUtils.allEvents(context);
                      Navigator.pushNamed(context, '/eventsTeachers');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/lecture.png',
                      title: 'Eventi',
                      description:
                          'Qui puoi visualizzare gli eventi che sono stati organizzati.',
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      WeatherFunctions.getWeather(context);
                      Navigator.pushNamed(context, '/watherPage');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/weather.png',
                      title: 'Meteo',
                      description:
                          'Puoi utilizzare il servizio meteo dell\'Università Parthenope.',
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
