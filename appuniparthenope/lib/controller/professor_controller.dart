import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_teacher_service.dart';
import 'package:flutter/material.dart';
import '../model/teacherService/course_professor_data.dart';

class ProfessorController {
  final ApiTeacherService apiService = ApiTeacherService();

  Future<List<CourseProfessorInfo>> fetchAllCourseProfessor(
      User professor, int aaId, BuildContext context) async {
    try {
      final List<CourseProfessorInfo> responseData =
          await apiService.getAllCourse(professor, aaId, context);

      print('\nLunghezza lista${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore la lista dei corsi dei professori è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore Caricamento Corsi dei Professori $e');
    }
  }

  Future<SessionProfessorInfo> professorSession(
      User professor, BuildContext context) async {
    try {
      final SessionProfessorInfo responseData =
          await apiService.getSession(professor, context);

      return responseData;
    } catch (e) {
      throw Exception('Errore Caricamento della Sessione dei Professori $e');
    }
  }
}
