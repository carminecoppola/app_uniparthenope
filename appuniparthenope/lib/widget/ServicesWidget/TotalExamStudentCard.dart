import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/loadingExamsCircle.dart';
import 'package:flutter/material.dart';

class TotalExamStudentCard extends StatelessWidget {
  final String cfuPar, cfuTot;
  final String mediaTrentesimi = "25", mediaCentesimi = "92";

  const TotalExamStudentCard({
    super.key,
    required this.cfuPar,
    required this.cfuTot,
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Media',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        mediaTrentesimi,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.detailsColor,
                        ),
                      ),
                      const Text(
                        '/30',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        mediaCentesimi,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.detailsColor,
                        ),
                      ),
                      const Text(
                        '/110',
                        style: TextStyle(
                          fontSize: 16,
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
            const ProgressCircleCounter(
              totalCount: 100,
              duration: Duration(seconds: 5),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tot. CFU',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$cfuPar/',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.detailsColor,
                        ),
                      ),
                      Text(
                        '$cfuTot',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
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
