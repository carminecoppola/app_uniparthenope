import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/check_exam_provider.dart';
import '../provider/exam_provider.dart';
import 'student_utils_function.dart';

class StudentExamSessionContext {
  const StudentExamSessionContext({
    required this.user,
    required this.password,
    required this.selectedCareer,
    required this.courseList,
  });

  final User user;
  final String password;
  final Map<String, dynamic> selectedCareer;
  final List<CourseInfo> courseList;

  int get cdsId => selectedCareer['cdsId'] as int;
  int? get stuId => int.tryParse(selectedCareer['stuId'].toString());
  Map<String, dynamic> get dettaglioTratto =>
      (selectedCareer['dettaglioTratto'] as Map<String, dynamic>?) ?? {};
}

/// Classe di utility per le operazioni legate agli appelli d'esame.
class CheckExamUtils {
  static Future<StudentExamSessionContext?> resolveStudentExamSessionContext(
    BuildContext context,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);

    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;

    if (user == null || password == null || selectedCareer == null) {
      AppLogger.warning('Contesto sessione esami incompleto');
      return null;
    }

    var courseList = examProvider.allCourseStudent;
    if (courseList == null || courseList.isEmpty) {
      await StudentUtils.allCourseStudent(context, user);
      if (!context.mounted) return null;
      courseList = examProvider.allCourseStudent;
    }

    if (courseList == null || courseList.isEmpty) {
      if (examProvider.courseLoadError != null) {
        AppLogger.warning(
            'Caricamento lista corsi fallito: ${examProvider.courseLoadError}');
      }
      AppLogger.warning('Lista corsi non disponibile per la sessione esami');
      return null;
    }

    return StudentExamSessionContext(
      user: user,
      password: password,
      selectedCareer: selectedCareer,
      courseList: courseList,
    );
  }

  /// Ottiene e imposta tutti gli appelli disponibili per lo studente.
  ///
  /// Ora usa direttamente il provider invece del controller rimosso
  static Future<void> allAppelliStudent(
      BuildContext context, User? authenticatedUser) async {
    try {
      if (authenticatedUser == null) {
        throw Exception('Utente non autenticato');
      }

      final checkExamProvider =
          Provider.of<CheckDateExamProvider>(context, listen: false);
      final examSessionContext =
          await resolveStudentExamSessionContext(context);
      if (examSessionContext == null) {
        checkExamProvider.clearAppelli();
        return;
      }

      await checkExamProvider.fetchAllAppelliStudent(
        userId: examSessionContext.user.userId!,
        password: examSessionContext.password,
        cdsId: examSessionContext.cdsId,
        courseList: examSessionContext.courseList,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Errore durante allAppelliStudent', e, stackTrace);
    }
  }
}
