import 'package:appuniparthenope/model/exam_data.dart';
import 'package:appuniparthenope/model/student_carrer_data.dart';
import 'package:flutter/material.dart';

class ExamDataProvider extends ChangeNotifier {
  TotalExamStudent? _totalExamStatsStudent;
  List<ExamData>? _allExamStudent;

  TotalExamStudent? get totalExamStudent => _totalExamStatsStudent;
  List<ExamData>? get allExamStudent => _allExamStudent;

  // Metodo per impostare l'anagrafica dell'utente
  void setTotalStatsExamStudent(TotalExamStudent totalExamStudent) {
    _totalExamStatsStudent = totalExamStudent;
    notifyListeners();
  }

  // Metodo per impostare l'anagrafica dell'utente
  void setAllExamStudent(List<ExamData> allExamStudent) {
    _allExamStudent = allExamStudent;
    notifyListeners();
  }
}
