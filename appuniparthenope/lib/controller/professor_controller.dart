import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/service/api_teacher_service.dart';
import 'package:flutter/material.dart';
import '../model/teacherService/course_professr_data.dart';

class ProfessorController {
  final ApiTeacherService apiService = ApiTeacherService();

  Future<List<CourseProfessorInfo>> fetchAllCourseProfessor(
      User professor, BuildContext context) async {
    try {
      final List<CourseProfessorInfo> responseData =
          await apiService.getAllCourse(professor, context);

      print('\nLunghezza lista${responseData.length}');

      if (responseData.isEmpty) {
        print('\nErrore la lista dei corsi del professore è vuota.');
      }

      return responseData;
    } catch (e) {
      throw Exception('Errore Caricamento Corsi Professore $e');
    }
  }
}
