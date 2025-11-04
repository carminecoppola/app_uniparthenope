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
      AppLogger.info(
          'getAppelliStudent: cdsId=$cdsId, corsi=${courseList.length}');

      if (courseList.isEmpty) {
        return const Result.success([]);
      }

      List<CheckAppello> allAppelli = [];

      for (final course in courseList) {
        final adId = course.adId.toString();
        AppLogger.debug('Controllo appelli per: ${course.nome} (adId=$adId)');

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
          AppLogger.warning(
              'Errore API per ${course.nome}: status ${response.statusCode}');
        }
      }

      AppLogger.info('Trovati ${allAppelli.length} appelli totali');
      return Result.success(allAppelli);
    } catch (e, stackTrace) {
      AppLogger.error('Errore in getAppelliStudent', e, stackTrace);
      return Result.failure('Errore durante il caricamento degli appelli: $e');
    }
  }

  /// Prenota un appello d'esame
  ///
  /// Ritorna Result<bool> invece di bool per gestione errori migliore
  Future<Result<bool>> bookExamAppello({
    required String userId,
    required String password,
    required int cdsId,
    required int adId,
    required int appId,
  }) async {
    try {
      AppLogger.info('bookExamAppello: cdsId=$cdsId, adId=$adId, appId=$appId');

      final url = Uri.parse(
          '$baseUrl/UniparthenopeApp/v1/students/bookExam/$cdsId/$adId/$appId');

      final response = await http.post(url, headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("$userId:$password"))}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        AppLogger.info('Prenotazione effettuata con successo');
        return const Result.success(true);
      } else {
        AppLogger.error(
            'Errore POST prenotazione: status ${response.statusCode}, body: ${response.body}');
        return Result.failure(
            'Errore server durante la prenotazione (${response.statusCode})');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Errore in bookExamAppello', e, stackTrace);
      return Result.failure('Errore di rete durante la prenotazione: $e');
    }
  }
}
