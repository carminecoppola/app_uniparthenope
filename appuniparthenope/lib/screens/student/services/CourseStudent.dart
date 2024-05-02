import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/singleCourseCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseStudentPage extends StatefulWidget {
  const CourseStudentPage({Key? key});

  @override
  State<CourseStudentPage> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudentPage> {
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
      bottomNavigationBar: BottomNavBarComponent(),
    );
  }
}
