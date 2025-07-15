import 'package:appuniparthenope/model/studentService/calendar_data.dart';
import 'package:appuniparthenope/model/studentService/reservation_data.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/studentService/exam_data.dart';
import 'package:appuniparthenope/model/studentService/student_career_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_student_service.dart';
import 'package:flutter/material.dart';

import '../model/studentService/check_appello_data.dart';
import '../model/studentService/taxes_data.dart';

class StudentController {
  final ApiStudentService apiService = ApiStudentService();

  /// Ottiene le statistiche totali degli esami di uno studente.
  /// Ritorna un [TotalExamStudent].
  Future<TotalExamStudent> totalExamStatsStudent(
      User student, BuildContext context) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.studentTotalExamsStats(student, context);
      print('Risposta TotalExamStudent: $responseData');

      final TotalExamStudent totStatsExam = TotalExamStudent(
          totAdSuperate: responseData['totAdSuperate'],
          numAdSuperate: responseData['numAdSuperate'],
          cfuPar: responseData['cfuPar'],
          cfuTot: responseData['cfuTot']);

      return totStatsExam;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento delle statistiche totali degli esami: $e');
    }
  }

  /// Ottiene la media degli esami di uno studente.
  /// Ritorna un [AverageInfo].
  Future<AverageInfo> averageStudent(
      BuildContext context, User student, String averageType) async {
    try {
      final Map<String, dynamic> responseData =
          await apiService.studentAverage(context, student, averageType);
      print('Risposta averageStudent(): $responseData');

      final AverageInfo averageStats = AverageInfo(
          trenta: responseData['trenta'],
          baseTrenta: responseData['base_trenta'],
          baseCentodieci: responseData['base_centodieci'],
          centodieci: responseData['centodieci']);

      return averageStats;
    } catch (e) {
      throw Exception('Errore durante il caricamento della media degli esami');
    }
  }

  /// Ottiene tutti gli esami di uno studente.
  /// Ritorna una lista di [ExamData].
  Future<List<ExamData>> fetchAllExamStudent(
      User student, BuildContext context) async {
    try {
      final List<ExamData> responseData =
          await apiService.getStudentExams(student, context);

      if (responseData.isEmpty) {
        print('\nfetchAllExamStudent(): la lista degli esami è vuota.');
      }
      return responseData;
    } catch (e) {
      throw Exception('Errore durante il caricamento degli esami: $e');
    }
  }

  /// Ottiene tutti i corsi di uno studente.
  /// Ritorna una lista di [CourseInfo].
  Future<List<CourseInfo>> fetchAllCourseStudent(
      User student, BuildContext context) async {
    try {
      final List<CourseInfo> responseData =
          await apiService.getAllCourse(student, context);

      print('Lunghezza lista corsi: ${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore: la lista dei corsi è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore durante il caricamento dei corsi: $e');
    }
  }

  /// Ottiene lo stato di tutti i corsi di uno studente.
  /// Ritorna una mappa di [StatusCourse] con il codice del corso come chiave.
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
      throw Exception(
          'Errore durante il caricamento dello stato dei corsi: $e');
    }
  }

  /// Ottiene le tasse di uno studente.
  /// Ritorna un [TaxesInfo].
  Future<TaxesInfo> setTaxes(BuildContext context, User student) async {
    try {
      final Map<String, dynamic> taxesData =
          await apiService.getTaxes(student, context);

      final String semaforo = taxesData['semaforo'];
      final List<Payed> payed = List<Payed>.from(
        taxesData['payed'].map((x) => Payed.fromJson(x)),
      );
      final List<ToPay> toPay = List<ToPay>.from(
        taxesData['to_pay'].map((x) => ToPay.fromJson(x)),
      );

      final TaxesInfo taxesInfo = TaxesInfo(
        semaforo: semaforo,
        payed: payed,
        toPay: toPay,
      );

      return taxesInfo;
    } catch (e) {
      print('Errore durante setTaxes: $e');
      throw Exception(
          'Errore durante il recupero delle informazioni sulle tasse');
    }
  }

  /// Ottiene tutte le lezioni di uno studente.
  /// Ritorna una lista di [LecturesInfo].
  Future<List<LecturesInfo>> fetchLectures(
      BuildContext context, User student) async {
    try {
      final List<LecturesInfo> responseData =
          await apiService.getLectures(student, context);

      if (responseData.isEmpty) {
        print('\nErrore: la lista delle lezioni è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento delle lezioni dello studente');
    }
  }

  /// Ottiene tutte le prenotazioni di uno studente.
  /// Ritorna una lista di [ReservationInfo].
  Future<List<ReservationInfo>> fetchAllReservationStudent(
      User student, BuildContext context) async {
    try {
      final List<ReservationInfo> responseData =
          await apiService.getReservationStudents(student, context);

      print('Lunghezza lista prenotazioni: ${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore: la lista delle prenotazioni è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore durante il caricamento delle prenotazioni: $e');
    }
  }
}
