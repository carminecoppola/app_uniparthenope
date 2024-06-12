import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/teacherService/check_exam_data.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:appuniparthenope/utilityFunctions/professorUtilsFunction.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CourseWidget/professor/listStudentExam.dart';
import 'package:appuniparthenope/widget/alertDialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCheckExamCard extends StatelessWidget {
  final CheckExamInfo course;

  const SingleCheckExamCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCourse =
        Provider.of<ProfessorDataProvider>(context, listen: false)
            .selectedCourse;
    final profSession =
        Provider.of<ProfessorDataProvider>(context, listen: false).profSession;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () async {
          if (selectedCourse != null && profSession != null) {
            try {
              await ProfessorUtils.allStudentListExam(
                  context,
                  selectedCourse.cdsId!.toString(),
                  selectedCourse.adId!.toString(),
                  course.appId!.toString());

              // Mostra l'overlay con la lista degli studenti
              showDialog(
                context: context,
                builder: (context) => const StudentsOverlay(),
              );
            } catch (e) {
              const CustomAlertDialog(
                  title: 'Errore',
                  content: 'content',
                  buttonText: 'Chiudi',
                  color: AppColors.errorColor);
            }
          } else {
            const CustomLoadingIndicator(
                text: 'Caricamento lista studenti...',
                myColor: AppColors.detailsColor);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toCamelCase(course.descrizione),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      course.docenteCompleto.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGray,
                      ),
                    ),
                    Text(
                      course.statoDes.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.successColor,
                      ),
                    ),
                    Text(
                      '${course.dataInizio.toString()}-${course.dataFine.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGray,
                      ),
                    ),
                    Text(
                      'Prenotati: ${course.numIscritti.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.detailsColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                course.dataEsame.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
