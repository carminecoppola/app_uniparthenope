import 'package:appuniparthenope/model/teacherService/check_exam_data.dart';
import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:flutter/material.dart';

class ProfessorDataProvider extends ChangeNotifier {
  List<CourseProfessorInfo>? _allCourseProfessor;
  SessionProfessorInfo? _profSession;
  DetailsCourseInfo? _detailsCourse;
  List<CheckExamInfo>? _allCheckExamInfoProfessor;

  List<CourseProfessorInfo>? get allCourseProfessor => _allCourseProfessor;
  SessionProfessorInfo? get profSession => _profSession;
  DetailsCourseInfo? get detailsCourse => _detailsCourse;
  List<CheckExamInfo>? get allCheckExamInfoProfessor =>
      _allCheckExamInfoProfessor;

  void setAllCoursesProfessor(List<CourseProfessorInfo> allCourseProfessor) {
    _allCourseProfessor = allCourseProfessor;
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

  void setAllCheckExamInfoProfessor(
      List<CheckExamInfo> allCheckExamInfoProfessor) {
    // Ordina la lista in base alla dataEsame più recente
    allCheckExamInfoProfessor.sort((a, b) {
      // Converti le date in DateTime per poterle confrontare
      DateTime dateA = DateTime.parse(_convertToDate(a.dataEsame));
      DateTime dateB = DateTime.parse(_convertToDate(b.dataEsame));
      // Ordina in ordine decrescente
      return dateB.compareTo(dateA);
    });
    _allCheckExamInfoProfessor = allCheckExamInfoProfessor;
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
