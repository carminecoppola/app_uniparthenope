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
  Map<int, int> _prenotabiliByAdId = const {};

  List<CheckAppello> _allAppelliStudent = [];
  List<CheckAppello> get allAppelliStudent => _allAppelliStudent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? _warningMessage;
  String? get warningMessage => _warningMessage;
  AppelliFetchSummary? _lastFetchSummary;
  AppelliFetchSummary? get lastFetchSummary => _lastFetchSummary;

  Map<String, List<CheckAppello>> get groupedAppelliByExam {
    final Map<String, List<CheckAppello>> grouped = {};

    for (final appello in _allAppelliStudent) {
      final examName = (appello.esame ?? 'Esame').trim();
      grouped.putIfAbsent(examName, () => []).add(appello);
    }

    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Map<String, List<CheckAppello>>.fromEntries(sortedEntries);
  }

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
    _warningMessage = null;
    _lastFetchSummary = null;
    _prenotabiliByAdId = {
      for (final c in courseList) c.adId: c.numAppelliPrenotabili,
    };
    notifyListeners();

    try {
      final result = await _apiService.getAppelliStudent(
        userId: userId,
        password: password,
        cdsId: cdsId,
        courseList: courseList,
      );

      if (result.isSuccess) {
        final response = result.data!;
        _lastFetchSummary = response.summary;
        if (response.summary.error500Courses > 0) {
          _warningMessage =
              'Alcuni insegnamenti non sono verificabili ora, riprova più tardi.';
        }
        setAllAppelliStudent(response.appelli);
        _isLoading = false;
        notifyListeners();
        return Result.success(response.appelli);
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

  /// Cancella una prenotazione a un appello d'esame.
  Future<Result<bool>> cancelExamReservation({
    required String userId,
    required String password,
    required int cdsId,
    required int adId,
    required int appId,
    required int stuId,
    required Map<String, dynamic> dettaglioTratto,
    required List<CourseInfo> courseList,
  }) async {
    try {
      final course = courseList.firstWhere(
        (c) => c.adId == adId,
        orElse: () => throw Exception(
            'Corso con adId=$adId non trovato nella lista corsi'),
      );

      final result = await _apiService.cancelExamReservation(
        userId: userId,
        password: password,
        cdsId: cdsId,
        adId: adId,
        appId: appId,
        stuId: stuId,
        adsceId: course.adsceId,
        dettaglioTratto: dettaglioTratto,
      );

      return result;
    } catch (e) {
      AppLogger.error('Errore in cancelExamReservation', e);
      return Result.failure('Errore imprevisto: $e');
    }
  }

  void setAllAppelliStudent(List<CheckAppello> appelli) {
    _allAppelliStudent = appelli;
    _sortAppelliByDate();
    _filterFutureBookableAppelli();
    _filterOnlyPrenotabiliByState();
    _updateSummaryWithStateFiltering();
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

  void clearAppelli() {
    _allAppelliStudent = [];
    _errorMessage = null;
    _warningMessage = null;
    _lastFetchSummary = null;
    _isLoading = false;
    notifyListeners();
  }

  void _filterFutureBookableAppelli() {
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
  }

  void _filterOnlyPrenotabiliByState() {
    final before = _allAppelliStudent.length;
    final strictPrenotabili = _allAppelliStudent.where((appello) {
      return _isPrenotabile(appello);
    }).toList();

    if (strictPrenotabili.isNotEmpty) {
      _allAppelliStudent = strictPrenotabili;
      final removed = before - _allAppelliStudent.length;
      if (removed > 0) {
        AppLogger.info(
            'Filtro prenotabilità applicato (strict): scartatiPerStato=$removed, rimasti=${_allAppelliStudent.length}');
      }
      return;
    }

    // Fallback adattivo:
    // alcuni account Esse3 restituiscono solo stati non "P" anche per appelli
    // operativi. In questo caso evitiamo lista vuota usando solo appelli futuri
    // con stato "attivo" lato sessione (es. I/P).
    final fallback = _allAppelliStudent.where(_isLikelyBookableFallback).toList();
    if (fallback.isNotEmpty) {
      _allAppelliStudent = fallback;
      _warningMessage ??=
          'Dati appelli parzialmente incoerenti con Esse3: mostrata modalità compatibilità.';
      AppLogger.info(
          'Filtro prenotabilità fallback applicato: strict=0, fallback=${_allAppelliStudent.length}, original=$before');
      return;
    }

    // Niente bypass finale: meglio lista vuota che risultati potenzialmente falsi.
    _allAppelliStudent = const [];
    AppLogger.info(
        'Filtro prenotabilità applicato: strict=0 fallback=0 original=$before, rimasti=0');
  }

  bool _isPrenotabile(CheckAppello appello) {
    final stato = (appello.stato ?? '').trim().toUpperCase();
    if (stato == 'P') return true;

    final statoDes = (appello.statoDes ?? '').trim().toLowerCase();
    // Il backend non sempre valorizza `stato` con "P":
    // usiamo `statoDes` come fallback per allinearci a Esse3.
    if (statoDes.contains('prenot')) return true;
    if (statoDes.contains('iscrizion') && statoDes.contains('apert')) {
      return true;
    }

    return false;
  }

  bool _isLikelyBookableFallback(CheckAppello appello) {
    final adId = appello.adId;
    if (adId == null) return false;
    final prenotabili = _prenotabiliByAdId[adId] ?? 0;
    if (prenotabili <= 0) return false;

    final stato = (appello.stato ?? '').trim().toUpperCase();
    if (stato.isEmpty) return false;
    if (stato == 'C') return false;

    // In contesti Esse3 reali, "I" è spesso usato per appelli futuri gestibili.
    const activeStates = {'I', 'P'};
    if (!activeStates.contains(stato)) return false;

    return _isFutureOrTodayAppello(appello);
  }

  bool _isFutureOrTodayAppello(CheckAppello appello) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dataStr = (appello.dataFine ?? appello.dataEsame ?? '').trim();
    if (dataStr.isEmpty) return false;

    DateTime? parsed;
    try {
      parsed = DateTime.tryParse(dataStr);
      parsed ??= DateFormat('dd/MM/yyyy').parseStrict(dataStr);
    } catch (_) {
      parsed = null;
    }
    if (parsed == null) return false;
    final normalized = DateTime(parsed.year, parsed.month, parsed.day);
    return !normalized.isBefore(today);
  }

  void _updateSummaryWithStateFiltering() {
    final summary = _lastFetchSummary;
    if (summary == null) return;
    final discardedForState =
        summary.totalReceivedWithStatoNonP + summary.discardedForNonPrenotabileState;
    _lastFetchSummary = AppelliFetchSummary(
      totalCourses: summary.totalCourses,
      successCourses: summary.successCourses,
      noAppelliCourses: summary.noAppelliCourses,
      error500Courses: summary.error500Courses,
      errorOtherCourses: summary.errorOtherCourses,
      totalAppelliShown: _allAppelliStudent.length,
      totalReceivedWithStatoP: summary.totalReceivedWithStatoP,
      totalReceivedWithStatoNonP: summary.totalReceivedWithStatoNonP,
      discardedForNonPrenotabileState: discardedForState,
      failed500CourseNames: summary.failed500CourseNames,
      diagnostics: summary.diagnostics,
    );
  }
}
