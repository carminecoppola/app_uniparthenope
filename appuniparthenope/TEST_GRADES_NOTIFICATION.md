# 🧪 Testing delle Notifiche per Nuovi Voti

## Come Funziona

L'app rileva automaticamente i **nuovi voti** comparando i voti del server con quelli salvati localmente. Quando rileva un nuovo voto, invia una **notifica di sistema** (che appare nel Centro Notifiche).

### Flusso Automatico
```
1. App si apre
   ↓
2. Carica i voti dal server (StudentUtils.allExamStudent)
   ↓
3. Confronta con i voti salvati localmente
   ↓
4. Se ci sono NUOVI voti → invia notifiche di sistema
   ↓
5. Salva i voti attuali per il prossimo controllo
```

## Testare Senza Aspettare un Nuovo Voto dal Professore

### Opzione 1: Usa lo Script di Test (Consigliato)

1. Apri il terminale Flutter dove è lanciata l'app
2. Premi `c` per aprire la console Dart
3. Esegui questi comandi:

```dart
// Importa l'helper di test
import 'package:appuniparthenope/service/test_grades_helper.dart';

// Mostra i voti salvati localmente
await TestGradesHelper.printLocalGrades();

// Aggiungi un fake voto
await TestGradesHelper.addFakeGradeForTesting();

// Ricomincia da zero se vuoi ricominciare il test
// await TestGradesHelper.resetLocalGrades();
```

4. Riavvia l'app:
   - Premi `R` nel terminale Flutter per riavviare hot restart
   - OPPURE chiudi e riapri l'app

5. **Dovresti vedere una notifica di sistema** nel Centro Notifiche con il testo:
   ```
   📚 Nuovo voto inserito - TEST: Algoritmi e Strutture Dati: 27/30
   ```

### Opzione 2: Testare con Voti Reali

1. **Primo avvio**: L'app carica i voti dal server e li salva localmente
2. **Attendi**: Aspetta che un professore reale aggiunga un nuovo voto
3. **Secondo avvio**: L'app rileva il nuovo voto e invia la notifica

## Cosa Controllare

✅ **Notifica Ricevuta**: Appare un'icona di notifica nella status bar (top dello schermo)

✅ **Testo della Notifica**: Deve essere nel formato:
   ```
   📚 Nuovo voto inserito - [Nome Corso]: [Voto]/30
   ```

✅ **Centro Notifiche**: Swipa dal top dello schermo per aprire il Centro Notifiche
   - Dovresti vedere la notifica persistente (non scompare quando chiudi l'app)

✅ **Suono/Vibrazione**: Se configurato → dovresti sentire/sentire la vibrazione

## Troubleshooting

### Non Vedo Nessuna Notifica
1. ✓ Prima apri Impostazioni → Notifiche → [App Name] e abilita le notifiche
2. ✓ Assicurati che le notifiche non siano silenziate sul dispositivo
3. ✓ Controlla la console Flutter per messaggi di errore
4. ✓ Assicurati che il permesso sia stato concesso (l'app chiede al primo avvio)

### La Notifica Appare Ma il Testo è Sbagliato
- Controlla che il corso abbia `nome` e il voto abbia `status.voto` nel modello `ExamData`
- Vedi il file `/lib/model/exam_data.dart` per i campi disponibili

### Voglio Ricominciare da Zero
```dart
await TestGradesHelper.resetLocalGrades();
```
Poi riavvia l'app e vedrai i voti caricati di nuovo dal server.

## File Importanti

- `lib/service/notification_service.dart` - Gestisce le notifiche
- `lib/service/local_grades_service.dart` - Salva/carica voti localmente
- `lib/provider/exam_provider.dart` - Logica di rilevamento nuovi voti
- `lib/service/test_grades_helper.dart` - Helper per testare senza aspettare

## Note

- Le notifiche vengono inviate **solo quando l'app si apre** (o quando ExamProvider carica i voti)
- I voti sono salvati in `SharedPreferences` con chiave `cached_student_grades`
- Il test fake aggiunge un voto che inizia con "TEST:" per identificarlo
