import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/studentService/exam_data.dart';

class LocalGradesService {
  static const String _gradesKey = 'cached_student_grades';
  static const String _lastUpdateKey = 'last_grades_update';
  String _scopedKey(String baseKey, {String? cacheScope}) {
    final scope = (cacheScope == null || cacheScope.trim().isEmpty)
        ? 'default'
        : cacheScope.trim();
    return '${baseKey}_$scope';
  }

  /// Salva i voti in local storage
  Future<void> saveGrades(
    List<ExamData> grades, {
    String? cacheScope,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradesKey = _scopedKey(_gradesKey, cacheScope: cacheScope);
      final lastUpdateKey = _scopedKey(_lastUpdateKey, cacheScope: cacheScope);

      // Converti i voti in JSON per il salvataggio locale
      final gradesList = grades.map((g) {
        return {
          'nome': g.nome,
          'codice': g.codice,
          'voto': g.status.voto,
          'data': g.status.data,
          'esito': g.status.esito,
        };
      }).toList();

      await prefs.setString(gradesKey, jsonEncode(gradesList));
      await prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
    } catch (_) {
      return;
    }
  }

  /// Carica i voti salvati localmente
  Future<List<Map<String, dynamic>>> getLocalGrades({
    String? cacheScope,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradesJson =
          prefs.getString(_scopedKey(_gradesKey, cacheScope: cacheScope));

      if (gradesJson == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(gradesJson);
      final result = List<Map<String, dynamic>>.from(
          decoded.map((item) => Map<String, dynamic>.from(item as Map)));

      return result;
    } catch (e) {
      return [];
    }
  }

  /// Confronta i voti server con quelli locali
  /// Ritorna una lista dei voti NUOVI
  Future<List<ExamData>> checkForNewGrades(
    List<ExamData> serverGrades, {
    String? cacheScope,
  }) async {
    try {
      final localGrades = await getLocalGrades(cacheScope: cacheScope);

      // Filtra solo i voti che are nel server ma NON nel local storage
      final newGrades = serverGrades.where((serverGrade) {
        return !localGrades.any((localGrade) =>
            localGrade['nome'] == serverGrade.nome &&
            localGrade['voto'] == serverGrade.status.voto &&
            localGrade['data'] == serverGrade.status.data);
      }).toList();

      return newGrades;
    } catch (e) {
      return [];
    }
  }

  Future<bool> hasCachedGrades({String? cacheScope}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(
        _scopedKey(_gradesKey, cacheScope: cacheScope),
      );
    } catch (_) {
      return false;
    }
  }

  /// Pulisci i voti salvati (per testing)
  Future<void> clearLocalGrades({String? cacheScope}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scopedKey(_gradesKey, cacheScope: cacheScope));
      await prefs.remove(_scopedKey(_lastUpdateKey, cacheScope: cacheScope));
    } catch (_) {
      return;
    }
  }

  Future<void> clearAllScopedGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keysToRemove = prefs.getKeys().where((key) {
        return key.startsWith('${_gradesKey}_') ||
            key.startsWith('${_lastUpdateKey}_');
      });

      for (final key in keysToRemove) {
        await prefs.remove(key);
      }
    } catch (_) {
      return;
    }
  }
}
