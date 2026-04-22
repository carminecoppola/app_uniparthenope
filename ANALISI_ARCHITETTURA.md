# 📊 ANALISI ARCHITETTURA - App UniParthenope

**Repository**: carminecoppola/app_uniparthenope  
**Tipo**: Applicazione Flutter per l'Università di Napoli Parthenope  
**Versione**: 4.0.9+40009

---

## 📁 1. STRUTTURA DELLE CARTELLE

```
lib/
├── controller/              # Business logic per operazioni complesse
│   ├── student_controller.dart        # Gestisce dati e operazioni studenti
│   ├── checkexam_controller.dart      # Prenotazione esami
│   ├── professor_controller.dart      # Controller prof
│   ├── weather_controller.dart
│   ├── uniService_controller.dart
│   └── auth_controller.dart
│
├── service/                # API e servizi esterni
│   ├── api_student_service.dart       # ✅ API esami, carriera, corsi
│   ├── api_checkexam_service.dart     # ✅ API prenotazione esami
│   ├── api_login_service.dart         # Autenticazione
│   ├── api_teacher_service.dart       # API professori
│   ├── api_univerisity_service.dart   # Eventi, aule, etc
│   ├── api_weather_service.dart       # Meteo
│   ├── notification_service.dart      # Notifiche locali
│   ├── local_grades_service.dart      # Storage voti in locale
│   ├── update_service.dart            # Versioning app
│   └── test_grades_helper.dart        # Testing helper
│
├── model/                  # Classi dati
│   ├── user_data_login.dart           # Dati utente registrato
│   ├── user_data_anagrafic.dart       # Anagrafica utente
│   ├── weather_data.dart              # Dati meteo
│   ├── weather_timeSerys_data.dart
│   │
│   └── studentService/                # Model specifici studente
│       ├── exam_data.dart             # ✅ ExamData
│       ├── student_career_data.dart   # ✅ TotalExamStudent, AverageInfo
│       ├── check_appello_data.dart    # ✅ CheckAppello
│       ├── student_course_data.dart   # CourseInfo, StatusCourse
│       ├── reservation_data.dart      # ✅ ReservationInfo (prenotazioni)
│       ├── calendar_data.dart         # CalendarInfo
│       ├── events_data.dart           # EventsInfo
│       └── taxes_data.dart            # TaxesInfo
│
├── provider/               # State Management (Provider + ChangeNotifier)
│   ├── auth_provider.dart             # Auth state
│   ├── exam_provider.dart             # ✅ ExamDataProvider (esami, carriera)
│   ├── check_exam_provider.dart       # ✅ CheckDateExamProvider (appelli)
│   ├── professor_provider.dart
│   ├── weather_provider.dart
│   ├── rooms_provider.dart
│   ├── taxes_provider.dart
│   ├── update_provider.dart
│   ├── bottomNavBar_provider.dart
│   └── events_provider.dart
│
├── screens/                # UI organizzata per ruoli/funzionalità
│   ├── loginpage.dart
│   ├── personalCardPage.dart
│   ├── personalProfile.dart
│   ├── home.dart
│   ├── WeatherPage.dart
│   ├── CourseDetailsInfo.dart
│   ├── InfoAppPage.dart
│   ├── calendarInfo.dart
│   │
│   ├── student/                       # ✅ Schermata studenti
│   │   ├── CareerStudent.dart         # ✅ Visualizza carriera, voti
│   │   ├── CheckAppello.dart          # ✅ Prenota esami
│   │   ├── CourseStudent.dart         # Dettagli corsi
│   │   ├── ReservationStudent.dart    # Prenotazioni
│   │   └── FeesStudent.dart           # Tasse
│   │
│   ├── teacher/                       # Schermata professori
│   ├── dottorandi/                    # Schermata dottorandi
│   ├── pta/                           # Schermata amministrativo
│   ├── guest/                         # Accesso ospite
│   └── resturant/
│
├── widget/                 # Componenti riutilizzabili
│   ├── navbar.dart
│   ├── bottomNavBar.dart
│   ├── CustomLoadingIndicator.dart
│   └── ServicesWidget/
│       ├── CareerWidget/
│       │   ├── TotalExamStudentCard.dart
│       │   └── singleExamCard.dart
│       └── CheckExamWidget/
│           └── appello_card_list.dart
│
├── core/                   # Configurazione centrale
│   ├── service_locator.dart           # Dependency Injection (GetIt)
│   └── logger.dart                    # Logging
│
├── utilityFunctions/       # Funzioni helper
│   └── studentUtilsFunction.dart
│
├── main.dart               # Entry point + MultiProvider setup
├── app_routes.dart         # Routing
├── app_localizations.dart  # i18n (EN, IT)

```

---

## 🔌 2. SERVICE API ESISTENTI

### 📊 BaseUrl
```
https://api.uniparthenope.it/UniparthenopeApp/v1/
```

### 🔐 Autenticazione
- **Tipo**: Basic Authentication
- **Header**: `Authorization: Basic base64(userId:password)`
- **Implementazione**:
  ```dart
  'Authorization': 'Basic ${base64Encode(utf8.encode("$userId:$password"))}'
  ```

### 📌 API per STUDENTI

#### **ApiStudentService** (`api_student_service.dart`)

| Endpoint | Metodo | Descrizione | Return Type |
|----------|--------|-------------|------------|
| `/students/totalExams/{matId}` | GET | Statistiche totali esami (esami superati, CFU) | `TotalExamStudent` |
| `/students/exams/{matId}` | GET | Lista completa esami con voti | `List<ExamData>` |
| `/students/average/{matId}/{averageType}` | GET | Media aritmetica e ponderata | `AverageInfo` |
| `/students/courses/{matId}` | GET | Lista corsi iscritto | `List<CourseInfo>` |
| `/students/statusExam/{cdsId}/{matId}` | GET | Stato dei corsi (superato, in corso, ecc) | `List<StatusCourse>` |
| `/students/reservations/{matId}` | GET | Lista prenotazioni esami | `List<ReservationInfo>` |
| `/students/pianoId/{matId}` | GET | ID piano di studio | `Map<String, dynamic>` |
| `/students/lectures/{matId}` | GET | Lezioni/calendario | `List<LecturesInfo>` |
| `/students/taxes/{matId}` | GET | Tasse e contributi | `Map<String, dynamic>` |

#### **ApiCheckExamService** (`api_checkexam_service.dart`)

| Endpoint | Metodo | Descrizione | Return Type |
|----------|--------|-------------|------------|
| `/students/checkAppello/{cdsId}/{adId}` | GET | Appelli disponibili per esame | `List<CheckAppello>` |
| `/students/bookExam/{cdsId}/{adId}/{appId}` | POST | Prenota appello | `bool` |

**Parametri POST prenotazione**:
```json
{
  "adsceId": int,           // ID corso da prenotare (REQUIRED)
  "notaStu": string,        // Nota aggiuntiva (optional)
  "aaIscrId": int,          // Anno iscrizione (se disponibile)
  "aaRegId": int,           // Anno registrazione
  "annoCorso": int,         // Anno del corso
  "iscrId": int,            // ID iscrizione
  "stuId": int,             // ID studente
  "matId": int              // ID matricola
}
```

---

### 👨‍🏫 API per PROFESSORI

#### **ApiTeacherService** (`api_teacher_service.dart`)

| Endpoint | Metodo | Descrizione | Return Type |
|----------|--------|-------------|------------|
| `/courses/{userId}` | GET | Corsi insegnati | `List<CourseProfessorInfo>` |
| `/session/{userId}/{cdsId}` | GET | Sessioni esami | `SessionProfessorInfo` |
| `/details/{userId}/{adId}` | GET | Dettagli corso | `DetailsCourseInfo` |
| `/checkExam/{userId}/{adId}` | GET | Info studenti iscritti | `List<CheckExamInfo>` |
| `/studentList/{userId}/{cdsId}/{adId}/{appId}` | GET | Lista studenti esame | `List<ListStudentsExam>` |

---

### 🎓 API Università

#### **ApiUniversityService** (`api_univerisity_service.dart`)

| Endpoint | Metodo | Descrizione | Return Type |
|----------|--------|-------------|------------|
| `/events` | GET | Eventi università | `List<EventsInfo>` |
| `/rooms/today` | GET | Aule disponibili oggi | `List<AllTodayRooms>` |

---

### 🌤️ Servizi Aggiuntivi

#### **ApiWeatherService**
- Meteorologia

#### **ApiLoginService**
- Autenticazione utenti

---

## 📦 3. STRUTTURA DEI MODEL

### 🏆 Career / Esami

#### **ExamData** (`exam_data.dart`)
```dart
class ExamData {
  String? nome;                // Nome insegnamento
  String? codice;              // Codice esame
  String? tipo;                // Tipo (obbligatorio, opzionale, ecc)
  int? adId;                   // ID attività didattica
  int? adsceID;                // ID adsceID
  String? docente;             // Nome docente
  String? semestre;            // Semestre
  double? cfu;                 // Crediti formativi
  Status status;               // Status voto (voto, esito, data, lode)
  int? annoId;                 // Anno piano di studio
  int? numAppelliPrenotabili;  // Appelli disponibili
}

class Status {
  String? esito;               // SUPERATO, RINUNCIA, etc
  double? voto;                // Voto 0-30
  double? lode;                // Lode (0 o 1)
  String? data;                // Data esame
}
```

#### **StudentCareerData / TotalExamStudent** (`student_career_data.dart`)
```dart
class TotalExamStudent {
  int totAdSuperate;           // Total attività didattiche superate
  int numAdSuperate;           // Numero attività superate
  double cfuPar;               // CFU parziali
  double cfuTot;               // CFU totali
}

class AverageInfo {
  double trenta;               // Media su 30
  int baseTrenta;              // Base calcolo su 30
  int baseCentodieci;          // Base calcolo su 110
  double centodieci;           // Media su 110
}
```

### 📋 Appelli / Prenotazioni

#### **CheckAppello** (`check_appello_data.dart`)
```dart
class CheckAppello {
  int? adId;                   // ID attività didattica
  int? appId;                  // ID appello
  String? nomeAppello;         // Nome appello
  String? dataEsa;             // Data esame
  String? desApp;              // Descrizione appello
  // ... altri campi
}
```

#### **ReservationInfo** (`reservation_data.dart`)
```dart
class ReservationInfo {
  int? adId;                   // ID attività didattica
  int? appId;                  // ID appello
  String? nomeAppello;         // Nome appello
  String? dataEsa;             // Data esame
  String? aulaDes;             // Aula
  String? statoDes;            // Stato prenotazione
  int? numIscritti;            // Numero iscritti
  String? nomePres;            // Nome professore
  // ... altri campi
}
```

### 👤 Corsi / Iscrizioni

#### **CourseInfo** (`student_course_data.dart`)
```dart
class CourseInfo {
  String? nome;                // Nome corso
  int? adId;                   // ID attività didattica
  String? docente;             // Docente
  double? cfu;                 // CFU
  String? semestre;            // Semestre
}

class StatusCourse {
  String? nomeCourse;
  String? status;              // SUPERATO, IN_CORSO, NON_FREQUENTATO
}
```

---

## 🎛️ 4. STATE MANAGEMENT

### Sistema Ibrido: Provider + GetIt

#### **Provider (ChangeNotifierProvider)** - Per UI
```dart
// main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => ExamDataProvider()),
    ChangeNotifierProvider(create: (context) => CheckDateExamProvider()),
    ChangeNotifierProvider(create: (context) => ProfessorDataProvider()),
    ChangeNotifierProvider(create: (context) => WeatherDataProvider()),
    ChangeNotifierProvider(create: (context) => TaxesDataProvider()),
    ChangeNotifierProvider(create: (context) => RoomsProvider()),
    ChangeNotifierProvider(create: (context) => BottomNavBarProvider()),
    ChangeNotifierProvider(create: (context) => UpdateProvider()),
  ],
)
```

#### **GetIt (Dependency Injection)** - Per servizi

```dart
// core/service_locator.dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<ApiCheckExamService>(
    () => ApiCheckExamService()
  );
  getIt.registerLazySingleton<ApiStudentService>(
    () => ApiStudentService()
  );
  getIt.registerLazySingleton<ApiTeacherService>(
    () => ApiTeacherService()
  );
  // ... altri servizi
}
```

### 🔄 Flusso dei Dati

```
API Service (GetIt)
    ↓
Controller (business logic)
    ↓
Provider (ChangeNotifier + notifyListeners)
    ↓
UI (Consumer<Provider>)
```

**Esempio - Caricamento esami**:

```dart
// 1. Service API chiama endpoint
final List<ExamData> exams = await apiService.getStudentExams(student, context);

// 2. Controller elabora dati
final exams = await studentController.fetchAllExamStudent(student, context);

// 3. Provider aggiorna state
Provider.of<ExamDataProvider>(context, listen: false)
  .setAllExamStudent(exams);  // → notifyListeners()

// 4. UI si aggiorna automaticamente
Consumer<ExamDataProvider>(
  builder: (_, provider, __) {
    return ListView(
      children: provider.allExamStudent?.map((exam) => ...).toList() ?? [],
    );
  }
)
```

---

## 📱 5. ORGANIZZAZIONE SCHERMATE

### Architettura Navigazione

```
LoginForm
    ↓
Home (role-based routing)
├── student/
│   ├── CareerStudent.dart        ✅ TAB 0
│   ├── CheckAppello.dart         ✅ TAB 1 (prenotazioni)
│   ├── CourseStudent.dart
│   ├── ReservationStudent.dart
│   └── FeesStudent.dart
│
├── teacher/
│   └── ...
│
├── dottorandi/
├── pta/
└── guest/
```

### 📊 **Schermata Carriera (CareerStudent.dart)**

**Componenti**:
- `TotalExamStudentCard` - Mostra statistiche (CFU, esami superati)
- `singleExamCard` - Lista esami con voti
- Media aritmetica e ponderata

**State Management**:
```dart
final totalExamStats = Provider.of<ExamDataProvider>(context).totalExamStudent;
final aritmeticAvg = Provider.of<ExamDataProvider>(context).aritmeticAverageStatsStudent;
final allExams = Provider.of<ExamDataProvider>(context).allExamStudent;
```

**Stati**:
- `CareerState.loading` - Caricamento
- `CareerState.empty` - Nessun esame
- `CareerState.success` - Visualizza carriera

### 📅 **Schermata Prenotazione Esami (CheckAppello.dart)**

**Componenti**:
- `AppelloGroupList` - Appelli raggruppati per insegnamento
- `AppelloCard` - Singolo appello con info data, aula, prof

**State Management**:
```dart
final checkExamProvider = Provider.of<CheckDateExamProvider>(context);
final appelli = checkExamProvider.allAppelliStudent;
```

**Flusso Prenotazione**:
1. Carica appelli disponibili → `CheckDateExamProvider`
2. Utente seleziona appello
3. Chiama `ApiCheckExamService.bookExamAppello()`
4. Backend calcola anno sessione automaticamente
5. Aggiorna lista prenotazioni

---

## 🔑 6. MODEL/SERVICE CAREER, EXAMS, BOOKINGS

### 📚 EXAMS (Modello esami)

#### Model
```
ExamData
├── nome, codice, tipo
├── docente, docenteID, semestre
├── cfu, annoId
├── status (voto, esito, data, lode)
└── numAppelliPrenotabili
```

#### Service
```
ApiStudentService::getStudentExams()
  → Endpoint: /students/exams/{matId}
  → Return: List<ExamData>
```

#### Provider
```
ExamDataProvider
├── _allExamStudent: List<ExamData>
├── setAllExamStudent()
└── allExamStudent (getter)
```

#### UI
```
CareerStudent.dart
└── Usa ExamDataProvider per mostrare esami
```

---

### 🏆 CAREER (Modello carriera)

#### Model
```
TotalExamStudent
├── totAdSuperate (int)
├── numAdSuperate (int)
├── cfuPar (double)
└── cfuTot (double)

AverageInfo
├── trenta (media su 30)
├── baseTrenta (int)
├── baseCentodieci (int)
└── centodieci (media su 110)
```

#### Service
```
ApiStudentService::studentTotalExamsStats()
  → Endpoint: /students/totalExams/{matId}
  → Return: TotalExamStudent

ApiStudentService::studentAverage()
  → Endpoint: /students/average/{matId}/{averageType}
  → Return: AverageInfo (x2: aritmetica e ponderata)
```

#### Provider
```
ExamDataProvider
├── _totalExamStatsStudent: TotalExamStudent
├── _aritmeticAverageStatsStudent: AverageInfo
├── _weightedAverageStatsStudent: AverageInfo
├── setTotalStatsExamStudent()
├── setTotalAverageExamStudent()
└── Getter per tutte le proprietà
```

#### UI
```
CareerStudent.dart
├── TotalExamStudentCard (mostra CFU, esami)
└── Media aritmetica/ponderata
```

---

### 📋 BOOKINGS (Prenotazioni esami)

#### Model
```
CheckAppello
├── adId (ID attività didattica)
├── appId (ID appello)
├── nomeAppello
├── dataEsa
└── desApp

ReservationInfo
├── adId, appId
├── nomeAppello, dataEsa
├── nomePres, cognomePres (docente)
├── aulaDes, edificioDes (aula)
├── statoDes (stato prenotazione)
└── numIscritti
```

#### Service
```
ApiCheckExamService
├── getAppelliStudent()
│   └── Endpoint: /students/checkAppello/{cdsId}/{adId}
│       → Return: List<CheckAppello>
│
└── bookExamAppello()
    └── Endpoint: /students/bookExam/{cdsId}/{adId}/{appId}
        POST body: { adsceId, notaStu, aaIscrId, ... }
        → Return: bool (success)
```

#### Provider
```
CheckDateExamProvider
├── _allAppelliStudent: List<CheckAppello>
├── isLoading: bool
├── setAppelliStudent()
└── allAppelliStudent (getter)
```

#### Controller
```
StudentController
├── fetchAllCourseStudent()
└── [Integration con ApiCheckExamService]
```

#### UI
```
CheckAppello.dart
├── AppelloGroupList (raggruppato per insegnamento)
└── onPrenota callback → bookExamAppello()

Flusso:
1. Carica appelli da API
2. Visualizza in ListaGruppata
3. Utente clicca "Prenota"
4. Invia POST a /students/bookExam
5. Notifica result all'utente
```

---

## 🔔 6.1 FEATURES AVANZATE

### Notifiche Automatiche Nuovi Voti
```dart
// ExamDataProvider::_checkAndNotifyNewGradesAsync()
LocalGradesService → Salva voti localmente
Confronta: server voti vs local voti
→ Rilevati nuovi voti
→ NotificationService.showNotification()
```

### Validazione Prenotazioni
```dart
// ApiCheckExamService::bookExamAppello()
- Valida userId, password, credenziali
- Valida cdsId, adId, appId, adsceId
- Backend calcola anno sessione automaticamente
- Debug log completi per troubleshooting
```

---

## 📱 6.2 CONTROLLER FLOW

### **StudentController** - Orchestrazione Dati

```
fetchAllExamStudent()
└── apiService.getStudentExams()
    → List<ExamData>

totalExamStatsStudent()
└── apiService.studentTotalExamsStats()
    → TotalExamStudent

averageStudent()
└── apiService.studentAverage()
    → AverageInfo

fetchAllCourseStudent()
└── apiService.getAllCourse()
    → List<CourseInfo>
```

---

## 🛠️ TABELLA RIASSUNTIVA INTEGRAZIONI

| Feature | Model | Service | Provider | Controller | UI |
|---------|-------|---------|----------|-----------|-----|
| **Visualizza Voti** | ExamData | ApiStudentService | ExamDataProvider | StudentController | CareerStudent |
| **Statistiche Carriera** | TotalExamStudent, AverageInfo | ApiStudentService | ExamDataProvider | StudentController | CareerStudent |
| **Carica Appelli** | CheckAppello | ApiCheckExamService | CheckDateExamProvider | - | CheckAppello |
| **Prenota Esame** | CheckAppello | ApiCheckExamService | CheckDateExamProvider | - | CheckAppello |
| **Lista Prenotazioni** | ReservationInfo | ApiStudentService | ExamDataProvider | StudentController | ReservationStudent |
| **Notifica Voto** | ExamData | LocalGradesService, NotificationService | ExamDataProvider | - | Home |

---

## 🚀 STACK TECNOLOGICO

```
Frontend:        Flutter 3.3.1+
State Management: Provider 6.1.2 + GetIt 7.7.0
Networking:      http 1.2.1
Localizzazione:  intl 0.19.0
Storage:         SharedPreferences 2.2.3
Notifiche:       flutter_local_notifications 17.1.2
Auth:            local_auth 2.2.0
Logging:         logger 2.4.0
```

---

## 📊 NOTE FINALI

1. **Autenticazione Base64**: Tutti i service usano Basic Auth con encoding Base64
2. **Role-based UI**: Routing diverso in base a ruolo (studente, prof, dottorando, etc)
3. **Local Storage**: Voti salvati localmente per notifiche intelligenti
4. **Async Notifications**: Nuovi voti notificati automaticamente
5. **Error Handling**: Result pattern per gestione errori robust
6. **Logging**: Ogni operazione loggata per debugging

