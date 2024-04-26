import 'package:appuniparthenope/model/student_carrer_data.dart';
import 'package:flutter/material.dart';

class ExamDataProvider extends ChangeNotifier {
  TotalExamStudent? _totalExamStudent;

  TotalExamStudent? get totalExamStudent => _totalExamStudent;

  // Metodo per impostare l'anagrafica dell'utente
  void setTotalExamStudent(TotalExamStudent totalExamStudent) {
    _totalExamStudent = totalExamStudent;
    notifyListeners();
  }
}
