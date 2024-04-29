import 'package:appuniparthenope/model/course_data.dart';
import 'package:appuniparthenope/model/exam_data.dart';
import 'package:appuniparthenope/model/student_carrer_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_student_service.dart';
import 'package:flutter/material.dart';

class ExamController {
  final ApiStudentService apiService = ApiStudentService();

  Future<TotalExamStudent> totalExamStatsStudent(
      User student, BuildContext context) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.studentTotalExamsStats(student, context);

      final TotalExamStudent totStatsExam = TotalExamStudent(
          totAdSuperate: responseData['totAdSuperate'],
          numAdSuperate: responseData['numAdSuperate'],
          cfuPar: responseData['cfuPar'],
          cfuTot: responseData['cfuTot']);

      return totStatsExam;
    } catch (e) {
      throw Exception(
          'Errore Caricamento delle statistiche totali degli esami');
    }
  }

  Future<List<ExamData>> fetchAllExamStudent(
      User student, BuildContext context) async {
    try {
      // Wait for the API response to complete
      final List<ExamData> responseData =
          await apiService.getStudentExams(student, context);

      if (responseData.isEmpty) {
        print('\nErrore la lista degli esami è vuota.');
      }
      return responseData;
    } catch (e) {
      throw Exception('Errore Caricamento Esami $e');
    }
  }

  Future<List<CourseInfo>> fetchAllCourseStudent(
      User student, BuildContext context) async {
    try {
      final List<CourseInfo> responseData =
          await apiService.getAllCourse(student, context);

      print('Lunghezza lista${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore la lista dei corsi è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore Caricamento Corsi $e');
    }
  }
}
