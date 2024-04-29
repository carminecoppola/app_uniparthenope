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

    return Scaffold(
      appBar: const NavbarComponent(),
      body: allCourseInfo != null
          ? ListView.builder(
              itemCount: allCourseInfo.length,
              itemBuilder: (context, index) {
                final course = allCourseInfo[index];
                final cfuExam = course.cfu.toInt().toString(); //Converto in int 12.0
                return SingleCourseCard(
                  index: index,
                  cfuExam: cfuExam,
                  titleExam: course.nome.toString(),
                  status: course.adId.toString(),
                );
              },
            )
          : const Center(
              child:
                  CircularProgressIndicator(), // Visualizza un indicatore di caricamento se i dati non sono ancora disponibili
            ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
