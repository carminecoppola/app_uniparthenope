import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../main.dart';
import '../../../../model/teacherService/course_professor_data.dart';
import '../../../../model/teacherService/session_professor_data.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../service/api_teacher_service.dart';
import '../../../../utilityFunctions/professorUtilsFunction.dart';
import '../../../CustomLoadingIndicator.dart';
import 'courseCard.dart';

class CourseListProfessorWidget extends StatelessWidget {
  const CourseListProfessorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final professor = authProvider.authenticatedUser!.user;

    return FutureProvider<SessionProfessorInfo?>(
      create: (context) => ProfessorUtils.professorSession(context, professor),
      initialData: null,
      child: Consumer<SessionProfessorInfo?>(
        builder: (context, session, child) {
          if (session == null) {
            return const Center(
              child: CustomLoadingIndicator(
                text: 'Caricamento della sessione del professore...',
                myColor: AppColors.primaryColor,
              ),
            );
          }

          return FutureBuilder<List<CourseProfessorInfo>>(
            future: ApiTeacherService()
                .getAllCourse(professor, session.aaId!, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CustomLoadingIndicator(
                    text: 'Caricamento dei corsi...',
                    myColor: AppColors.primaryColor,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: AppColors.detailsColor,
                          size: 48.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Attualmente non è possibile visualizzare i corsi disponibili',
                          style: TextStyle(
                            color: AppColors.detailsColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final allCourses = snapshot.data!;
                return ListView.builder(
                  itemCount: allCourses.length,
                  itemBuilder: (context, index) {
                    final course = allCourses[index];
                    return SingleProfessorCourseCard(
                      course: course,
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
