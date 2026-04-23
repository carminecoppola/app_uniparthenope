import 'dart:convert';
import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/core/result.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:http/http.dart' as http;

import '../model/studentService/check_appello_data.dart';

class ApiCheckExamService {
  final String baseUrl = "https://api.uniparthenope.it";

  /// Ottiene tutti gli appelli disponibili per gli esami dello studente
  ///
  /// Parametri senza BuildContext:
  /// - [userId]: ID utente per autenticazione
  /// - [password]: Password per autenticazione
  /// - [cdsId]: ID corso di studi
  /// - [courseList]: Lista dei corsi dello studente
  Future<Result<List<CheckAppello>>> getAppelliStudent({
    required String userId,
    required String password,
    required int cdsId,
    required List<CourseInfo> courseList,
  }) async {
    try {
      if (courseList.isEmpty) {
        return const Result.success([]);
      }

      List<CheckAppello> allAppelli = [];

      for (final course in courseList) {
        final adId = course.adId.toString();

        final url = Uri.parse(
            '$baseUrl/UniparthenopeApp/v1/students/checkAppello/$cdsId/$adId');

        final response = await http.get(url, headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("$userId:$password"))}',
        });

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          if (jsonData is List) {
            final appelli = jsonData.map<CheckAppello>((data) {
              final appello = CheckAppello.fromJson(data);
              // Aggiungi adId all'appello se non presente nella risposta
              appello.adId ??= course.adId;
              return appello;
            }).toList();
            allAppelli.addAll(appelli);
          } else if (jsonData != null) {
            final appello = CheckAppello.fromJson(jsonData);
            appello.adId ??= course.adId;
            allAppelli.add(appello);
          }
        } else {
          AppLogger.debug(
              'Appelli non disponibili per ${course.nome}: status ${response.statusCode}');
        }
      }

      return Result.success(allAppelli);
    } catch (e, stackTrace) {
      AppLogger.error('Errore in getAppelliStudent', e, stackTrace);
      return Result.failure('Errore durante il caricamento degli appelli: $e');
    }
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
