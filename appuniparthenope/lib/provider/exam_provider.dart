import 'package:appuniparthenope/model/course_data.dart';
import 'package:appuniparthenope/model/exam_data.dart';
import 'package:appuniparthenope/model/student_carrer_data.dart';
import 'package:flutter/material.dart';

class ExamDataProvider extends ChangeNotifier {
  TotalExamStudent? _totalExamStatsStudent;
  AverageInfo? _aritmeticAverageStatsStudent;
  AverageInfo? _weightedAverageStatsStudent;
  List<ExamData>? _allExamStudent;
  List<CourseInfo>? _allCourseStudent;
  List<StatusCourse>? _allStatusCourses;

  TotalExamStudent? get totalExamStudent => _totalExamStatsStudent;
  AverageInfo? get aritmeticAverageStatsStudent =>
      _aritmeticAverageStatsStudent;
  AverageInfo? get weightedAverageStatsStudent => _weightedAverageStatsStudent;
  List<ExamData>? get allExamStudent => _allExamStudent;
  List<CourseInfo>? get allCourseStudent => _allCourseStudent;
  List<StatusCourse>? get allStatusCourses => _allStatusCourses;

  // Metodo per impostare l'anagrafica dell'utente
  void setTotalStatsExamStudent(TotalExamStudent totalExamStudent) {
    _totalExamStatsStudent = totalExamStudent;
    notifyListeners();
  }

  void setTotalAverageExamStudent(AverageInfo aritmeticAverageStatsStudent,
      AverageInfo weightedAverageStatsStudent) {
    _aritmeticAverageStatsStudent = aritmeticAverageStatsStudent;
    _weightedAverageStatsStudent = weightedAverageStatsStudent;
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

  // Metodo per impostare lo stato dei corsi dell'utente
  void setAllStatusCourses(List<StatusCourse> allStatusCourses) {
    _allStatusCourses = allStatusCourses;
    notifyListeners();
  }
}
