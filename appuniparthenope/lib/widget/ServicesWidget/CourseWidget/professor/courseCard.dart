import 'package:appuniparthenope/utilityFunctions/professorUtilsFunction.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

import '../../../../screens/CourseDetailsInfo.dart';

class CourseCard extends StatelessWidget {
  final String adDes;
  final String cdsDes;
  final String inizio;
  final String fine;
  final String ultMod;
  final String sede;
  final int adLogId; // Aggiungi adLogId

  const CourseCard({
    super.key,
    required this.adDes,
    required this.cdsDes,
    required this.inizio,
    required this.fine,
    required this.ultMod,
    required this.sede,
    required this.adLogId, // Aggiungi adLogId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(
              adDes: adDes,
              cdsDes: cdsDes,
              inizio: inizio,
              fine: fine,
              sede: sede,
              adLogId: adLogId,
            ),
          ),
        );

        ProfessorUtils.detailsCourseProfessor(context, adLogId);
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
                        toCamelCase(adDes),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        toCamelCase(cdsDes),
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
