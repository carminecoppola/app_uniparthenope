import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/professor_controller.dart';
import '../model/teacherService/session_professor_data.dart';
import '../model/user_data_login.dart';
import '../provider/professor_provider.dart';

class ProfessorUtils {
  static Future<void> allCourseProfessor(
      BuildContext context, User? authenticatedUser) async {
    final ProfessorController totalCourseController = ProfessorController();
    try {
      final professorSession = await totalCourseController.professorSession(
          authenticatedUser!, context);

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
      BuildContext context, User professor) async {
    final ProfessorController controller = ProfessorController();
    try {
      final session = await controller.professorSession(professor, context);
      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setProfessorSession(session);
      return session;
    } catch (e) {
      print(
          '\nErrore durante il caricamento della sessione del professore: $e');
      return null;
    }
  }

  static Future<DetailsCourseInfo?> detailsCourseProfessor(
      BuildContext context, int adLogId) async {
    final ProfessorController controller = ProfessorController();
    final professor = Provider.of<AuthProvider>(context, listen: false)
        .authenticatedUser!
        .user;
    try {
      final session = await controller.detailsCourseInfoProfessor(
          professor, adLogId, context);

      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setDetailsCourseProfessor(session);

      return session;
    } catch (e) {
      print(
          '\nErrore durante il caricamento delle info sui corsi dei professore: $e');
      return null;
    }
  }

  static Future<void> chechExamInfoProfessor(
      BuildContext context, int cdsId, int adId) async {
    final ProfessorController controller = ProfessorController();
    final professor = Provider.of<AuthProvider>(context, listen: false)
        .authenticatedUser!
        .user;
    try {
      final session = await controller.checkExamInfoProfessor(
          professor, cdsId, adId, context);

      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setAllCheckExamInfoProfessor(session);
    } catch (e) {
      print(
          '\nErrore durante il caricamento delle info sui corsi dei professore: $e');
    }
  }
}
