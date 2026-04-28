import 'dart:convert';
import 'dart:math' as math;
import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/core/result.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:http/http.dart' as http;

import '../model/studentService/check_appello_data.dart';

enum CourseAppelliFetchStatus {
  success,
  noAppelli,
  error500,
  errorOther,
}

class CourseAppelliFetchDiagnostic {
  const CourseAppelliFetchDiagnostic({
    required this.courseName,
    required this.adId,
    required this.adsceId,
    required this.cdsId,
    required this.status,
    required this.statusCode,
    required this.attempts,
    required this.durationMs,
    required this.acceptedCount,
    required this.discardedCount,
  });

  final String courseName;
  final int adId;
  final int adsceId;
  final int cdsId;
  final CourseAppelliFetchStatus status;
  final int statusCode;
  final int attempts;
  final int durationMs;
  final int acceptedCount;
  final int discardedCount;
}

class AppelliFetchSummary {
  const AppelliFetchSummary({
    required this.totalCourses,
    required this.successCourses,
    required this.noAppelliCourses,
    required this.error500Courses,
    required this.errorOtherCourses,
    required this.totalAppelliShown,
    required this.totalReceivedWithStatoP,
    required this.totalReceivedWithStatoNonP,
    required this.discardedForNonPrenotabileState,
    required this.failed500CourseNames,
    required this.diagnostics,
  });

  final int totalCourses;
  final int successCourses;
  final int noAppelliCourses;
  final int error500Courses;
  final int errorOtherCourses;
  final int totalAppelliShown;
  final int totalReceivedWithStatoP;
  final int totalReceivedWithStatoNonP;
  final int discardedForNonPrenotabileState;
  final List<String> failed500CourseNames;
  final List<CourseAppelliFetchDiagnostic> diagnostics;
}

class AppelliFetchResponse {
  const AppelliFetchResponse({
    required this.appelli,
    required this.summary,
  });

  final List<CheckAppello> appelli;
  final AppelliFetchSummary summary;
}

class _CourseFetchAttemptData {
  const _CourseFetchAttemptData({
    required this.identifier,
    required this.status,
    required this.statusCode,
    required this.attempts,
    required this.acceptedCount,
    required this.discardedCount,
    required this.appelli,
  });

  final int identifier;
  final CourseAppelliFetchStatus status;
  final int statusCode;
  final int attempts;
  final int acceptedCount;
  final int discardedCount;
  final List<CheckAppello> appelli;
}

class ApiCheckExamService {
  final String baseUrl = "https://api.uniparthenope.it";
  static const int _max500Attempts = 3;
  static const Duration _retryDelay = Duration(milliseconds: 350);

  /// Ottiene tutti gli appelli disponibili per gli esami dello studente
  ///
  /// Parametri senza BuildContext:
  /// - [userId]: ID utente per autenticazione
  /// - [password]: Password per autenticazione
  /// - [cdsId]: ID corso di studi
  /// - [courseList]: Lista dei corsi dello studente
  Future<Result<AppelliFetchResponse>> getAppelliStudent({
    required String userId,
    required String password,
    required int cdsId,
    required List<CourseInfo> courseList,
  }) async {
    try {
      if (courseList.isEmpty) {
        return const Result.success(
          AppelliFetchResponse(
            appelli: [],
            summary: AppelliFetchSummary(
              totalCourses: 0,
              successCourses: 0,
              noAppelliCourses: 0,
              error500Courses: 0,
              errorOtherCourses: 0,
              totalAppelliShown: 0,
              totalReceivedWithStatoP: 0,
              totalReceivedWithStatoNonP: 0,
              discardedForNonPrenotabileState: 0,
              failed500CourseNames: [],
              diagnostics: [],
            ),
          ),
        );
      }

      final authHeader =
          'Basic ${base64Encode(utf8.encode("$userId:$password"))}';
      final List<CheckAppello> allAppelli = [];
      final List<CourseAppelliFetchDiagnostic> diagnostics = [];
      final List<String> failed500CourseNames = [];
      int successCourses = 0;
      int noAppelliCourses = 0;
      int error500Courses = 0;
      int errorOtherCourses = 0;
      int totalReceivedWithStatoP = 0;
      int totalReceivedWithStatoNonP = 0;

      for (final course in courseList) {
        final stopwatch = Stopwatch()..start();
        int attempts = 0;
        int finalStatusCode = 0;
        int acceptedCount = 0;
        int discardedCount = 0;
        CourseAppelliFetchStatus finalStatus = CourseAppelliFetchStatus.errorOther;

        AppLogger.debug(
            '🔎 Fetch appelli corso="${course.nome}" adId=${course.adId} adsceId=${course.adsceId} cdsId=$cdsId');

        final idsToTry = <int>{course.adId};
        if (course.adsceId > 0) {
          idsToTry.add(course.adsceId);
        }

        final attemptsById = <_CourseFetchAttemptData>[];
        for (final idToTry in idsToTry) {
          final attempt = await _fetchCourseByIdentifier(
            authHeader: authHeader,
            cdsId: cdsId,
            identifier: idToTry,
            expectedCourse: course,
          );
          attemptsById.add(attempt);
        }

        final chosen = _selectBestAttempt(attemptsById);
        if (chosen != null) {
          attempts = attemptsById.fold<int>(0, (sum, a) => sum + a.attempts);
          finalStatusCode = chosen.statusCode;
          acceptedCount = chosen.acceptedCount;
          discardedCount = chosen.discardedCount;
          finalStatus = chosen.status;

          if (chosen.status == CourseAppelliFetchStatus.success) {
            for (final appello in chosen.appelli) {
              if (_isPrenotabileState(appello.stato)) {
                totalReceivedWithStatoP++;
              } else {
                totalReceivedWithStatoNonP++;
              }
            }
            if (chosen.appelli.isNotEmpty) {
              final preview = chosen.appelli
                  .take(3)
                  .map((a) =>
                      '[esame="${a.esame}", stato="${a.stato}", statoDes="${a.statoDes}", dataEsame="${a.dataEsame}", dataFine="${a.dataFine}"]')
                  .join(' ');
              AppLogger.debug(
                  'Dettaglio appelli corso="${course.nome}" adId=${course.adId} fonteId=${chosen.identifier}: $preview');
            }
            if (chosen.identifier != course.adId) {
              AppLogger.info(
                  'Selezionato risultato alternativo per corso="${course.nome}": fonteId=${chosen.identifier} al posto di adId=${course.adId}');
            }
            allAppelli.addAll(chosen.appelli);
            successCourses++;
          } else if (chosen.status == CourseAppelliFetchStatus.noAppelli) {
            noAppelliCourses++;
          } else if (chosen.status == CourseAppelliFetchStatus.error500) {
            error500Courses++;
            failed500CourseNames.add(course.nome);
          } else {
            errorOtherCourses++;
          }
        } else {
          errorOtherCourses++;
        }

        stopwatch.stop();
        diagnostics.add(
          CourseAppelliFetchDiagnostic(
            courseName: course.nome,
            adId: course.adId,
            adsceId: course.adsceId,
            cdsId: cdsId,
            status: finalStatus,
            statusCode: finalStatusCode,
            attempts: attempts,
            durationMs: stopwatch.elapsedMilliseconds,
            acceptedCount: acceptedCount,
            discardedCount: discardedCount,
          ),
        );

        AppLogger.debug(
            '📌 Esito corso="${course.nome}" adId=${course.adId}: status=$finalStatusCode attempts=$attempts accepted=$acceptedCount discarded=$discardedCount elapsedMs=${stopwatch.elapsedMilliseconds}');
      }

      AppLogger.info(
          '📊 Riepilogo fetch appelli: totCorsi=${courseList.length}, ok=$successCourses, noAppelli403=$noAppelliCourses, error500=$error500Courses, errorOther=$errorOtherCourses, ricevutiStatoP=$totalReceivedWithStatoP, ricevutiStatoNonP=$totalReceivedWithStatoNonP, appelliMostrati=${allAppelli.length}');

      return Result.success(
          AppelliFetchResponse(
          appelli: allAppelli,
          summary: AppelliFetchSummary(
            totalCourses: courseList.length,
            successCourses: successCourses,
            noAppelliCourses: noAppelliCourses,
            error500Courses: error500Courses,
            errorOtherCourses: errorOtherCourses,
            totalAppelliShown: allAppelli.length,
            totalReceivedWithStatoP: totalReceivedWithStatoP,
            totalReceivedWithStatoNonP: totalReceivedWithStatoNonP,
            discardedForNonPrenotabileState: 0,
            failed500CourseNames: failed500CourseNames,
            diagnostics: diagnostics,
          ),
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Errore in getAppelliStudent', e, stackTrace);
      return Result.failure('Errore durante il caricamento degli appelli: $e');
    }
  }

  CheckAppello? _validateAndNormalizeAppello({
    required CheckAppello appello,
    required CourseInfo expectedCourse,
  }) {
    final payloadAdId = appello.adId;
    if (payloadAdId != null && payloadAdId != expectedCourse.adId) {
      AppLogger.warning(
        'Scartato appello incoerente: corsoRichiestoAdId=${expectedCourse.adId}, corsoPayloadAdId=$payloadAdId, corso="${expectedCourse.nome}", esame="${appello.esame}"',
      );
      return null;
    }

    if ((appello.esame ?? '').trim().isEmpty) {
      AppLogger.debug(
          'Appello con esame vuoto per corso="${expectedCourse.nome}" adId=${expectedCourse.adId}');
      return null;
    }

    if (!_isExamNameCompatible(
      expectedCourseName: expectedCourse.nome,
      examNameFromPayload: appello.esame!,
    )) {
      AppLogger.warning(
        'Scartato appello per mismatch nome esame: corsoRichiesto="${expectedCourse.nome}", esamePayload="${appello.esame}", adIdRichiesto=${expectedCourse.adId}, adIdPayload=${appello.adId}',
      );
      return null;
    }

    appello.adId ??= expectedCourse.adId;
    return appello;
  }

  bool _isExamNameCompatible({
    required String expectedCourseName,
    required String examNameFromPayload,
  }) {
    final expected = _normalizeExamName(expectedCourseName);
    final payload = _normalizeExamName(examNameFromPayload);
    if (expected.isEmpty || payload.isEmpty) return false;

    if (expected == payload) return true;
    if (payload.contains(expected) || expected.contains(payload)) return true;

    final expectedTokens = expected
        .split(' ')
        .where((t) => t.isNotEmpty && t.length > 2)
        .toSet();
    final payloadTokens = payload
        .split(' ')
        .where((t) => t.isNotEmpty && t.length > 2)
        .toSet();
    if (expectedTokens.isEmpty || payloadTokens.isEmpty) return false;

    final overlap = expectedTokens.intersection(payloadTokens).length;
    final minLen = math.min(expectedTokens.length, payloadTokens.length);
    return overlap >= math.max(2, (minLen * 0.6).ceil());
  }

  String _normalizeExamName(String value) {
    final lower = value.toLowerCase();
    final noSpecial = lower
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return noSpecial;
  }

  bool _isPrenotabileState(String? stato) {
    return (stato ?? '').trim().toUpperCase() == 'P';
  }

  Future<_CourseFetchAttemptData> _fetchCourseByIdentifier({
    required String authHeader,
    required int cdsId,
    required int identifier,
    required CourseInfo expectedCourse,
  }) async {
    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/checkAppello/$cdsId/$identifier');
    int attempts = 0;
    int statusCode = 0;
    int discardedCount = 0;
    final appelli = <CheckAppello>[];
    CourseAppelliFetchStatus status = CourseAppelliFetchStatus.errorOther;

    while (attempts < _max500Attempts) {
      attempts++;
      final response = await http.get(url, headers: {
        'Authorization': authHeader,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          for (final item in jsonData) {
            if (item is! Map<String, dynamic>) continue;
            final parsed = CheckAppello.fromJson(item);
            final validated = _validateAndNormalizeAppello(
              appello: parsed,
              expectedCourse: expectedCourse,
            );
            if (validated != null) {
              appelli.add(validated);
            } else {
              discardedCount++;
            }
          }
        } else if (jsonData is Map<String, dynamic>) {
          final parsed = CheckAppello.fromJson(jsonData);
          final validated = _validateAndNormalizeAppello(
            appello: parsed,
            expectedCourse: expectedCourse,
          );
          if (validated != null) {
            appelli.add(validated);
          } else {
            discardedCount++;
          }
        }
        status = CourseAppelliFetchStatus.success;
        break;
      }

      if (response.statusCode == 403) {
        status = CourseAppelliFetchStatus.noAppelli;
        break;
      }

      if (response.statusCode == 500) {
        status = CourseAppelliFetchStatus.error500;
        if (attempts < _max500Attempts) {
          await Future.delayed(_retryDelay);
          continue;
        }
        break;
      }

      status = CourseAppelliFetchStatus.errorOther;
      break;
    }

    return _CourseFetchAttemptData(
      identifier: identifier,
      status: status,
      statusCode: statusCode,
      attempts: attempts,
      acceptedCount: appelli.length,
      discardedCount: discardedCount,
      appelli: appelli,
    );
  }

  _CourseFetchAttemptData? _selectBestAttempt(
    List<_CourseFetchAttemptData> attempts,
  ) {
    if (attempts.isEmpty) return null;
    final successAttempts = attempts
        .where((a) => a.status == CourseAppelliFetchStatus.success)
        .toList();
    if (successAttempts.isNotEmpty) {
      successAttempts.sort((a, b) => _scoreAttempt(b).compareTo(_scoreAttempt(a)));
      return successAttempts.first;
    }
    final noAppelli = attempts.firstWhere(
      (a) => a.status == CourseAppelliFetchStatus.noAppelli,
      orElse: () => attempts.first,
    );
    if (noAppelli.status == CourseAppelliFetchStatus.noAppelli) return noAppelli;
    final error500 = attempts.firstWhere(
      (a) => a.status == CourseAppelliFetchStatus.error500,
      orElse: () => attempts.first,
    );
    if (error500.status == CourseAppelliFetchStatus.error500) return error500;
    return attempts.first;
  }

  int _scoreAttempt(_CourseFetchAttemptData attempt) {
    final now = DateTime.now();
    int futureCount = 0;
    int latestFutureMillis = 0;
    for (final appello in attempt.appelli) {
      final date = _parseAppelloDate(appello.dataFine ?? appello.dataEsame);
      if (date == null) continue;
      if (!date.isBefore(DateTime(now.year, now.month, now.day))) {
        futureCount++;
        latestFutureMillis = math.max(latestFutureMillis, date.millisecondsSinceEpoch);
      }
    }
    return (futureCount * 1000000000) + latestFutureMillis + attempt.acceptedCount;
  }

  DateTime? _parseAppelloDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();
    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;
    try {
      final parts = value.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  /// Prenota un appello d'esame
  ///
  /// Ritorna Result<bool> invece di bool per gestione errori migliore
  ///
  /// Parametri richiesti dall'API:
  /// - adsceId: ID del corso da prenotare (obbligatorio nel body)
  /// - notaEst: Nota aggiuntiva (opzionale, può essere vuota)
  /// Prenota un appello d'esame
  ///
  /// L'API potrebbe richiedere campi aggiuntivi per calcolare l'anno di sessione
  Future<Result<bool>> bookExamAppello({
    required String userId,
    required String password,
    required int cdsId,
    required int adId,
    required int appId,
    required int adsceId,
    required Map<String, dynamic>
        dettaglioTratto, // Dati completi della carriera
    String notaStu = "",
  }) async {
    try {
      // URL CORRETTO dall'API documentation: /bookExam/{cdsId}/{adId}/{appId}
      // NON include matId nell'URL (solo nel body se necessario)

      final url = Uri.parse(
          '$baseUrl/UniparthenopeApp/v1/students/bookExam/$cdsId/$adId/$appId');

      // Proviamo ad aggiungere i campi necessari per calcolare l'anno di sessione
      final bodyData = {
        "adsceId": adsceId,
        "notaStu": notaStu,
        // Aggiungiamo i campi dal dettaglioTratto che potrebbero servire
        if (dettaglioTratto['aaIscrId'] != null)
          "aaIscrId": dettaglioTratto['aaIscrId'],
        if (dettaglioTratto['aaRegId'] != null)
          "aaRegId": dettaglioTratto['aaRegId'],
        if (dettaglioTratto['annoCorso'] != null)
          "annoCorso": dettaglioTratto['annoCorso'],
        if (dettaglioTratto['iscrId'] != null)
          "iscrId": dettaglioTratto['iscrId'],
        if (dettaglioTratto['stuId'] != null) "stuId": dettaglioTratto['stuId'],
        if (dettaglioTratto['matId'] != null) "matId": dettaglioTratto['matId'],
      };
      final bodyContent = jsonEncode(bodyData);

      final authHeader =
          'Basic ${base64Encode(utf8.encode("$userId:$password"))}';

      final headers = {
        'Authorization': authHeader,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: bodyContent,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Result.success(true);
      } else {
        AppLogger.error(
            '❌ Errore POST prenotazione: status ${response.statusCode}, body: ${response.body}');

        // Prova a estrarre il messaggio di errore dal body
        String errorMessage =
            'Errore server durante la prenotazione (${response.statusCode})';
        try {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse is Map && jsonResponse.containsKey('message')) {
            errorMessage = jsonResponse['message'];
          } else if (jsonResponse is Map &&
              jsonResponse.containsKey('errMsg')) {
            errorMessage = jsonResponse['errMsg'];
          }
        } catch (e) {
          AppLogger.warning(
              '⚠️ Impossibile decodificare il body della risposta: $e');
        }

        return Result.failure(errorMessage);
      }
    } catch (e, stackTrace) {
      AppLogger.error('💥 Errore CATCH in bookExamAppello', e, stackTrace);
      return Result.failure('Errore di rete durante la prenotazione: $e');
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
    required int adsceId,
    Map<String, dynamic>? dettaglioTratto,
    String notaStu = "",
  }) async {
    try {
      final headers = {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("$userId:$password"))}',
        'Accept': 'application/json',
      };

      final url = Uri.parse(
          '$baseUrl/UniparthenopeApp/v1/students/deleteExam/$cdsId/$adId/$appId/$stuId');

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return const Result.success(true);
      }

      if (_isBackendJsonDecodeError(response)) {
        AppLogger.warning(
            'Cancellazione completata, ma il backend ha fallito il parsing JSON della risposta upstream.');
        return const Result.success(true);
      }

      return Result.failure(_buildCancelReservationError(response));
    } catch (e, stackTrace) {
      AppLogger.error(
          '💥 Errore CATCH in cancelExamReservation', e, stackTrace);
      return Result.failure('Errore di rete durante la cancellazione: $e');
    }
  }

  bool _isBackendJsonDecodeError(http.Response response) {
    if (response.body.isEmpty) return false;

    try {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is Map) {
        final title = jsonResponse['errMsgTitle']?.toString() ?? '';
        final message = jsonResponse['errMsg']?.toString() ?? '';
        return _looksLikeBackendDeleteJsonDecodeError('$title\n$message');
      }
    } catch (_) {
      return _looksLikeBackendDeleteJsonDecodeError(response.body);
    }

    return false;
  }

  bool _looksLikeBackendDeleteJsonDecodeError(String text) {
    return text.contains('JSONDecodeError') &&
        text.contains('Expecting value') &&
        text.contains('students_v1.py') &&
        text.contains('delete');
  }

  String _buildCancelReservationError(http.Response response) {
    String? apiMessage;
    try {
      if (response.body.isNotEmpty) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('message')) {
          apiMessage = jsonResponse['message']?.toString();
        } else if (jsonResponse is Map && jsonResponse.containsKey('errMsg')) {
          apiMessage = jsonResponse['errMsg']?.toString();
        } else {
          apiMessage = response.body;
        }
      }
    } catch (_) {
      apiMessage = response.body;
    }

    final detail = apiMessage == null || apiMessage.trim().isEmpty
        ? 'nessun dettaglio dal server'
        : apiMessage.trim();

    return 'Cancellazione non riuscita (${response.statusCode}) - '
        'DELETE deleteExam: $detail';
  }
}
