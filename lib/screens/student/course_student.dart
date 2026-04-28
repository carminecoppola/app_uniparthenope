import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/bottom_nav_bar_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CourseWidget/single_course_card.dart';
import 'package:appuniparthenope/widget/bottom_nav_bar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import '../../utilityFunctions/student_utils_function.dart';
import '../../widget/custom_loading_indicator.dart';
import '../../widget/ServicesWidget/CourseWidget/custom_tab_bar_course.dart';

class CourseStudentPage extends StatefulWidget {
  const CourseStudentPage({super.key});

  @override
  State<CourseStudentPage> createState() => _CourseStudentState();
}

class _CourseStudentState extends State<CourseStudentPage> {
  static const bool _useModernCourseExperience = true;
  int _selectedIndex = 0;
  bool _isLoadingStatus = false;
  bool _statusLoadCompleted = false;

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
      _statusLoadCompleted = false;
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
    } catch (_) {
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
          _statusLoadCompleted = true;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final examProvider = Provider.of<ExamDataProvider>(context);
    final allCourseInfo = examProvider.allCourseStudent;
    final allStatusCoursesMap = examProvider.statusCoursesMap;

    if (!_isLoadingStatus &&
        allCourseInfo != null &&
        allCourseInfo.isNotEmpty &&
        allStatusCoursesMap == null &&
        !_statusLoadCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadCourseStatus();
        }
      });
    }

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

  double _calculateYearCfu(List<CourseInfo> courses) {
    return courses.fold<double>(0, (total, course) => total + course.cfu);
  }

  Widget _buildHeroSection(
    BuildContext context, {
    required int totalCourses,
    required int selectedYear,
    required double totalCfu,
  }) {
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkColor.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('courses'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${selectedYear + 1}° ${localizations.translate('course_year')}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _CourseHighlightCard(
                  label: localizations.translate('courses'),
                  value: totalCourses.toString(),
                  icon: Icons.library_books_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CourseHighlightCard(
                  label: 'CFU',
                  value: totalCfu % 1 == 0
                      ? totalCfu.toInt().toString()
                      : totalCfu.toStringAsFixed(1),
                  icon: Icons.workspace_premium_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyYearState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primaryColor,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '${AppLocalizations.of(context).translate('courses_not_available')} ${_selectedIndex + 1}° ${AppLocalizations.of(context).translate('course_year')}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDarkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

      final totalSelectedYearCfu = _calculateYearCfu(selectedCourses);
      final tabTitles = getTabTitles(context);

      Widget courseContent;
      if (allCourseInfo != null &&
          !_isLoadingStatus &&
          _statusLoadCompleted &&
          allStatusCoursesMap != null) {
        courseContent = selectedCourses.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  MediaQuery.paddingOf(context).bottom + 96,
                ),
                itemCount: selectedCourses.length,
                itemBuilder: (context, index) {
                  final course = selectedCourses[index];
                  final cfuExam = course.cfu.toInt().toString();

                  final status =
                      allStatusCoursesMap[_courseStatusKey(course)]?.stato.toString() ??
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
            : _buildEmptyYearState(context);
      } else {
        courseContent = Center(
          child: CustomLoadingIndicator(
            text: AppLocalizations.of(context).translate('loading_courses'),
            myColor: AppColors.primaryColor,
          ),
        );
      }

      return Scaffold(
        appBar: const NavbarComponent(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_useModernCourseExperience)
              _buildHeroSection(
                context,
                totalCourses: selectedCourses.length,
                selectedYear: _selectedIndex,
                totalCfu: totalSelectedYearCfu,
              )
            else
              const SizedBox(height: 8),
            if (!_useModernCourseExperience) const SizedBox(height: 20),
            CustomTabBarCourse(
              selectedIndex: _selectedIndex,
              onTabTapped: _onTabTapped,
              tabTitles: tabTitles,
            ),
            const SizedBox(height: 14),
            Expanded(child: courseContent),
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

String _courseStatusKey(CourseInfo course) {
  final codice = course.codice.trim();
  if (codice.isNotEmpty) return codice;
  return 'ad:${course.adId}';
}

class _CourseHighlightCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CourseHighlightCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
