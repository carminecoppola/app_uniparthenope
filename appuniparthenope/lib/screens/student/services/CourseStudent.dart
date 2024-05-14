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
          title: const Center(
            child: Text(
              'Legenda Stato',
              style: TextStyle(
                color: AppColors.detailsColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: AppColors.detailsColor, thickness: 2),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Attività Didattica Pianificata',
                        AppColors.detailsColor),
                    _legendItem('Attività Didattica Non frequentata',
                        AppColors.lightGray),
                    _legendItem('Attività Didattica Frequentata',
                        AppColors.accentColor),
                    _legendItem(
                        'Riconosciuta intera Attività', AppColors.successColor),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Chiudi',
                style: TextStyle(
                    color: AppColors.detailsColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _legendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textColor, width: 1),
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
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
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(Icons.legend_toggle_sharp,
                        color: AppColors.detailsColor), // Icona "info"
                    SizedBox(width: 8), // Spazio tra l'icona e il testo
                    Text(
                      'Legenda Stato',
                      style: TextStyle(
                        color: AppColors.detailsColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.detailsColor,
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 10),
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
                      annoAccademico: course.annoId.toString(),
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
