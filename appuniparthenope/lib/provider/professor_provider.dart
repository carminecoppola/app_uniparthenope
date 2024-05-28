import 'package:appuniparthenope/model/teacherService/course_professr_data.dart';
import 'package:flutter/material.dart';

class ProfessorDataProvider extends ChangeNotifier {
  List<CourseProfessorInfo>? _allCourseProfessor;

  List<CourseProfessorInfo>? get allCourseProfessor => _allCourseProfessor;

  void setAllCoursesProfessor(List<CourseProfessorInfo> allCourseProfessor) {
    _allCourseProfessor = allCourseProfessor;
    notifyListeners();
  }
}
