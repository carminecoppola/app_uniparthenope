import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/studentService/exam_data.dart';
import '../provider/exam_provider.dart';
import '../core/service_locator.dart';

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

      print('📊 Voti attuali salvati: ${gradesList.length}');

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

      print(
          '✅ Fake voto aggiunto: ${fakeGrade['nome']} - ${fakeGrade['voto']}/30');
      print('📊 Nuovi voti salvati: ${gradesList.length}');
      print('\n🔔 Istruzioni per testare:');
      print('   1. Riavvia l\'app (premi R nel terminale)');
      print('   2. L\'app caricherà i voti dal server');
      print('   3. Vedrà il nuovo voto e invierà una NOTIFICA DI SISTEMA');
      print('   4. Guarda il Centro Notifiche (swipe dal top dello schermo)\n');
    } catch (e) {
      print('Errore nell\'aggiunta del fake voto: $e');
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

      print('📊 Voti attuali salvati: ${gradesList.length}');

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

      print(
          '✅ Voto realistico aggiunto: ${realisticGrade['nome']} - ${realisticGrade['voto']}/30');
      print('📊 Nuovi voti salvati: ${gradesList.length}');
      print('\n🔔 Istruzioni per testare:');
      print('   1. Riavvia l\'app (premi R nel terminale)');
      print('   2. L\'app caricherà i voti dal server');
      print('   3. Vedrà il nuovo voto e invierà una NOTIFICA DI SISTEMA');
      print('   4. Guarda il Centro Notifiche (swipe dal top dello schermo)\n');
    } catch (e) {
      print('Errore nell\'aggiunta del voto realistico: $e');
    }
  }

  /// Reimposta i voti salvati localmente (per ricominciare il test)
  static Future<void> resetLocalGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_student_grades');
      await prefs.remove('last_grades_update');
      print('🗑️ Voti locali ripristinati - ricomincan da capo');
    } catch (e) {
      print('Errore nel reset: $e');
    }
  }

  /// Mostra i voti salvati localmente (per debug)
  static Future<void> printLocalGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradesJson = prefs.getString('cached_student_grades');

      if (gradesJson == null) {
        print('📂 Nessun voto salvato localmente');
        return;
      }

      final List<dynamic> gradesList = jsonDecode(gradesJson);
      print('\n📂 Voti salvati localmente (${gradesList.length}):');
      for (var grade in gradesList) {
        print('   - ${grade['nome']}: ${grade['voto']}/30 (${grade['data']})');
      }
      print('');
    } catch (e) {
      print('Errore: $e');
    }
  }
}
