import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/professor_controller.dart';
import '../model/user_data_login.dart';
import '../provider/professor_provider.dart';

class ProfessorUtils {
  static Future<void> allCourseProfessor(
      BuildContext context, User? authenticatedUser) async {
    final ProfessorController totalCourseController = ProfessorController();
    try {
      final allCourseProfessor = await totalCourseController
          .fetchAllCourseProfessor(authenticatedUser!, context);

      final courseDataProvider =
          Provider.of<ProfessorDataProvider>(context, listen: false);

      courseDataProvider.setAllCoursesProfessor(allCourseProfessor);
    } catch (e) {
      print('\nErrore during allCourseProfessor() $e');
    }
  }
}
