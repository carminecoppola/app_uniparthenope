import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:appuniparthenope/utilityFunctions/professorUtilsFunction.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:provider/provider.dart';

import '../../../../model/teacherService/course_professor_data.dart';

class SingleProfessorCourseCard extends StatelessWidget {
  final CourseProfessorInfo course;

  const SingleProfessorCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context).translate('loading_exam_info'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        );

        await ProfessorUtils.checkExamInfoProfessor(
            context, course.cdsId!.toInt(), course.adId!.toInt());
        Provider.of<ProfessorDataProvider>(context, listen: false)
            .setSelectedCourse(course);

        //Navigo alla pagina che mi mostra gli appelli d'esame disponibili
        Navigator.pushNamed(context, '/sessAvProfCourses');
      },
      child: Container(
        margin: const EdgeInsets.all(15.0),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Card(
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toCamelCase(course.adDes!.split(' CFU')[0]),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        toCamelCase(course.cdsDes),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 181, 181, 181),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
