import 'package:appuniparthenope/model/course_data.dart';
import 'package:appuniparthenope/model/exam_data.dart';
import 'package:appuniparthenope/model/student_carrer_data.dart';
import 'package:flutter/material.dart';

class ExamDataProvider extends ChangeNotifier {
  TotalExamStudent? _totalExamStatsStudent;
  List<ExamData>? _allExamStudent;
  List<CourseInfo>? _allCourseStudent;

  TotalExamStudent? get totalExamStudent => _totalExamStatsStudent;
  List<ExamData>? get allExamStudent => _allExamStudent;
  List<CourseInfo>? get allCourseStudent => _allCourseStudent;

  // Metodo per impostare l'anagrafica dell'utente
  void setTotalStatsExamStudent(TotalExamStudent totalExamStudent) {
    _totalExamStatsStudent = totalExamStudent;
    notifyListeners();
  }

  // Metodo per impostare gli esami dell'utente
  void setAllExamStudent(List<ExamData> allExamStudent) {
    _allExamStudent = allExamStudent;
    notifyListeners();
  }

  // Metodo per impostare i corsi dell'utente
  void setAllCoursesStudent(List<CourseInfo> allCourseStudent) {
    _allCourseStudent = allCourseStudent;
    notifyListeners();
  }
}
