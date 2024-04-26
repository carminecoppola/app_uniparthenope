import 'package:appuniparthenope/model/student_carrer_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_student_service.dart';
import 'package:flutter/material.dart';

class ExamController {
  final ApiStudentService apiService = ApiStudentService();

  Future<TotalExamStudent> totalExamStudent(
      User student, BuildContext context) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.studentTotalExams(student, context);

      final TotalExamStudent totExam = TotalExamStudent(
          totAdSuperate: responseData['totAdSuperate'],
          numAdSuperate: responseData['numAdSuperate'],
          cfuPar: responseData['cfuPar'],
          cfuTot: responseData['cfuTot']);

      return totExam;
    } catch (e) {
      throw Exception('Errore Caricamento Totale Esami');
    }
  }
}
