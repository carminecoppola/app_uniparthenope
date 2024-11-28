import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../../provider/professor_provider.dart';
import 'courseCheckExamCard.dart';
import '../../../navbar.dart';

class SessionsAvailableProfessorCourses extends StatelessWidget {
  const SessionsAvailableProfessorCourses({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final checkCourses =
        Provider.of<ProfessorDataProvider>(context).allExamInfoProfessor;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
              child: Text(
                AppLocalizations.of(context).translate('exams_prof_label'),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const SizedBox(height: 10),
            if (checkCourses != null && checkCourses.isNotEmpty) ...[
              Center(
                child: Text(
                  toCamelCase(checkCourses[0].esame!.split(' CFU')[0])
                      .toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.detailsColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                color: AppColors.primaryColor,
                indent: 50,
                endIndent: 50,
                thickness: 2,
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: checkCourses.length,
                itemBuilder: (context, index) {
                  final course = checkCourses[index];
                  return SingleCheckExamCard(
                    course: course,
                  );
                },
              ))
            ] else ...[
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('no_exams_prof'),
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
