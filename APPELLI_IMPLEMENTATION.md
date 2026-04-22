# 📋 Implementazione Sistema Appelli - Guida Completa

## 🎯 Obiettivo
Implementare completamente:
1. **Visualizzazione lista appelli disponibili**
2. **Prenotazione a un appello**

---

## 📊 Flusso Dati End-to-End

### Recupero Appelli
```
┌─────────────────────────────────────────────────────────────────┐
│ 1. AuthProvider → selectedCareer                                │
│    └─ stuId, matId, cdsId, dettaglioTratto                      │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. ApiStudentService.getPianoId(stuId)                         │
│    └─ Ritorna: pianoId                                          │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. ApiStudentService.getAllCourse(stuId, pianoId)              │
│    └─ Ritorna: List<CourseInfo> [nome, adId, adsceId, ...]    │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. ApiCheckExamService.getAppelliStudent()                     │
│    ├─ For each course in courseList:                           │
│    │  └─ GET /students/checkAppello/{cdsId}/{adId}            │
│    └─ Ritorna: List<CheckAppello>                              │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. CheckDateExamProvider.fetchAllAppelliStudent()              │
│    ├─ Chiama ApiCheckExamService.getAppelliStudent()           │
│    ├─ setAllAppelliStudent(lista)                              │
│    ├─ Ordina per data                                           │
│    └─ Filtra solo appelli prenotabili (data >= oggi)           │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 6. CheckAppello.dart / ListaAppelliPage                        │
│    └─ Visualizza lista appelli con possibilità di prenotazione │
└─────────────────────────────────────────────────────────────────┘
```

### Prenotazione Appello
```
┌─────────────────────────────────────────────────────────────────┐
│ 1. User clicks "Prenota" button → _handlePrenotazione()       │
│    ├─ Recupera user, password, selectedCareer, courseList       │
│    └─ Mostra dialog di conferma                                 │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. CheckDateExamProvider.bookExamAppello()                     │
│    ├─ Trova il corso con adId == appello.adId                 │
│    ├─ Estrae adsceId dal corso                                 │
│    └─ Chiama ApiCheckExamService.bookExamAppello()             │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. ApiCheckExamService.bookExamAppello()                       │
│    ├─ POST /students/bookExam/{cdsId}/{adId}/{appId}           │
│    ├─ Body: {                                                   │
│    │   "adsceId": adsceId,                                     │
│    │   "notaStu": "",                                           │
│    │   "aaIscrId": ...,                                         │
│    │   "aaRegId": ...,                                          │
│    │   ...dettaglioTratto fields                               │
│    │ }                                                           │
│    └─ Ritorna: Result<bool>                                     │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. Su successo:                                                 │
│    ├─ Ricarica gli appelli (fetchAllAppelliStudent)            │
│    ├─ Ricarica le prenotazioni (StudentUtils.allReservation)   │
│    └─ Mostra dialog di successo                                 │
│                                                                  │
│ Su errore:                                                      │
│    └─ Mostra dialog di errore con messaggio                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Stato Attuale dell'Implementazione

### ✅ JÀ IMPLEMENTATO
- **Service**: `ApiCheckExamService` - metodi `getAppelliStudent()` e `bookExamAppello()`
- **Model**: `CheckAppello` - contiene tutti i dati dell'appello
- **Provider**: `CheckDateExamProvider` - logica completa con:
  - `fetchAllAppelliStudent()` - carica appelli
  - `bookExamAppello()` - prenota appello
  - `_sortAppelliByDate()` - ordina per data
  - `filtraSoloAppelliPrenotabili()` - filtra appelli futuri
- **UI Principale**: `CheckAppello.dart` - schermata completa di visualizzazione e prenotazione
- **Widget**: `AppelloGroupList`, `AppelloCard`, `AppelloCardList` - componenti di visualizzazione

### ⚠️ MANCANO (o sono da migliorare)
- **ListaAppelliPage**: Schermata alternativa più semplice e pulita per visualizzare gli appelli
- **Integrazione automatica del caricamento**: Assicurare che gli appelli si carichino automaticamente quando si apre la schermata
- **Documentazione nel codice**: Aggiungere commenti dettagliati

---

## 📱 Implementazione ListaAppelliPage

Crea il file: `lib/screens/student/ListaAppelliPage.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../main.dart';
import '../../model/studentService/check_appello_data.dart';
import '../../provider/auth_provider.dart';
import '../../provider/check_exam_provider.dart';
import '../../provider/exam_provider.dart';
import '../../utilityFunctions/studentUtilsFunction.dart';
import '../../widget/navbar.dart';
import '../../widget/bottomNavBar.dart';

/// 📋 Schermata Semplificata per Visualizzare gli Appelli Disponibili
/// 
/// Questa schermata mostra:
/// - Lista di appelli disponibili per lo studente
/// - Possibilità di prenotarsi a un appello
/// - Loading states e error handling
class ListaAppelliPage extends StatefulWidget {
  const ListaAppelliPage({super.key});

  @override
  State<ListaAppelliPage> createState() => _ListaAppelliPageState();
}

class _ListaAppelliPageState extends State<ListaAppelliPage> {
  late CheckDateExamProvider checkExamProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Carica gli appelli al primo avvio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppelli();
    });
  }

  /// Carica gli appelli dall'API
  /// 
  /// Recupera dati da AuthProvider e ExamProvider, quindi chiama il provider
  Future<void> _loadAppelli() async {
    if (_isInitialized) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    checkExamProvider = Provider.of<CheckDateExamProvider>(context, listen: false);

    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;
    final courseList = examProvider.allCourseStudent;

    if (user == null || password == null || selectedCareer == null) {
      _showErrorSnapBar('Dati utente non disponibili');
      return;
    }

    if (courseList == null || courseList.isEmpty) {
      // Se i corsi non sono caricati, caricali prima
      try {
        await StudentUtils.allCourseStudent(context, user);
        final updatedCourseList = examProvider.allCourseStudent;
        if (updatedCourseList != null && updatedCourseList.isNotEmpty) {
          _loadAppelliWithCourseList(user, password, selectedCareer['cdsId'], updatedCourseList);
        }
      } catch (e) {
        _showErrorSnapBar('Errore nel caricamento dei corsi: $e');
      }
      return;
    }

    _loadAppelliWithCourseList(user, password, selectedCareer['cdsId'], courseList);
  }

  /// Carica gli appelli con lista corsi disponibile
  Future<void> _loadAppelliWithCourseList(
    dynamic user,
    String password,
    int cdsId,
    dynamic courseList,
  ) async {
    try {
      await checkExamProvider.fetchAllAppelliStudent(
        userId: user.userId!,
        password: password,
        cdsId: cdsId,
        courseList: courseList,
      );
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      _showErrorSnapBar('Errore nel caricamento degli appelli: $e');
    }
  }

  /// Gestisce la prenotazione a un appello
  Future<void> _handlePrenotazione(CheckAppello appello) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);

    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;
    final courseList = examProvider.allCourseStudent;

    if (user == null || password == null || selectedCareer == null) {
      _showErrorDialog(
        'Errore',
        'Dati utente non disponibili',
      );
      return;
    }

    if (appello.adId == null || appello.appId == null) {
      _showErrorDialog(
        'Errore',
        'Dati dell\'appello non validi',
      );
      return;
    }

    if (courseList == null || courseList.isEmpty) {
      _showErrorDialog(
        'Errore',
        'Lista corsi non disponibile',
      );
      return;
    }

    // Mostra dialog di conferma
    final conferma = await _showConfirmDialog(appello);
    if (conferma != true) return;

    // Mostra loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      // Esegui la prenotazione
      final result = await checkExamProvider.bookExamAppello(
        userId: user.userId!,
        password: password,
        cdsId: selectedCareer['cdsId'],
        adId: appello.adId!,
        appId: appello.appId!,
        dettaglioTratto: selectedCareer['dettaglioTratto'],
        courseList: courseList,
      );

      // Chiudi dialog loading
      if (mounted) Navigator.of(context).pop();

      if (result.isSuccess) {
        // Ricarica le prenotazioni
        if (mounted) {
          await StudentUtils.allReservationStudent(context, user);
        }

        if (mounted) {
          _showSuccessDialog(
            'Successo',
            'Prenotazione effettuata con successo!',
          );
        }
      } else {
        if (mounted) {
          _showErrorDialog(
            'Errore',
            result.errorMessage ?? 'Impossibile completare la prenotazione',
          );
        }
      }
    } catch (e) {
      // Chiudi dialog loading
      if (mounted) Navigator.of(context).pop();
      _showErrorDialog(
        'Errore',
        'Errore imprevisto: $e',
      );
    }
  }

  /// Mostra dialog di conferma prenotazione
  Future<bool?> _showConfirmDialog(CheckAppello appello) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Conferma Prenotazione',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appello.esame != null)
              Text('Esame: ${appello.esame}'),
            if (appello.dataEsame != null)
              Text('Data: ${appello.dataEsame}'),
            if (appello.docenteCompleto != null)
              Text('Docente: ${appello.docenteCompleto}'),
            const SizedBox(height: 12),
            Text(
              'Vuoi prenotare questo appello?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'Conferma',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog di successo
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: AppColors.successColor),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog di errore
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: AppColors.errorColor),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mostra SnackBar di errore
  void _showErrorSnapBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkExamProvider = Provider.of<CheckDateExamProvider>(context);
    final appelli = checkExamProvider.allAppelliStudent;
    final isLoading = checkExamProvider.isLoading;
    final errorMessage = checkExamProvider.errorMessage;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: _buildBody(appelli, isLoading, errorMessage),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  /// Costruisce il body della schermata
  Widget _buildBody(List<CheckAppello> appelli, bool isLoading, String? errorMessage) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Errore: $errorMessage',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAppelli,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: const Text(
                'Riprova',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (appelli.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primaryColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Nessun appello disponibile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tornerai a controllare più tardi',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadAppelli(),
      child: ListView.builder(
        itemCount: appelli.length,
        itemBuilder: (context, index) {
          final appello = appelli[index];
          return _buildAppelloCard(appello);
        },
      ),
    );
  }

  /// Costruisce la card di un singolo appello
  Widget _buildAppelloCard(CheckAppello appello) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome esame
            if (appello.esame != null)
              Text(
                appello.esame!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            const SizedBox(height: 12),

            // Data esame
            if (appello.dataEsame != null)
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    appello.dataEsame!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

            const SizedBox(height: 8),

            // Docente
            if (appello.docenteCompleto != null)
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appello.docenteCompleto!,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 8),

            // Stato
            if (appello.statoDes != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appello.statoDes!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Note
            if (appello.note != null && appello.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note:',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appello.note!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

            // Bottone Prenota
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handlePrenotazione(appello),
                icon: const Icon(Icons.check_circle),
                label: const Text('Prenota Appello'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔌 Come Integrare nel Progetto

### 1️⃣ File Altrady Esistenti (Nessuna modifica necessaria)
Tutti questi file sono già implementati e funzionanti:
- ✅ `lib/service/api_checkexam_service.dart`
- ✅ `lib/service/api_student_service.dart`
- ✅ `lib/provider/check_exam_provider.dart`
- ✅ `lib/screens/student/CheckAppello.dart`
- ✅ `lib/model/studentService/check_appello_data.dart`
- ✅ `lib/model/studentService/student_course_data.dart`

### 2️⃣ Nuovo File da Creare
- 📄 `lib/screens/student/ListaAppelliPage.dart` (vedi sopra)

### 3️⃣ Route Navigation
Aggiungi la rotta nel tuo `lib/app_routes.dart` (se non presente):

```dart
import 'package:appuniparthenope/screens/student/ListaAppelliPage.dart';

// Aggiungi nella mappa delle rotte:
const String listaAppelliRoute = '/lista_appelli';

// Nel getRoutes():
listaAppelliRoute: (context) => const ListaAppelliPage(),
```

### 4️⃣ Navigazione dalla UI
Da qualsiasi altro schermata, naviga così:

```dart
Navigator.of(context).pushNamed('/lista_appelli');
// Oppure
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const ListaAppelliPage(),
  ),
);
```

### 5️⃣ Aggiungere al Menu (opzionale)
Se vuoi aggiungere un link nel menu principale o nel BottomNavBar:

```dart
// Nel widget di navigazione
ListTile(
  leading: const Icon(Icons.calendar_today),
  title: const Text('Appelli'),
  onTap: () {
    Navigator.of(context).pushNamed('/lista_appelli');
  },
);
```

---

## 🚀 Flusso Completo di Utilizzo

### Scenario: Studente vuole prenotarsi a un appello

1. **Studente apre l'app** → `CheckAppello.dart` o `ListaAppelliPage.dart`

2. **Schermata si carica automaticamente**:
   - Legge `authProvider.selectedCareer` → ottiene `stuId`, `matId`, `cdsId`
   - Carica `pianoId` da `ApiStudentService.getPianoId(stuId)`
   - Carica lista corsi da `ApiStudentService.getAllCourse(stuId, pianoId)`
   - Carica appelli da `ApiCheckExamService.getAppelliStudent(userId, password, cdsId, courseList)`
   - Provider filtra appelli futuri e li ordina per data

3. **Studente vede lista appelli** con:
   - Nome esame
   - Data esame
   - Docente
   - Stato (es. "Prenotabile")
   - Bottone "Prenota"

4. **Studente clicca "Prenota"**:
   - Si apre dialog di conferma
   - Studente conferma

5. **Viene inviata richiesta POST** a `/students/bookExam/{cdsId}/{adId}/{appId}` con:
   - `adsceId` (estratto dal corso)
   - `notaStu` (vuoto)
   - Campi aggiuntivi da `dettaglioTratto` (aaIscrId, aaRegId, annoCorso, ecc.)

6. **Su successo**:
   - Ricarica lista appelli (per mostrare aggiornamenti)
   - Ricarica lista prenotazioni
   - Mostra dialog di successo

7. **Su errore**:
   - Mostra messaggio errore specifico dal server

---

## 🔍 Dettagli Tecnici Importanti

### Dati Necessari per Prenotazione

L'API richiede nel body della POST:

```json
{
  "adsceId": 5811981,          // OBBLIGATORIO - estratto da CourseInfo
  "notaStu": "",                 // Opzionale
  "aaIscrId": 123,              // Opzionale - da selectedCareer
  "aaRegId": 456,               // Opzionale - da selectedCareer
  "annoCorso": 2,               // Opzionale - da selectedCareer
  "iscrId": 789,                // Opzionale - da selectedCareer
  "stuId": 12345,               // Opzionale - da selectedCareer
  "matId": 67890                // Opzionale - da selectedCareer
}
```

### Parsing delle Date

Gli appelli arrivano con date in vari formati:
- `dataFine` (es. "2026-04-30")
- `dataEsame` (es. "2026-04-30 14:30")
- `dataInizio` (es. "2026-04-20")

Il provider gestisce il parsing automatico con fallback per:
- ISO format: `DateTime.parse()`
- Custom format: `DateFormat('yyyy/MM/dd HH:mm').parse()`

### Filtraggio Appelli Prenotabili

Il provider filtra automaticamente:
- ✅ Solo appelli con data >= oggi
- ✅ Ordina dal più vicino al più lontano
- ✅ Gestisce date malformate (le mette in fondo)

---

## 🧪 Testing

### Test Case 1: Caricamento Appelli
```
1. Apri ListaAppelliPage
2. Attendi che la lista si carichi
3. Verifica che appelli siano visibili e ordinati per data
```

### Test Case 2: Prenotazione Successo
```
1. Seleziona un appello
2. Clicca "Prenota"
3. Conferma nel dialog
4. Verifica messaggio di successo
5. Controlla che la lista prenotazioni si sia aggiornata
```

### Test Case 3: Errore Prenotazione
```
1. Seleziona un appello
2. Clicca "Prenota"
3. (Disattiva internet o causa errore API)
4. Verifica messaggio di errore appropriato
5. Verifica che pullRefresh consenta nuovo tentativo
```

---

## 📚 Cartella Model e Service Reference

### CheckAppello (Model)
**File**: `lib/model/studentService/check_appello_data.dart`
**Campi principali**:
- `esame`: Nome dell'esame
- `appId`: ID dell'appello
- `adId`: ID dell'attività didattica
- `dataEsame`: Data dell'esame
- `dataFine`: Data fine prenotazione
- `dataInizio`: Data inizio prenotazione
- `docente`: Iniziali docente
- `docenteCompleto`: Nome completo docente
- `stato`: Codice stato
- `statoDes`: Descrizione stato
- `numIscritti`: Numero iscritti
- `note`: Note aggiuntive

### CourseInfo (Model)
**File**: `lib/model/studentService/student_course_data.dart`
**Campi principali**:
- `adId`: ID attività didattica (usato nelle API per appelli)
- `adsceId`: ID ascesa corso (usato per prenotazione)
- `nome`: Nome corso
- `annoId`: ID anno

### ApiCheckExamService
**File**: `lib/service/api_checkexam_service.dart`
**Metodi**:
- `getAppelliStudent()`: Formula GET multipli per ogni corso e agglomera risultati
- `bookExamAppello()`: Esecta POST a `/students/bookExam/{cdsId}/{adId}/{appId}`

### CheckDateExamProvider
**File**: `lib/provider/check_exam_provider.dart`
**Metodi**:
- `fetchAllAppelliStudent()`: Chiama service e aggiorna stato
- `bookExamAppello()`: Chiama service per prenotazione
- `_sortAppelliByDate()`: Ordina per data
- `filtraSoloAppelliPrenotabili()`: Filtra appelli futuri

---

## ✅ Checklist Implementazione

- [ ] Leggi questo documento completamente
- [ ] Assicurati che i servizi siano già registrati in `service_locator.dart`
- [ ] Crea file `ListaAppelliPage.dart` da codice sopra
- [ ] Aggiungi rotta a `app_routes.dart`
- [ ] Testa caricamento appelli
- [ ] Testa prenotazione con dialog di conferma
- [ ] Verifica messaggi di successo/errore
- [ ] Testa pull-to-refresh
- [ ] Testa con rete lenta/assente

---

## 🆘 Troubleshooting

### Problema: Appelli non caricano
**Soluzione**:
1. Verifica che `allCourseStudent` sia disponibile nel provider
2. Controlla logs per errori API
3. Assicurati autenticazione Basic sia corretta

### Problema: Prenotazione fallisce con "adsceId non trovato"
**Soluzione**:
1. Verifica che `CourseInfo` contenga `adsceId`
2. Controlla che il corso con `adId == appello.adId` esista nella lista

### Problema: Date non si ordinano bene
**Soluzione**:
1. Verifica formato data dalle API (ISO vs custom)
2. Aggiungi debug print nel `_sortAppelliByDate()`

### Problema: Dialog prenotazione non ricarica
**Soluzione**:
1. Aggiungi `setState()` dopo successo prenotazione
2. Richiama `notifyListeners()` nel provider

---

## 📞 Supporto e Domande

Per domande specifiche su:
- **API**: Vedi `ApiCheckExamService`
- **State**: Vedi `CheckDateExamProvider`
- **UI**: Vedi `ListaAppelliPage.dart` sopra
- **Models**: Vedi `CheckAppello` e `CourseInfo`
