import 'package:appuniparthenope/model/studentService/reservation_data.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/studentService/exam_data.dart';
import 'package:appuniparthenope/model/studentService/student_career_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/studentService/events_data.dart';

class ExamDataProvider extends ChangeNotifier {
  String? _pianoId;
  TotalExamStudent? _totalExamStatsStudent;
  AverageInfo? _aritmeticAverageStatsStudent;
  AverageInfo? _weightedAverageStatsStudent;
  List<ExamData>? _allExamStudent;
  List<CourseInfo>? _allCourseStudent;
  List<StatusCourse>? _allStatusCourses;
  Map<String, StatusCourse>? _statusCoursesMap;
  List<EventsInfo>? _allEvents;
  List<ReservationInfo>? _allReservation;

  String? get pianoId => _pianoId;

  TotalExamStudent? get totalExamStudent => _totalExamStatsStudent;

  AverageInfo? get aritmeticAverageStatsStudent =>
      _aritmeticAverageStatsStudent;

  AverageInfo? get weightedAverageStatsStudent => _weightedAverageStatsStudent;

  List<ExamData>? get allExamStudent => _allExamStudent;

  List<CourseInfo>? get allCourseStudent => _allCourseStudent;

  List<StatusCourse>? get allStatusCourses => _allStatusCourses;

  Map<String, StatusCourse>? get statusCoursesMap => _statusCoursesMap;

  List<EventsInfo>? get allEventsList => _allEvents;

  List<ReservationInfo>? get allReservationInfo => _allReservation;

  // Metodo per impostare l'anagrafica dell'utente
  void setPianoId(String? pianoId) {
    _pianoId = pianoId;
    notifyListeners();
  }

  // Metodo per impostare le statistiche degli esami dell'utente
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

  void setAllReservationStudent(List<ReservationInfo> allReservation) {
    _allReservation = allReservation;
    _sortReservationByDate();
    notifyListeners();
  }

  void clearReservations() {
    _allReservation = [];
    notifyListeners();
  }

  // Metodo per ripulire i dati della carriera
  void clearCareerData() {
    _pianoId = null;
    _totalExamStatsStudent = null;
    _aritmeticAverageStatsStudent = null;
    _weightedAverageStatsStudent = null;
    _allExamStudent = null;
    _allCourseStudent = null;
    _allStatusCourses = null;
    _statusCoursesMap = null;
    _allEvents = null;
    _allReservation = null;
    notifyListeners();
  }

  // Ordina le prenotazioni per data più recente
  void _sortReservationByDate() {
    if (_allReservation != null) {
      final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
      _allReservation!.sort((a, b) {
        DateTime dateA = dateFormat.parse(a.dataEsa!);
        DateTime dateB = dateFormat.parse(b.dataEsa!);
        return dateB.compareTo(dateA);
      });
    }
  }
}
