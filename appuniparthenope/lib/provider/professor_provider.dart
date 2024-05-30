import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:flutter/material.dart';

class ProfessorDataProvider extends ChangeNotifier {
  List<CourseProfessorInfo>? _allCourseProfessor;
  SessionProfessorInfo? _profSession;

  List<CourseProfessorInfo>? get allCourseProfessor => _allCourseProfessor;
  SessionProfessorInfo? get profSession => _profSession;

  void setAllCoursesProfessor(List<CourseProfessorInfo> allCourseProfessor) {
    _allCourseProfessor = allCourseProfessor;
    notifyListeners();
  }

  void setProfessorSession(SessionProfessorInfo professorSession) {
    _profSession = professorSession;
    notifyListeners();
  }
}
