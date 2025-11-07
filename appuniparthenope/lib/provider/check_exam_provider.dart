import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/core/result.dart';
import 'package:appuniparthenope/core/service_locator.dart';
import 'package:appuniparthenope/service/api_checkexam_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/studentService/check_appello_data.dart';
import '../model/studentService/student_course_data.dart';

class CheckDateExamProvider extends ChangeNotifier {
  final ApiCheckExamService _apiService = getIt<ApiCheckExamService>();

  List<CheckAppello> _allAppelliStudent = [];
  List<CheckAppello> get allAppelliStudent => _allAppelliStudent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Carica tutti gli appelli disponibili per lo studente
  ///
  /// Questo metodo sostituisce il controller eliminando il layer ridondante
  Future<Result<List<CheckAppello>>> fetchAllAppelliStudent({
    required String userId,
    required String password,
    required int cdsId,
    required List<CourseInfo> courseList,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppelliStudent(
        userId: userId,
        password: password,
        cdsId: cdsId,
        courseList: courseList,
      );

      if (result.isSuccess) {
        setAllAppelliStudent(result.data!);
        _isLoading = false;
        notifyListeners();
        return Result.success(result.data!);
      } else {
        _errorMessage = result.errorMessage;
        _isLoading = false;
        notifyListeners();
        return Result.failure(result.errorMessage!);
      }
    } catch (e) {
      AppLogger.error('Errore in fetchAllAppelliStudent', e);
      _errorMessage = 'Errore imprevisto: $e';
      _isLoading = false;
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  /// Prenota un appello d'esame
  ///
  /// Passa tutti i dati necessari dal dettaglioTratto per calcolare l'anno di sessione
  Future<Result<bool>> bookExamAppello({
    required String userId,
    required String password,
    required int cdsId,
    required int adId,
    required int appId,
    required Map<String, dynamic>
        dettaglioTratto, // Dati completi della carriera
    required List<CourseInfo> courseList,
  }) async {
    try {
      AppLogger.info('🔵 PROVIDER: bookExamAppello chiamato');
      AppLogger.info('   - userId: $userId');
      AppLogger.info('   - cdsId: $cdsId');
      AppLogger.info('   - adId: $adId');
      AppLogger.info('   - appId: $appId');
      AppLogger.info('   - courseList length: ${courseList.length}');
      AppLogger.info('   - dettaglioTratto keys: ${dettaglioTratto.keys}');

      // Trova il corso corrispondente all'adId per ottenere l'adsceId
      final course = courseList.firstWhere(
        (c) => c.adId == adId,
        orElse: () => throw Exception(
            'Corso con adId=$adId non trovato nella lista corsi'),
      );

      AppLogger.info('🎓 Corso trovato:');
      AppLogger.info('   - Nome: ${course.nome}');
      AppLogger.info('   - adId: ${course.adId}');
      AppLogger.info('   - adsceId: ${course.adsceId}');

      final result = await _apiService.bookExamAppello(
        userId: userId,
        password: password,
        cdsId: cdsId,
        adId: adId,
        appId: appId,
        adsceId: course.adsceId,
        dettaglioTratto: dettaglioTratto,
        notaStu: "",
      );

      AppLogger.info('🔵 PROVIDER: Risultato ricevuto dal service');
      AppLogger.info('   - isSuccess: ${result.isSuccess}');
      AppLogger.info('   - errorMessage: ${result.errorMessage}');

      if (result.isSuccess) {
        // Ricarica gli appelli dopo la prenotazione riuscita
        AppLogger.info('Prenotazione riuscita, ricarico gli appelli...');
        await fetchAllAppelliStudent(
          userId: userId,
          password: password,
          cdsId: cdsId,
          courseList: courseList,
        );
      }

      return result;
    } catch (e) {
      AppLogger.error('Errore in bookExamAppello', e);
      return Result.failure('Errore imprevisto: $e');
    }
  }

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
