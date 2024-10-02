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
    final selectedCareer =
        Provider.of<AuthProvider>(context, listen: false).selectedCareer;

    if (selectedCareer != null) {
      final durataAnni = selectedCareer['dettaglioTratto']['durataAnni'];

      print('Descrizione Corso: ${selectedCareer['cdsDes']}');
      print('Durata Anni: $durataAnni');

      if (examProvider.allCourseStudent != null &&
          examProvider.allCourseStudent!.isNotEmpty) {
        if (durataAnni == 2) {
          return ['1°', '2°'];
        } else if (durataAnni == 3) {
          return ['1°', '2°', '3°'];
        } else if (durataAnni == 4) {
          return ['1°', '2°', '3°', '4°'];
        } else if (durataAnni == 5) {
          return ['1°', '2°', '3°', '4°', '5°'];
        }
      }
    }

    // Restituisci una lista vuota se non si trova un titolo
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final allCourseInfo =
        Provider.of<ExamDataProvider>(context).allCourseStudent;
    final allStatusCoursesMap =
        Provider.of<ExamDataProvider>(context).statusCoursesMap;
    final pianoId = Provider.of<ExamDataProvider>(context).pianoId;

    final selectedCareer =
        Provider.of<AuthProvider>(context, listen: false).selectedCareer;

    if (selectedCareer != null) {
      final durataAnni = selectedCareer['dettaglioTratto']['durataAnni'];

      // Controllo pianoId
      if (pianoId == null) {
        return Scaffold(
          appBar: const NavbarComponent(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 50,
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Siamo spiacenti, al momento stiamo riscontrando problemi nel recuperare i tuoi corsi.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.detailsColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BottomNavBarComponent(),
        );
      }

      final coursesByYear = {
        1: <CourseInfo>[],
        2: <CourseInfo>[],
        3: <CourseInfo>[],
        4: <CourseInfo>[],
        5: <CourseInfo>[],
      };

      if (allCourseInfo != null) {
        for (var course in allCourseInfo) {
          // Usa sempre durataAnni invece di user.durataAnni
          if (course.annoId > durataAnni) {
            coursesByYear[durataAnni]!.add(
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
    return const Center(
      child: Text("Nessuna carriera selezionata"),
    );
  }
}
