import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:flutter/material.dart';
import '../model/studentService/check_appello_data.dart';
import '../service/api_checkexam_service.dart';

class CheckExamController {
  final ApiCheckExamService apiService = ApiCheckExamService();

  /// Ottiene tutti gli appelli disponibili per un dato esame.
  Future<List<CheckAppello>> fetchAllAppelliStudent(
      User student, BuildContext context) async {
    try {
      final List<CheckAppello> responseData =
          await apiService.getAppelliStudent(student, context);

      print('Lunghezza lista appelli: ${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore: la lista degli appelli è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore durante il caricamento degli appelli: $e');
    }
  }
}
