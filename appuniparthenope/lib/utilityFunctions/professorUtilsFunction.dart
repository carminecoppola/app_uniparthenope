import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/professor_controller.dart';
import '../model/teacherService/session_professor_data.dart';
import '../model/user_data_login.dart';
import '../provider/professor_provider.dart';

class ProfessorUtils {
  static Future<void> allCourseProfessor(
    BuildContext context,
    User? authenticatedUser,
  ) async {
    final ProfessorController totalCourseController = ProfessorController();
    try {
      // Ottenere la sessione del professore
      final professorSession = await totalCourseController.professorSession(
          authenticatedUser!, context);

      // Estrarre l'aaId dalla sessione
      final aaId = professorSession.aaId;

      // Ottenere tutti i corsi del professore usando aaId
      final allCourseProfessor = await totalCourseController
          .fetchAllCourseProfessor(authenticatedUser, aaId!, context);

      final courseDataProvider =
          Provider.of<ProfessorDataProvider>(context, listen: false);

      courseDataProvider.setAllCoursesProfessor(allCourseProfessor);
    } catch (e) {
      print('\nErrore durante allCourseProfessor() $e');
    }
  }

  static Future<SessionProfessorInfo?> professorSession(
    BuildContext context,
    User professor,
  ) async {
    final ProfessorController controller = ProfessorController();
    try {
      final session = await controller.professorSession(professor, context);
      return session;
    } catch (e) {
      print(
          '\nErrore durante il caricamento della sessione del professore: $e');
      return null;
    }
  }
}
