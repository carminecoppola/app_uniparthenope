import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 🧪 UTILITY PER TESTARE LE NOTIFICHE
/// Usa questa per simulare un nuovo voto senza aspettare il professore
class TestGradesHelper {
  /// Aggiungi un fake voto ai voti salvati localmente
  /// Poi riavvia l'app e vedrai la notifica
  static Future<void> addFakeGradeForTesting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const String gradesKey = 'cached_student_grades';

      // Carica i voti attuali salvati
      final gradesJson = prefs.getString(gradesKey);
      final List<dynamic> gradesList =
          gradesJson != null ? jsonDecode(gradesJson) : [];

      // Aggiungi un fake voto alla lista
      final fakeGrade = {
        'nome': 'TEST: Algoritmi e Strutture Dati',
        'codice': 'TEST-ASD-001',
        'voto': 27,
        'data': DateTime.now().toString().split(' ')[0],
        'esito': 'Superato',
      };

      gradesList.add(fakeGrade);

      // Salva la lista aggiornata
      await prefs.setString(gradesKey, jsonEncode(gradesList));
    } catch (_) {
      return;
    }
  }

  /// Aggiungi un voto REALISTA (indistinguibile da uno vero) ai voti salvati
  /// Poi riavvia l'app e vedrai la notifica come se fosse un voto vero
  static Future<void> addRealisticGradeForTesting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const String gradesKey = 'cached_student_grades';

      // Carica i voti attuali salvati
      final gradesJson = prefs.getString(gradesKey);
      final List<dynamic> gradesList =
          gradesJson != null ? jsonDecode(gradesJson) : [];

      // Aggiungi un voto REALISTA (senza "TEST:") - come se venisse dal server
      final realisticGrade = {
        'nome': 'Algoritmi e Strutture Dati', // Senza prefisso "TEST:"
        'codice': 'INF001',
        'voto': 27,
        'data': DateTime.now().toString().split(' ')[0],
        'esito': 'Superato',
      };

      gradesList.add(realisticGrade);

      // Salva la lista aggiornata
      await prefs.setString(gradesKey, jsonEncode(gradesList));
    } catch (_) {
      return;
    }
  }

  /// Reimposta i voti salvati localmente (per ricominciare il test)
  static Future<void> resetLocalGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_student_grades');
      await prefs.remove('last_grades_update');
    } catch (_) {
      return;
    }
  }

  /// Mostra i voti salvati localmente (per debug)
  static Future<void> printLocalGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradesJson = prefs.getString('cached_student_grades');

      if (gradesJson == null) {
        return;
      }

      jsonDecode(gradesJson);
    } catch (_) {
      return;
    }
  }
}
