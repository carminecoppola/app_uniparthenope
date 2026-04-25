import 'package:appuniparthenope/model/teacherService/check_exam_data.dart';
import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:flutter/material.dart';

import '../model/teacherService/list_student_exam.dart';

class ProfessorDataProvider extends ChangeNotifier {
  List<CourseProfessorInfo>? _allCourseProfessor;
  CourseProfessorInfo? _selectedCourse;
  SessionProfessorInfo? _profSession;
  DetailsCourseInfo? _detailsCourse;
  List<CheckExamInfo>? _allExamInfoProfessor;
  List<ListStudentsExam>? _allStudentListExam;

  List<CourseProfessorInfo>? get allCourseProfessor => _allCourseProfessor;
  CourseProfessorInfo? get selectedCourse => _selectedCourse;
  SessionProfessorInfo? get profSession => _profSession;
  DetailsCourseInfo? get detailsCourse => _detailsCourse;
  List<CheckExamInfo>? get allExamInfoProfessor => _allExamInfoProfessor;
  List<ListStudentsExam>? get allStudentListExam => _allStudentListExam;

  void setAllCoursesProfessor(List<CourseProfessorInfo> allCourseProfessor) {
    _allCourseProfessor = allCourseProfessor;
    notifyListeners();
  }

  void setSelectedCourse(CourseProfessorInfo selectedCourse) {
    _selectedCourse = selectedCourse;
    notifyListeners();
  }

  void setProfessorSession(SessionProfessorInfo professorSession) {
    _profSession = professorSession;
    notifyListeners();
  }

  void setDetailsCourseProfessor(DetailsCourseInfo detailsCourse) {
    _detailsCourse = detailsCourse;
    notifyListeners();
  }

  void setAllExamInfoProfessor(List<CheckExamInfo> allExamInfoProfessor) {
    // Ordina la lista in base alla dataEsame più recente
    allExamInfoProfessor.sort((a, b) {
      // Converti le date in DateTime per poterle confrontare
      DateTime dateA = DateTime.parse(_convertToDate(a.dataEsame));
      DateTime dateB = DateTime.parse(_convertToDate(b.dataEsame));
      // Ordina in ordine decrescente
      return dateB.compareTo(dateA);
    });
    _allExamInfoProfessor = allExamInfoProfessor;
    notifyListeners();
  }

  void setAllStudentListExam(List<ListStudentsExam> allStudentListExam) {
    _allStudentListExam = allStudentListExam;
    notifyListeners();
  }

  String _convertToDate(String? dateStr) {
    // Converte la data nel formato "dd/MM/yyyy" in "yyyy-MM-dd" per il corretto ordinamento
    if (dateStr != null && dateStr.isNotEmpty) {
      List<String> dateParts = dateStr.split('/');
      if (dateParts.length == 3) {
        return '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
      }
    }
    // Se la data non è valida, restituisce una stringa vuota
    return '';
  }
}
