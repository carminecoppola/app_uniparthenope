import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/singleCourseCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseStudentPage extends StatefulWidget {
  const CourseStudentPage({super.key});

  @override
  State<CourseStudentPage> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudentPage> {
  void _showLegendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Legenda degli stati'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inserisci qui la legenda degli stati
                Text('Stato 1: Descrizione dello stato 1'),
                Text('Stato 2: Descrizione dello stato 2'),
                // Aggiungi altri stati se necessario
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allCourseInfo =
        Provider.of<ExamDataProvider>(context).allCourseStudent;
    final allStatusCourses =
        Provider.of<ExamDataProvider>(context).allStatusCourses;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _showLegendDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Leggenda',
                style: TextStyle(
                  color: AppColors.detailsColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.detailsColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (allCourseInfo != null && allStatusCourses != null)
            Expanded(
              child: ListView.builder(
                itemCount: allCourseInfo.length,
                itemBuilder: (context, index) {
                  final course = allCourseInfo[index];
                  final cfuExam = course.cfu.toInt().toString();

                  // Verifica se allStatusCourses contiene abbastanza elementi
                  // prima di accedere all'elemento corrente
                  if (index < allStatusCourses.length) {
                    final status = allStatusCourses[index].stato.toString();
                    return SingleCourseCard(
                      index: index,
                      cfuExam: cfuExam,
                      titleExam: course.nome.toString(),
                      status: status,
                      codiceCorso:
                          '${course.codice.toString()} - ${course.adId.toString()}',
                    );
                  } else {
                    // Se allStatusCourses non contiene abbastanza elementi,
                    // restituisci un widget vuoto
                    return const SizedBox.shrink();
                  }
                },
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
