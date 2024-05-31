import 'package:appuniparthenope/model/studentService/calendar_data.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/studentService/exam_data.dart';
import 'package:appuniparthenope/model/studentService/student_career_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_student_service.dart';
import 'package:flutter/material.dart';

import '../model/studentService/taxes_data.dart';

class StudentController {
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

  Future<AverageInfo> averageStudent(
      BuildContext context, User student, String averageType) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.studentAverage(context, student, averageType);

      final AverageInfo averageStats = AverageInfo(
          trenta: responseData['trenta'],
          baseTrenta: responseData['base_trenta'],
          baseCentodieci: responseData['base_centodieci'],
          centodieci: responseData['centodieci']);

      return averageStats;
    } catch (e) {
      throw Exception('Errore Caricamento della media degli esami');
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

  Future<Map<String, StatusCourse>> fetchAllCourseStatus(
      User student, List<CourseInfo> courses, BuildContext context) async {
    try {
      Map<String, StatusCourse> statusCoursesMap = {};

      for (CourseInfo course in courses) {
        final StatusCourse statusCourse =
            await apiService.getStatusExam(student, course, context);
        statusCoursesMap[course.codice] = statusCourse;
      }

      return statusCoursesMap;
    } catch (e) {
      throw Exception('Errore Caricamento Status dei corsi $e');
    }
  }

  Future<TaxesInfo> setTaxes(BuildContext context, User student) async {
    try {
      // Chiamata all'API per ottenere le tasse dello studente
      final Map<String, dynamic> taxesData =
          await apiService.getTaxes(student, context);

      // Estrai i dati necessari dalle tasse ricevute
      final String semaforo = taxesData['semaforo'];
      final List<Payed> payed = List<Payed>.from(
        taxesData['payed'].map((x) => Payed.fromJson(x)),
      );
      final List<ToPay> toPay = List<ToPay>.from(
        taxesData['to_pay'].map((x) => ToPay.fromJson(x)),
      );

      // Costruisci un oggetto TaxesInfo con i dati ottenuti
      final TaxesInfo taxesInfo = TaxesInfo(
        semaforo: semaforo,
        payed: payed,
        toPay: toPay,
      );

      // Ritorna l'oggetto TaxesInfo
      return taxesInfo;
    } catch (e) {
      print('Error during setTaxes: $e');
      throw Exception(
          'Errore durante il recupero delle informazioni sulle tasse');
    }
  }

  Future<List<LecturesInfo>> fetchLectures(
      BuildContext context, User student) async {
    try {
      final List<LecturesInfo> responseData =
          await apiService.getLectures(student, context);

      if (responseData.isEmpty) {
        print('\nErrore la lista degli esami è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore Caricamento delle lezioni dello studente');
    }
  }
}
