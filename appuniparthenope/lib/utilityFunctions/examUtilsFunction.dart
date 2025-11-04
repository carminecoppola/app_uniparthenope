import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/check_exam_provider.dart';
import '../provider/exam_provider.dart';

/// Classe di utility per le operazioni legate agli appelli d'esame.
class CheckExamUtils {
  /// Ottiene e imposta tutti gli appelli disponibili per lo studente.
  ///
  /// Ora usa direttamente il provider invece del controller rimosso
  static Future<void> allAppelliStudent(
      BuildContext context, User? authenticatedUser) async {
    try {
      if (authenticatedUser == null) {
        throw Exception('Utente non autenticato');
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final examProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      final checkExamProvider =
          Provider.of<CheckDateExamProvider>(context, listen: false);

      final password = authProvider.password;
      final selectedCareer = authProvider.selectedCareer;
      final courseList = examProvider.allCourseStudent;

      if (password == null || selectedCareer == null) {
        AppLogger.warning('Dati autenticazione mancanti');
        return;
      }

      if (courseList == null || courseList.isEmpty) {
        AppLogger.info('Nessun corso disponibile per caricare gli appelli');
        checkExamProvider.setAllAppelliStudent([]);
        return;
      }

      // Usa il provider direttamente invece del controller
      await checkExamProvider.fetchAllAppelliStudent(
        userId: authenticatedUser.userId!,
        password: password,
        cdsId: selectedCareer['cdsId'],
        courseList: courseList,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Errore durante allAppelliStudent', e, stackTrace);
    }
  }
}
