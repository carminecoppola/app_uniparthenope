import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/studentService/exam_data.dart';
import 'package:appuniparthenope/model/studentService/student_career_data.dart';
import 'package:flutter/material.dart';

import '../model/studentService/events_data.dart';

class ExamDataProvider extends ChangeNotifier {
  TotalExamStudent? _totalExamStatsStudent;
  AverageInfo? _aritmeticAverageStatsStudent;
  AverageInfo? _weightedAverageStatsStudent;
  List<ExamData>? _allExamStudent;
  List<CourseInfo>? _allCourseStudent;
  List<StatusCourse>? _allStatusCourses;
  Map<String, StatusCourse>? _statusCoursesMap; // Aggiungi questa variabile
  List<EventsInfo>? _allEvents;
  double? _gpa;

  TotalExamStudent? get totalExamStudent => _totalExamStatsStudent;
  AverageInfo? get aritmeticAverageStatsStudent =>
      _aritmeticAverageStatsStudent;
  AverageInfo? get weightedAverageStatsStudent => _weightedAverageStatsStudent;
  List<ExamData>? get allExamStudent => _allExamStudent;
  List<CourseInfo>? get allCourseStudent => _allCourseStudent;
  List<StatusCourse>? get allStatusCourses => _allStatusCourses;
  Map<String, StatusCourse>? get statusCoursesMap =>
      _statusCoursesMap; // Aggiungi questo getter
  List<EventsInfo>? get allEventsList => _allEvents;
  double? get allGPA => _gpa;

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

  // Metodo per impostare la mappa degli stati dei corsi dell'utente
  void setStatusCoursesMap(Map<String, StatusCourse> statusCoursesMap) {
    _statusCoursesMap = statusCoursesMap;
    notifyListeners();
  }

  // Metodo per impostare gli eventi
  void setAllEvents(List<EventsInfo> allEventsList) {
    _allEvents = allEventsList;
    notifyListeners();
  }

  // Metodo per impostare gli eventi
  void setGPA(double gpa) {
    _gpa = gpa;
    notifyListeners();
  }
}
