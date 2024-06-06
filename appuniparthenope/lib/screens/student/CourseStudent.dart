import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CourseWidget/singleCourseCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widget/CustomLoadingIndicator.dart';
import '../../widget/ServicesWidget/CourseWidget/customTabBarCourse.dart';
import '../../widget/ServicesWidget/CourseWidget/legendDialog.dart';

class CourseStudentPage extends StatefulWidget {
  const CourseStudentPage({super.key});

  @override
  State<CourseStudentPage> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudentPage> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> getTabTitles(BuildContext context) {
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final user =
        userProvider.authenticatedUser?.user.trattiCarriera[0].dettaglioTratto;

    if (examProvider.allCourseStudent != null &&
        examProvider.allCourseStudent!.isNotEmpty &&
        userProvider.authenticatedUser != null &&
        user != null) {
      if (user.durataAnni == 2) {
        return ['1°', '2°'];
      } else if (user.durataAnni == 3) {
        return ['1°', '2°', '3°'];
      } else if (user.durataAnni == 4) {
        return ['1°', '2°', '3°', '4°'];
      } else if (user.durataAnni == 5) {
        return ['1°', '2°', '3°', '4°', '5°'];
      }
    }
    return [''];
  }

  @override
  Widget build(BuildContext context) {
    final allCourseInfo =
        Provider.of<ExamDataProvider>(context).allCourseStudent;
    final allStatusCoursesMap =
        Provider.of<ExamDataProvider>(context).statusCoursesMap;

    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final user =
        userProvider.authenticatedUser?.user.trattiCarriera[0].dettaglioTratto;

    final coursesByYear = {
      1: <CourseInfo>[],
      2: <CourseInfo>[],
      3: <CourseInfo>[],
      4: <CourseInfo>[],
      5: <CourseInfo>[],
    };

    if (allCourseInfo != null) {
      for (var course in allCourseInfo) {
        if (user != null && course.annoId > user.durataAnni) {
          coursesByYear[user.durataAnni]!.add(
              course); // Assegna corsi oltre l'ultimo anno disponibile all'ultimo anno
        } else {
          coursesByYear[course.annoId]?.add(course);
        }
      }
    }

    List<CourseInfo> selectedCourses = [];
    switch (_selectedIndex) {
      case 0:
        selectedCourses = coursesByYear[1]!;
        break;
      case 1:
        selectedCourses = coursesByYear[2]!;
        break;
      case 2:
        selectedCourses = coursesByYear[3]!;
        break;
      case 3:
        selectedCourses = coursesByYear[4]!;
        break;
      case 4:
        selectedCourses = coursesByYear[5]!;
        break;
    }

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showLegendDialog(context);
            },
            child: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(Icons.legend_toggle_sharp,
                        color: AppColors.detailsColor),
                    SizedBox(width: 8),
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
          const SizedBox(height: 20),
          CustomTabBarCourse(
            selectedIndex: _selectedIndex,
            onTabTapped: _onTabTapped,
            tabTitles: getTabTitles(context),
          ),
          const SizedBox(height: 10),
          if (allCourseInfo != null && allStatusCoursesMap != null)
            Expanded(
              child: ListView.builder(
                itemCount: selectedCourses.length,
                itemBuilder: (context, index) {
                  final course = selectedCourses[index];
                  final cfuExam = course.cfu.toInt().toString();

                  final status =
                      allStatusCoursesMap[course.codice]?.stato.toString() ??
                          'Stato non disponibile';

                  return SingleCourseCard(
                    index: index,
                    cfuExam: cfuExam,
                    titleExam: course.nome.toString(),
                    status: status,
                    codiceCorso: course.codice.toString(),
                    annoAccademico: course.annoId.toString(),
                  );
                },
              ),
            )
          else
            const Center(
              child: CustomLoadingIndicator(
                text: 'Caricamento dei tuoi corsi...',
                myColor: AppColors.primaryColor,
              ),
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
