import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:appuniparthenope/utilityFunctions/student_utils_function.dart';
import 'package:appuniparthenope/utilityFunctions/weather_function.dart';
// import 'package:appuniparthenope/utilityFunctions/exam_utils_function.dart';
import '../../provider/bottom_nav_bar_provider.dart';
import '../../utilityFunctions/professor_utils_function.dart';

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.045),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageSize = constraints.maxHeight * 1.12;
            final fontSize = constraints.maxWidth < 150 ? 14.0 : 15.0;

            return Stack(
              children: [
                Positioned(
                  right: -imageSize * 0.18,
                  bottom: -imageSize * 0.17,
                  child: Opacity(
                    opacity: 0.26,
                    child: Image.asset(
                      imagePath,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.92),
                        Colors.white.withValues(alpha: 0.38),
                      ],
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primaryDarkColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Gruppo Card Studenti
class ServiceGroupStudentCard extends StatefulWidget {
  const ServiceGroupStudentCard({
    super.key,
    required this.authenticatedUser,
  });

  final UserInfo authenticatedUser;

  @override
  State<ServiceGroupStudentCard> createState() =>
      _ServiceGroupStudentCardState();
}

class _ServiceGroupStudentCardState extends State<ServiceGroupStudentCard> {
  @override
  Widget build(BuildContext context) {
    final services = [
      _StudentServiceData(
        imagePath: 'assets/icon/services/careerStudent.png',
        title: AppLocalizations.of(context).translate('career'),
        onTap: () {
          StudentUtils.fetchDataAndUpdateStats(
              context, widget.authenticatedUser.user);
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(0);
          Navigator.pushNamed(context, '/carrerStudent');
        },
      ),
      _StudentServiceData(
        imagePath: 'assets/icon/services/bookExam.png',
        title: AppLocalizations.of(context).translate('exam_sessions'),
        onTap: () async {
          await StudentUtils.allCourseStudent(
              context, widget.authenticatedUser.user);
          if (!context.mounted) return;
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(3);
          Navigator.pushNamed(context, '/listaAppelliStudent');
        },
      ),
      _StudentServiceData(
        imagePath: 'assets/icon/services/courses2.png',
        title: AppLocalizations.of(context).translate('courses'),
        onTap: () async {
          await StudentUtils.allCourseStudent(
              context, widget.authenticatedUser.user);
          if (!context.mounted) return;
          await StudentUtils.allReservationStudent(
              context, widget.authenticatedUser.user);
          if (!context.mounted) return;
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(3);
          Navigator.pushNamed(context, '/courseStudent');
        },
      ),
      _StudentServiceData(
        imagePath: 'assets/icon/services/tax2.png',
        title: AppLocalizations.of(context).translate('fees'),
        onTap: () {
          StudentUtils.taxesStudent(context, widget.authenticatedUser.user);
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(3);
          Navigator.pushNamed(context, '/feesStudent');
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: isCompact ? 8 : 10,
              crossAxisSpacing: isCompact ? 10 : 12,
              childAspectRatio: isCompact ? 1.28 : 1.42,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: service.onTap,
                child: ServiceCard(
                  imagePath: service.imagePath,
                  title: service.title,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StudentServiceData {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const _StudentServiceData({
    required this.imagePath,
    required this.title,
    required this.onTap,
  });
}

// Gruppo Card Docenti
class ServiceGroupProfCard extends StatefulWidget {
  const ServiceGroupProfCard({
    super.key,
    required this.authenticatedUser,
  });

  final UserInfo authenticatedUser;

  @override
  State<ServiceGroupProfCard> createState() => _ServiceGroupProfCardState();
}

class _ServiceGroupProfCardState extends State<ServiceGroupProfCard> {
  @override
  Widget build(BuildContext context) {
    final services = [
      _ProfessorServiceData(
        imagePath: 'assets/icon/services/classroom3.png',
        title: AppLocalizations.of(context).translate('classroom'),
        onTap: () {
          StudentUtils.allRooms(context);
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(3);
          Navigator.pushNamed(context, '/classroomTeachers');
        },
      ),
      _ProfessorServiceData(
        imagePath: 'assets/icon/services/courses2.png',
        title: AppLocalizations.of(context).translate('courses_prof'),
        onTap: () {
          ProfessorUtils.allCourseProfessor(
              context, widget.authenticatedUser.user);
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(0);
          Navigator.pushNamed(context, '/courseTeachers');
        },
      ),
      _ProfessorServiceData(
        imagePath: 'assets/icon/services/events2.png',
        title: AppLocalizations.of(context).translate('events'),
        onTap: () {
          StudentUtils.allEvents(context);
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(3);
          Navigator.pushNamed(context, '/eventsTeachers');
        },
      ),
      _ProfessorServiceData(
        imagePath: 'assets/icon/services/weather2.png',
        title: AppLocalizations.of(context).translate('weather'),
        onTap: () {
          WeatherFunctions.getWeather(context);
          final bottomNavBarProvider =
              Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.updateIndex(3);
          Navigator.pushNamed(context, '/watherPage');
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: isCompact ? 8 : 10,
              crossAxisSpacing: isCompact ? 10 : 12,
              childAspectRatio: isCompact ? 1.28 : 1.42,
            ),
            itemBuilder: (context, index) {
              return _ProfessorServiceCard(service: services[index]);
            },
          );
        },
      ),
    );
  }
}

class _ProfessorServiceData {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const _ProfessorServiceData({
    required this.imagePath,
    required this.title,
    required this.onTap,
  });
}

class _ProfessorServiceCard extends StatelessWidget {
  final _ProfessorServiceData service;

  const _ProfessorServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: service.onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageSize = constraints.maxHeight * 1.12;
              final fontSize = constraints.maxWidth < 150 ? 14.0 : 15.0;

              return Stack(
                children: [
                  Positioned(
                    right: -imageSize * 0.18,
                    bottom: -imageSize * 0.17,
                    child: Image.asset(
                      service.imagePath,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                      opacity: const AlwaysStoppedAnimation(0.26),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.92),
                          Colors.white.withValues(alpha: 0.38),
                        ],
                      ),
                    ),
                    child: const SizedBox.expand(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          service.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
