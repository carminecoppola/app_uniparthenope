import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/studentService/check_appello_data.dart';

class CheckDateExamProvider extends ChangeNotifier {
  List<CheckAppello> _allAppelliStudent = [];
  List<CheckAppello> get allAppelliStudent => _allAppelliStudent;

  void setAllAppelliStudent(List<CheckAppello> appelli) {
    _allAppelliStudent = appelli;
    _sortAppelliByDate();
    filtraSoloAppelliPrenotabili();
    notifyListeners();
  }

  void _sortAppelliByDate() {
    if (_allAppelliStudent.isNotEmpty) {
      _allAppelliStudent.sort((a, b) {
        final String? dateAStr = a.dataFine ?? a.dataEsame;
        final String? dateBStr = b.dataFine ?? b.dataEsame;
        if (dateAStr == null || dateBStr == null) return 0;

        // Prova il parsing automatico ISO, fallback a altri formati se necessario
        DateTime? dateA, dateB;
        try {
          dateA = DateTime.parse(dateAStr);
        } catch (_) {
          try {
            dateA = DateFormat('yyyy/MM/dd HH:mm').parse(dateAStr);
          } catch (_) {
            dateA = null;
          }
        }
        try {
          dateB = DateTime.parse(dateBStr);
        } catch (_) {
          try {
            dateB = DateFormat('yyyy/MM/dd HH:mm').parse(dateBStr);
          } catch (_) {
            dateB = null;
          }
        }
        if (dateA == null || dateB == null) return 0;

        // Dal più vicino al più lontano (ascendente)
        return dateA.compareTo(dateB);
      });
    }
  }

  void filtraSoloAppelliPrenotabili() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _allAppelliStudent = _allAppelliStudent.where((appello) {
      final dataStr = appello.dataFine ?? appello.dataEsame;
      if (dataStr == null) return false;
      DateTime? date;
      try {
        date = DateTime.tryParse(dataStr);
        date ??= DateFormat('dd/MM/yyyy').parseStrict(dataStr);
      } catch (_) {
        return false;
      }
      final appelloDate = DateTime(date.year, date.month, date.day);
      return !appelloDate.isBefore(today);
    }).toList()
      ..sort((a, b) {
        final dataStrA = a.dataFine ?? a.dataEsame;
        final dataStrB = b.dataFine ?? b.dataEsame;
        DateTime? dateA;
        DateTime? dateB;
        try {
          dateA = DateTime.tryParse(dataStrA!);
          dateA ??= DateFormat('dd/MM/yyyy').parseStrict(dataStrA);
        } catch (_) {
          dateA = DateTime(9999, 1, 1); // mette in fondo quelli malformati
        }
        try {
          dateB = DateTime.tryParse(dataStrB!);
          dateB ??= DateFormat('dd/MM/yyyy').parseStrict(dataStrB);
        } catch (_) {
          dateB = DateTime(9999, 1, 1);
        }
        return dateA.compareTo(dateB); // dal più vicino al più lontano
      });

    notifyListeners();
  }
}
