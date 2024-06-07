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
  final int adLogId;
  final int cdsId;
  final int adId;

  const CourseCard({
    super.key,
    required this.adDes,
    required this.cdsDes,
    required this.inizio,
    required this.fine,
    required this.ultMod,
    required this.sede,
    required this.adLogId,
    required this.cdsId,
    required this.adId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Caricamento appelli...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        );

        await ProfessorUtils.chechExamInfoProfessor(context, cdsId, adId);
        Navigator.pop(context); // Close the loading dialog
        Navigator.pushNamed(context, '/checkCourseTeachers');
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
                        toCamelCase(adDes.split(' CFU')[0]),
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



/*// onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => CourseDetailsPage(
      //         adDes: adDes,
      //         cdsDes: cdsDes,
      //         inizio: inizio,
      //         fine: fine,
      //         sede: sede,
      //         adLogId: adLogId,
      //       ),
      //     ),
      //   );
      //   ProfessorUtils.detailsCourseProfessor(context, adLogId);
      // }, */