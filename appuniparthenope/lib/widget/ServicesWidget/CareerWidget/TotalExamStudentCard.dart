import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/loadingExamsCircle.dart';
import 'package:flutter/material.dart';

class TotalExamStudentCard extends StatelessWidget {
  final String cfuPar, cfuTot;
  final int examSuperati, examTotali;
  final String mediaTrentesimi, mediaCentesimi;
  final String totTrentesimi, totCentesimi;

  const TotalExamStudentCard({
    super.key,
    required this.mediaTrentesimi,
    required this.mediaCentesimi,
    required this.cfuPar,
    required this.cfuTot,
    required this.examSuperati,
    required this.examTotali,
    required this.totTrentesimi,
    required this.totCentesimi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 350,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Media P.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        mediaTrentesimi,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '/$totTrentesimi',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        mediaCentesimi,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.detailsColor,
                        ),
                      ),
                      Text(
                        '/$totCentesimi',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Widget Spacer per spaziare il testo dal cerchio
            ProgressCircleCounter(
              totalCount: examTotali,
              completedExams: examSuperati,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'CFU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$cfuPar/',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.detailsColor,
                        ),
                      ),
                      Text(
                        cfuTot,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
