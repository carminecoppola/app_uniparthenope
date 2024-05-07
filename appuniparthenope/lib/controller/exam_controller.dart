import 'package:appuniparthenope/model/studentService/calendar_data.dart';
import 'package:appuniparthenope/model/studentService/course_data.dart';
import 'package:appuniparthenope/model/studentService/exam_data.dart';
import 'package:appuniparthenope/model/studentService/student_carrer_data.dart';
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

  Future<List<StatusCourse>> fetchAllCourseStatus(
      User student, List<CourseInfo> courses, BuildContext context) async {
    try {
      List<StatusCourse> allStatusCourses = [];

      // Itera su tutti i corsi e recupera lo stato di ciascun corso
      for (CourseInfo course in courses) {
        final StatusCourse statusCourse =
            await apiService.getStatusExam(student, course, context);
        allStatusCourses.add(statusCourse);
      }

      //print('\nfetchAllCourseStatus(), Stati: $allStatusCourses');

      return allStatusCourses;
    } catch (e) {
      throw Exception('Errore Caricamento Status dei corsi $e');
    }
  }

  //Per trovare i corsi
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

  //Per ottenere gli eventi
  Future<List<EventsInfo>> getAllEvents(BuildContext context) async {
    try {
      List<EventsInfo>? events = [];
      List<EventsInfo> allEvents = await apiService.getEvents(context);
      print('\n\nBro vediamo: $allEvents');
      if (events != null) {
        events.addAll(allEvents);
      }
      return events ?? []; // Return empty list if events is null
    } catch (e) {
      throw Exception('Errore Caricamento Eventi $e');
    }
  }
}
