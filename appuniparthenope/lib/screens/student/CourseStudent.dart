import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CourseWidget/singleCourseCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import '../../utilityFunctions/studentUtilsFunction.dart';
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
  bool _isLoadingStatus = false;

  @override
  void initState() {
    super.initState();
    // Carica lo stato dei corsi quando la pagina viene inizializzata
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourseStatus();
    });
  }

  Future<void> _loadCourseStatus() async {
    if (_isLoadingStatus) return; // Evita chiamate multiple

    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
      final allCourseInfo =
          Provider.of<ExamDataProvider>(context, listen: false)
              .allCourseStudent;

      if (authenticatedUser != null &&
          allCourseInfo != null &&
          allCourseInfo.isNotEmpty) {
        await StudentUtils.allStatusCourse(
          context,
          authenticatedUser.user,
          allCourseInfo,
        );
      }
    } catch (e) {
      print('Errore durante il caricamento dello stato dei corsi: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nessun selettore attivo - pagina esterna alle 3 principali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<BottomNavBarProvider>(context, listen: false)
            .updateIndex(3); // Indice 3 = nessun selettore
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> getTabTitles(BuildContext context) {
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer =
        Provider.of<AuthProvider>(context, listen: false).selectedCareer;

    if (selectedCareer != null) {
      final durataAnni = selectedCareer['dettaglioTratto']['durataAnni'];

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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.menu_book,
                          size: 50,
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context)
                              .translate('error_loading_courses'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
          if (course.annoId > durataAnni) {
            coursesByYear[durataAnni]!.add(course);
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
                  child: Row(
                    children: [
                      const Icon(Icons.legend_toggle_sharp,
                          color: AppColors.detailsColor),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).translate('state_legend'),
                        style: const TextStyle(
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
                child: selectedCourses.isNotEmpty
                    ? ListView.builder(
                        itemCount: selectedCourses.length,
                        itemBuilder: (context, index) {
                          final course = selectedCourses[index];
                          final cfuExam = course.cfu.toInt().toString();

                          final status = allStatusCoursesMap[course.codice]
                                  ?.stato
                                  .toString() ??
                              AppLocalizations.of(context)
                                  .translate('state_not_available');

                          return SingleCourseCard(
                            index: index,
                            cfuExam: cfuExam,
                            titleExam: course.nome.toString(),
                            status: status,
                            codiceCorso: course.codice.toString(),
                            annoAccademico: course.annoId.toString(),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 50,
                              color: AppColors.lightGray,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              '${AppLocalizations.of(context).translate('courses_not_available')} ${_selectedIndex + 1}° ${AppLocalizations.of(context).translate('course_year')}.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightGray,
                              ),
                            ),
                          ],
                        ),
                      )),
              )
            else
              Center(
                child: CustomLoadingIndicator(
                  text:
                      AppLocalizations.of(context).translate('loading_courses'),
                  myColor: AppColors.primaryColor,
                ),
              ),
          ],
        ),
        bottomNavigationBar: const BottomNavBarComponent(),
      );
    }
    return Center(
      child:
          Text(AppLocalizations.of(context).translate('not_selected_career')),
    );
  }
}
