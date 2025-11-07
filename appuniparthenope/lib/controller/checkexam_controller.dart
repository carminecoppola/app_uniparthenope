import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/studentService/check_appello_data.dart';
import '../service/api_checkexam_service.dart';

class CheckExamController {
  final ApiCheckExamService apiService = ApiCheckExamService();

  /// Ottiene tutti gli appelli disponibili per un dato esame.
  Future<List<CheckAppello>> fetchAllAppelliStudent(
      User student, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final examProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      final selectedCareer = authProvider.selectedCareer;

      if (selectedCareer == null) {
        throw Exception('Nessuna carriera selezionata');
      }

      final result = await apiService.getAppelliStudent(
        userId: student.userId!,
        password: authProvider.password!,
        cdsId: selectedCareer['cdsId'],
        courseList: examProvider.allCourseStudent ?? [],
      );

      if (result.isSuccess) {
        print('Lunghezza lista appelli: ${result.data!.length}');
        if (result.data!.isEmpty) {
          print('\nWarning: la lista degli appelli è vuota.');
        }
        return result.data!;
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      throw Exception('Errore durante il caricamento degli appelli: $e');
    }
  }

  /// Prenota un appello d'esame.
  ///
  /// DEPRECATO: Non usato, usare CheckDateExamProvider.bookExamAppello() invece
  /* 
  Future<bool> bookExamAppello(
      BuildContext context, User student, int adId, int appId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final selectedCareer = authProvider.selectedCareer;

      if (selectedCareer == null) {
        throw Exception('Nessuna carriera selezionata');
      }

      final result = await apiService.bookExamAppello(
        userId: student.userId!,
        password: authProvider.password!,
        cdsId: selectedCareer['cdsId'],
        adId: adId,
        appId: appId,
      );

      if (result.isSuccess) {
        return result.data!;
      } else {
        print('Errore prenotazione: ${result.errorMessage}');
        return false;
      }
    } catch (e) {
      print('Errore durante la prenotazione dell\'appello: $e');
      return false;
    }
  }
  */
}
