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
  @override
  Widget build(BuildContext context) {
    final allCourseInfo =
        Provider.of<ExamDataProvider>(context).allCourseStudent;

    final allCourseStatus =
        Provider.of<ExamDataProvider>(context).allCourseStatus;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //CustomTabBar(tabs: tabs, onTabSelected: onTabSelected),
          const SizedBox(height: 20),

          if (allCourseInfo != null)
            Expanded(
              child: ListView.builder(
                itemCount: allCourseInfo.length,
                itemBuilder: (context, index) {
                  final course = allCourseInfo[index];
                  final cfuExam = course.cfu.toInt().toString();
                  return SingleCourseCard(
                    index: index,
                    cfuExam: cfuExam,
                    titleExam: course.nome.toString(),
                    status: course.adId.toString(),
                  );
                },
              ),
            )
          else
            // Gestione del caso in cui totalExamStats è null
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
