import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/studentService/exam_data.dart';

class LocalGradesService {
  static const String _gradesKey = 'cached_student_grades';
  static const String _lastUpdateKey = 'last_grades_update';

  /// Salva i voti in local storage
  Future<void> saveGrades(List<ExamData> grades) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
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
      
      await prefs.setString(_gradesKey, jsonEncode(gradesList));
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      
      print('💾 Voti salvati localmente: ${grades.length} voti');
    } catch (e) {
      print('Errore nel salvataggio voti locali: $e');
    }
  }

  /// Carica i voti salvati localmente
  Future<List<Map<String, dynamic>>> getLocalGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradesJson = prefs.getString(_gradesKey);
      
      if (gradesJson == null) {
        print('📂 Nessun voto salvato localmente');
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(gradesJson);
      final result = List<Map<String, dynamic>>.from(
        decoded.map((item) => Map<String, dynamic>.from(item as Map))
      );
      
      print('📂 Voti caricati localmente: ${result.length} voti');
      return result;
    } catch (e) {
      print('Errore nel caricamento voti locali: $e');
      return [];
    }
  }

  /// Confronta i voti server con quelli locali
  /// Ritorna una lista dei voti NUOVI
  Future<List<ExamData>> checkForNewGrades(List<ExamData> serverGrades) async {
    try {
      final localGrades = await getLocalGrades();
      
      print('🔍 Confronto:');
      print('   Server: ${serverGrades.length} voti');
      print('   Local: ${localGrades.length} voti');
      
      // Filtra solo i voti che are nel server ma NON nel local storage
      final newGrades = serverGrades.where((serverGrade) {
        return !localGrades.any((localGrade) =>
          localGrade['nome'] == serverGrade.nome &&
          localGrade['voto'] == serverGrade.status.voto &&
          localGrade['data'] == serverGrade.status.data
        );
      }).toList();
      
      if (newGrades.isNotEmpty) {
        print('✅ Nuovi voti rilevati: ${newGrades.length}');
        for (var g in newGrades) {
          print('   - ${g.nome}: ${g.status.voto}');
        }
      } else {
        print('ℹ️ Nessun nuovo voto');
      }
      
      return newGrades;
    } catch (e) {
      print('Errore nel confronto voti: $e');
      return [];
    }
  }

  /// Pulisci i voti salvati (per testing)
  Future<void> clearLocalGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_gradesKey);
      await prefs.remove(_lastUpdateKey);
      print('🗑️ Voti locali eliminati');
    } catch (e) {
      print('Errore nella pulizia: $e');
    }
  }
}
