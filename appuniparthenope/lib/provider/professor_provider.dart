import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:flutter/material.dart';

class ProfessorDataProvider extends ChangeNotifier {
  List<CourseProfessorInfo>? _allCourseProfessor;
  SessionProfessorInfo? _profSession;
  DetailsCourseInfo? _detailsCourse;

  List<CourseProfessorInfo>? get allCourseProfessor => _allCourseProfessor;
  SessionProfessorInfo? get profSession => _profSession;
  DetailsCourseInfo? get detailsCourse => _detailsCourse;

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
}
