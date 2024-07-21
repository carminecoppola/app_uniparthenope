import 'package:appuniparthenope/model/teacherService/list_student_exam.dart';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_teacher_service.dart';
import 'package:flutter/material.dart';
import '../model/teacherService/check_exam_data.dart';
import '../model/teacherService/course_professor_data.dart';

class ProfessorController {
  final ApiTeacherService apiService = ApiTeacherService();

  /// Ottiene tutti i corsi del professore per l'anno accademico specificato.
  /// Ritorna una lista di [CourseProfessorInfo].
  Future<List<CourseProfessorInfo>> fetchAllCourseProfessor(
      User professor, String? aaId, BuildContext context) async {
    try {
      final List<CourseProfessorInfo> responseData =
          await apiService.getAllCourse(professor, aaId!, context);

      print('\nLunghezza lista: ${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore: la lista dei corsi dei professori è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento dei corsi dei professori: $e');
    }
  }

  /// Ottiene la sessione del professore.
  /// Ritorna un oggetto [SessionProfessorInfo].
  Future<SessionProfessorInfo> professorSession(
      User professor, BuildContext context) async {
    try {
      final SessionProfessorInfo responseData =
          await apiService.getSession(professor, context);

      return responseData;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento della sessione dei professori: $e');
    }
  }

  /// Ottiene i dettagli del corso del professore per un determinato [adLogId].
  /// Ritorna un oggetto [DetailsCourseInfo].
  Future<DetailsCourseInfo> detailsCourseInfoProfessor(
      User professor, int adLogId, BuildContext context) async {
    try {
      final DetailsCourseInfo responseData =
          await apiService.getDetailsCourse(professor, adLogId, context);

      return responseData;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento delle informazioni sui corsi dei professori: $e');
    }
  }

  /// Ottiene le informazioni sugli esami del professore per un determinato [cdsId] e [adId].
  /// Ritorna una lista di [CheckExamInfo].
  Future<List<CheckExamInfo>> checkExamInfoProfessor(
      User professor, int cdsId, int adId, BuildContext context) async {
    try {
      final List<CheckExamInfo> responseData =
          await apiService.getCheckExamInfo(professor, cdsId, adId, context);

      return responseData;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento delle informazioni sugli appelli dei corsi dei professori: $e');
    }
  }

  /// Ottiene la lista degli studenti per un determinato esame.
  /// Ritorna una lista di [ListStudentsExam].
  Future<List<ListStudentsExam>> allStudentListForExam(User professor,
      String cdsId, String aaId, String appId, BuildContext context) async {
    try {
      final List<ListStudentsExam> responseData = await apiService
          .getStudentListExam(professor, cdsId, aaId, appId, context);

      return responseData;
    } catch (e) {
      throw Exception(
          'Errore durante il caricamento delle informazioni sulla lista degli studenti per l\'esame: $e');
    }
  }
}
