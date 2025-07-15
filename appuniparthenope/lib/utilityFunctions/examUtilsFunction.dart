import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/checkexam_controller.dart';
import '../provider/check_exam_provider.dart';

/// Classe di utility per le operazioni legate agli studenti.
class CheckExamUtils {
  /// Ottiene e imposta tutti gli appelli disponibili per uno specifico esame.
  static Future<void> allAppelliStudent(
      BuildContext context, User? authenticatedUser) async {
    final CheckExamController checkExamController = CheckExamController();
    try {
      if (authenticatedUser == null) {
        throw Exception('Utente non autenticato');
      }

      final allAppelliStudent = await checkExamController
          .fetchAllAppelliStudent(authenticatedUser, context);

      final examDataProvider =
          Provider.of<CheckDateExamProvider>(context, listen: false);
      examDataProvider.setAllAppelliStudent(allAppelliStudent);
    } catch (e) {
      print('\nErrore durante allAppelliStudent() $e');
    }
  }
}
