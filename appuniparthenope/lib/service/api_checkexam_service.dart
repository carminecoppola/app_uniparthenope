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
          AppLogger.debug(
              '📄 JSON risposta completa per ${course.nome}: $jsonData');

          if (jsonData is List) {
            final appelli = jsonData.map<CheckAppello>((data) {
              AppLogger.debug('  📋 Singolo appello JSON: $data');
              final appello = CheckAppello.fromJson(data);
              // Aggiungi adId all'appello se non presente nella risposta
              appello.adId ??= course.adId;
              return appello;
            }).toList();
            allAppelli.addAll(appelli);
          } else if (jsonData != null) {
            AppLogger.debug('  📋 Singolo appello JSON: $jsonData');
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
      AppLogger.info('📝 INIZIO PRENOTAZIONE ESAME');
      AppLogger.info('📌 Parametri ricevuti:');
      AppLogger.info('   - userId: $userId');
      AppLogger.info(
          '   - password: ${password.replaceAll(RegExp(r'.'), '*')}');
      AppLogger.info('   - cdsId: $cdsId');
      AppLogger.info('   - adId: $adId');
      AppLogger.info('   - appId: $appId');
      AppLogger.info('   - adsceId: $adsceId (BODY)');
      AppLogger.info('   - notaStu: "$notaStu" (BODY)');

      // URL CORRETTO dall'API documentation: /bookExam/{cdsId}/{adId}/{appId}
      // NON include matId nell'URL (solo nel body se necessario)

      final url = Uri.parse(
          '$baseUrl/UniparthenopeApp/v1/students/bookExam/$cdsId/$adId/$appId');

      print('\n' + '=' * 100);
      print('🚀 CHIAMATA API PRENOTAZIONE ESAME');
      print('=' * 100);
      print('📍 URL COMPLETO: $url');
      print('');
      print('📋 PARAMETRI URL:');
      print('   cdsId  = $cdsId');
      print('   adId   = $adId');
      print('   appId  = $appId');
      print('');
      print('📦 BODY JSON (quello che inviamo):');

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
      print('   $bodyContent');
      print('');
      print('🔍 Aggiunti campi da dettaglioTratto per calcolare anno sessione');
      print('');
      print('🔐 HEADERS:');
      print('   Authorization: Basic [NASCOSTO]');
      print('   Content-Type: application/json');
      print('   Accept: application/json');
      print('');
      print('💡 ESEMPIO PER CLOUD COMPUTING:');
      print('   URL dovrebbe essere: .../bookExam/10104/6922/49');
      print('   Body dovrebbe essere: {"adsceId":5811981,"notaEst":""}');
      print('=' * 100 + '\n');

      AppLogger.info('🌐 URL completo: $url');

      final authHeader =
          'Basic ${base64Encode(utf8.encode("$userId:$password"))}';
      AppLogger.info(
          '🔐 Authorization header (Base64): ${authHeader.substring(0, 20)}...');
      AppLogger.info('📦 Body JSON (base): $bodyContent');

      // Se fallisce, proveremo ad aggiungere annoId

      final headers = {
        'Authorization': authHeader,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      AppLogger.info('📋 Headers completi:');
      headers.forEach((key, value) {
        if (key == 'Authorization') {
          AppLogger.info('   - $key: ${value.substring(0, 20)}...');
        } else {
          AppLogger.info('   - $key: $value');
        }
      });

      AppLogger.info('🚀 Invio richiesta POST...');

      final response = await http.post(
        url,
        headers: headers,
        body: bodyContent,
      );

      AppLogger.info('📨 Risposta ricevuta:');
      AppLogger.info('   - Status Code: ${response.statusCode}');
      AppLogger.info('   - Headers: ${response.headers}');
      AppLogger.info('   - Body: ${response.body}');
      AppLogger.info('   - Lunghezza body: ${response.body.length} caratteri');

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('✅ Prenotazione effettuata con successo!');
        return const Result.success(true);
      } else {
        AppLogger.error(
            '❌ Errore POST prenotazione: status ${response.statusCode}, body: ${response.body}');

        // Prova a estrarre il messaggio di errore dal body
        String errorMessage =
            'Errore server durante la prenotazione (${response.statusCode})';
        try {
          final jsonResponse = jsonDecode(response.body);
          AppLogger.info('🔍 JSON decodificato: $jsonResponse');
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
}
