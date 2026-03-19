import 'package:appuniparthenope/controller/professor_controller.dart';
import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Classe di utility per le operazioni legate ai professori.
class ProfessorUtils {
  /// Ottiene tutti i corsi di un professore.
  static Future<void> allCourseProfessor(
      BuildContext context, User authenticatedUser) async {
    final ProfessorController totalCourseController = ProfessorController();
    try {
      // Ottiene la sessione del professore per l'anno accademico corrente.
      final professorSession = await totalCourseController.professorSession(
          authenticatedUser, context);

      // Ottiene l'ID dell'anno accademico dalla sessione del professore.
      final aaId = professorSession.aaId;

      // Ottiene tutti i corsi del professore usando l'ID dell'anno accademico.
      final allCourseProfessor = await totalCourseController
          .fetchAllCourseProfessor(authenticatedUser, aaId!, context);

      // Aggiorna il provider con i corsi del professore.
      final courseDataProvider =
          Provider.of<ProfessorDataProvider>(context, listen: false);
      courseDataProvider.setAllCoursesProfessor(allCourseProfessor);
    } catch (e) {
      print('\nErrore durante allCourseProfessor() $e');
    }
  }

  /// Ottiene le informazioni sulla sessione di un professore.
  static Future<SessionProfessorInfo?> professorSession(
      BuildContext context, User professor) async {
    final ProfessorController controller = ProfessorController();
    try {
      // Ottiene la sessione del professore.
      final session = await controller.professorSession(professor, context);

      // Aggiorna il provider con la sessione del professore.
      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setProfessorSession(session);

      return session;
    } catch (e) {
      print(
          '\nErrore durante il caricamento della sessione del professore: $e');
      return null;
    }
  }

  /// Ottiene i dettagli di un corso di un professore.
  static Future<DetailsCourseInfo?> detailsCourseProfessor(
      BuildContext context, int adLogId) async {
    final ProfessorController controller = ProfessorController();
    final professor = Provider.of<AuthProvider>(context, listen: false)
        .authenticatedUser!
        .user;
    try {
      // Ottiene i dettagli del corso per il professore specificato.
      final session = await controller.detailsCourseInfoProfessor(
          professor, adLogId, context);

      // Aggiorna il provider con i dettagli del corso del professore.
      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setDetailsCourseProfessor(session);

      return session;
    } catch (e) {
      print(
          '\nErrore durante il caricamento delle info sui corsi dei professore: $e');
      return null;
    }
  }

  /// Controlla le informazioni degli esami di un professore.
  static Future<void> checkExamInfoProfessor(
      BuildContext context, int cdsId, int adId) async {
    final ProfessorController controller = ProfessorController();
    final professor = Provider.of<AuthProvider>(context, listen: false)
        .authenticatedUser!
        .user;
    try {
      // Ottiene le informazioni sugli esami per il professore specificato.
      final session = await controller.checkExamInfoProfessor(
          professor, cdsId, adId, context);

      // Aggiorna il provider con le informazioni sugli esami del professore.
      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setAllExamInfoProfessor(session);
    } catch (e) {
      print(
          '\nErrore durante il caricamento delle info sugli esami dei corsi dei professore: $e');
    }
  }

  /// Ottiene la lista di tutti gli studenti per un esame di un professore.
  static Future<void> allStudentListExam(
      BuildContext context, String cdsId, String aaId, String appId) async {
    final ProfessorController controller = ProfessorController();
    final professor = Provider.of<AuthProvider>(context, listen: false)
        .authenticatedUser!
        .user;
    try {
      // Ottiene la lista di tutti gli studenti per un esame di un professore.
      final session = await controller.allStudentListForExam(
          professor, cdsId, aaId, appId, context);

      print('\n\n allStudentListExam: $session');

      // Aggiorna il provider con la lista di tutti gli studenti per l'esame.
      Provider.of<ProfessorDataProvider>(context, listen: false)
          .setAllStudentListExam(session);
    } catch (e) {
      print(
          '\nErrore durante il caricamento della lista degli studenti per l\'esame del professore: $e');
    }
  }
}
