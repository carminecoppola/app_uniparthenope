import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../main.dart';
import '../../../../model/teacherService/course_professr_data.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../service/api_teacher_service.dart';
import '../../../CustomLoadingIndicator.dart';
import '../../../alertDialog.dart';
import 'courseCard.dart';

class CourseListWidget extends StatelessWidget {
  const CourseListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final professor = authProvider.authenticatedUser!.user;

    return FutureBuilder<List<CourseProfessorInfo>>(
      future: ApiTeacherService().getAllCourse(professor, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomLoadingIndicator(
              text: 'Caricamento dei corsi...',
              myColor: AppColors.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains('Unauthorized')) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAlertDialog(
                    title: 'Errore di autenticazione',
                    content:
                        'Si è verificato un errore durante l\'autenticazione',
                    buttonText: 'Chiudi',
                    color: AppColors.errorColor,
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              'Errore: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Nessun corso disponibile'),
          );
        } else {
          final allCourses = snapshot.data!;
          return ListView.builder(
            itemCount: allCourses.length,
            itemBuilder: (context, index) {
              final course = allCourses[index];
              return CourseCard(
                adDes: course.adDes ?? '',
                cdsDes: course.cdsDes ?? '',
                inizio: course.inizio ?? '',
                fine: course.fine ?? '',
                ultMod: course.ultMod ?? '',
                sede: course.sede ?? '',
              );
            },
          );
        }
      },
    );
  }
}
