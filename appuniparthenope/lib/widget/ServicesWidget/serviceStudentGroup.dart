import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/controller/exam_controller.dart';
import 'package:appuniparthenope/model/course_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:appuniparthenope/service/api_weather_service.dart';
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
  ServiceGroupStudentCard({
    super.key,
    required this.authenticatedUser,
  });

  final ExamController _totalExamController = ExamController();
  final AuthController _authController = AuthController();
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
                      _totalExamStats(context, authenticatedUser.user);
                      _averageStats(context, authenticatedUser.user);
                      _allExamStudent(context, authenticatedUser.user);
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
                    onTap: () {
                      _allCourseStudent(context, authenticatedUser.user);
                      //_allStatusCourse(context, authenticatedUser.user);
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
                      _taxesStudent(context, authenticatedUser.user);
                      Navigator.pushNamed(context, '/feesStudent');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/tax.png',
                      title: 'Tasse Universitarie',
                      description:
                          'Puoi tenere sotto controllo la situazione delle tasse universitarie.',
                      //root: '/feesStudent',
                    ),
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/watherStudent');
                    },
                    child: const ServiceCard(
                      imagePath: 'assets/icon/weather.png',
                      title: 'Meteo Uniparthenope',
                      description:
                          'Puoi utilizzare il meteoro dell\'Università Parthenope.',
                      //root: '/watherStudent',
                    ),
                  ),
                  const SizedBox(width: 5), // Spazio finale per l'estetica
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _totalExamStats(BuildContext context, User? authenticatedUser) async {
    try {
      final totalExamStudent = await _totalExamController.totalExamStatsStudent(
          authenticatedUser!, context);

      // Utilizza il provider per impostare l'anagrafica dell'utente
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalStatsExamStudent(totalExamStudent);
    } catch (e) {
      print('Errore during _totalExamStats() $e');
    }
  }

  void _averageStats(BuildContext context, User? authenticatedUser) async {
    try {
      final aritmeticAverageStudent = await _totalExamController
          .aritmeticAverageStudent(authenticatedUser!, context);

      final weightedAverageStudent = await _totalExamController
          .weightedAverageStudent(authenticatedUser, context);

      // Utilizza il provider per impostare la media dello studente
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalAverageExamStudent(
          aritmeticAverageStudent, weightedAverageStudent);
    } catch (e) {
      print('Errore during _averageStats() $e');
    }
  }

  void _allExamStudent(BuildContext context, User? authenticatedUser) async {
    try {
      final allExamStudent = await _totalExamController.fetchAllExamStudent(
          authenticatedUser!, context);

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllExamStudent(allExamStudent);
    } catch (e) {
      print('Errore during _allExamStudent() $e');
    }
  }

  void _allCourseStudent(BuildContext context, User? authenticatedUser) async {
    try {
      final allCourseStudent = await _totalExamController.fetchAllCourseStudent(
          authenticatedUser!, context);

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllCoursesStudent(allCourseStudent);

      // Per ogni corso ottenuto, ottenere lo stato del corso
      // for (final course in allCourseStudent) {
      //   _allStatusCourse(context, authenticatedUser, course);
      // }
      _allStatusCourse(context, authenticatedUser, allCourseStudent);
    } catch (e) {
      print('Errore during _allCourseStudent() $e');
    }
  }

  void _allStatusCourse(BuildContext context, User authenticatedUser,
      List<CourseInfo> allCourses) async {
    try {
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);

      for (CourseInfo course in allCourses) {
        List<StatusCourse> statusCourses = await _totalExamController
            .fetchAllCourseStatus(authenticatedUser, [course], context);

        // Assicurati che lo stato del corso sia disponibile
        if (statusCourses.isNotEmpty) {
          // Aggiungi lo stato del corso all'elenco in ExamDataProvider
          examDataProvider.setAllStatusCourses(
              [...examDataProvider.allStatusCourses ?? [], ...statusCourses]);
        }
      }
    } catch (e) {
      print('Errore durante _allStatusCourse() $e');
    }
  }

  void _taxesStudent(BuildContext context, User authenticatedUser) async {
    try {
      final allTaxesStudent =
          await _authController.setTaxes(context, authenticatedUser);

      final taxesDataProvider =
          Provider.of<TaxesDataProvider>(context, listen: false);
      taxesDataProvider.setTaxesInfo(
          allTaxesStudent); // Imposta le informazioni sulle tasse nel provider
    } catch (e) {
      print('Error during _taxesStudent: $e');
    }
  }
}
