import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/controller/student_controller.dart';
import 'package:appuniparthenope/controller/uni_service_controller.dart';
import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/teacherService/room_data.dart';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/provider/rooms_provider.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Classe di utility per le operazioni legate agli studenti.
class StudentUtils {
  /// Ottiene e imposta i dati dell'anagrafe dell'utente autenticato.
  static Future<void> anagrafeUser(
      BuildContext context, User authenticatedUser) async {
    final AuthController authController = AuthController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Ottiene e imposta i dati dell'anagrafe dell'utente.
      final anagrafeUser =
          await authController.setAnagrafe(context, authenticatedUser);
      if (!context.mounted) return;

      // Aggiorna il provider con i dati dell'anagrafe dell'utente.
      authProvider.setAnagrafeUser(anagrafeUser);
    } catch (_) {
      return;
    }
  }

  /// Ottiene e aggiorna le statistiche totali degli esami dello studente.
  static Future<void> fetchDataAndUpdateStats(
      BuildContext context, User authenticatedUser) async {
    try {
      await totalExamStats(context, authenticatedUser);
      if (!context.mounted) return;
      await averageStats(context, authenticatedUser);
      if (!context.mounted) return;
      await allExamStudent(context, authenticatedUser);
    } catch (_) {
      return;
    }
  }

  /// Ottiene e imposta le statistiche totali degli esami dello studente.
  static Future<void> totalExamStats(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Ottiene le statistiche totali degli esami dello studente.
      final totalExamStudent = await totalExamController.totalExamStatsStudent(
          authenticatedUser, context);
      if (!context.mounted) return;

      // Aggiorna il provider con le statistiche totali degli esami dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalStatsExamStudent(totalExamStudent);
    } catch (_) {
      return;
    }
  }

  /// Ottiene e imposta le statistiche medie degli esami dello studente.
  static Future<void> averageStats(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Stampa un messaggio di avvio

      // Ottiene la media aritmetica degli esami dello studente.
      final aritmeticAverageStudent = await totalExamController.averageStudent(
          context, authenticatedUser, "A");
      if (!context.mounted) return;

      // Verifica se i dati della media sono validi
      if (aritmeticAverageStudent.trenta == 0 &&
          aritmeticAverageStudent.centodieci == 0) {
        return; // Esci dal metodo se non ci sono dati
      }

      // Ottiene la media ponderata degli esami dello studente.
      final weightedAverageStudent = await totalExamController.averageStudent(
          context, authenticatedUser, "P");
      if (!context.mounted) return;

      if (weightedAverageStudent.trenta == 0 &&
          weightedAverageStudent.centodieci == 0) {
        return; // Esci dal metodo se non ci sono dati
      }

      // Aggiorna il provider con le statistiche medie degli esami dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalAverageExamStudent(
          aritmeticAverageStudent, weightedAverageStudent);
    } catch (_) {
      return;
    }
  }

  /// Ottiene e imposta tutti gli esami dello studente.
  static Future<void> allExamStudent(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Salva il riferimento al provider PRIMA dell'operazione asincrona
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);

      // Ottiene tutti gli esami dello studente.
      final allExamStudent = await totalExamController.fetchAllExamStudent(
          authenticatedUser, context);

      // Aggiorna il provider con tutti gli esami dello studente.
      examDataProvider.setAllExamStudent(
        allExamStudent,
        cacheScope: authenticatedUser.userId?.toString(),
      );
    } catch (_) {
      return;
    }
  }

  /// Ottiene e imposta tutti i corsi dello studente.
  static Future<void> allCourseStudent(
      BuildContext context, User? authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);

    try {
      if (authenticatedUser == null) {
        throw Exception('Utente non autenticato');
      }
      AppLogger.info(
          'COURSE LOAD start userId=${authenticatedUser.userId} role=${authenticatedUser.grpDes}');

      // Ottiene tutti i corsi dello studente.
      final allCourseStudent = await totalExamController.fetchAllCourseStudent(
          authenticatedUser, context);

      // Aggiorna il provider con tutti i corsi dello studente.
      examDataProvider.setAllCoursesStudent(allCourseStudent);
      final totalCfu =
          allCourseStudent.fold<double>(0, (sum, c) => sum + c.cfu);
      AppLogger.info(
          'COURSE LOAD done count=${allCourseStudent.length} totalCfu=$totalCfu');

      // NON chiamiamo allStatusCourse qui perché il context potrebbe essere deactivated
      // Lo stato verrà caricato dalla pagina stessa quando necessario
    } catch (e, stackTrace) {
      examDataProvider.setCourseLoadError(e.toString());
      AppLogger.error('Errore durante caricamento corsi studente', e, stackTrace);
      return;
    }
  }

  /// Ottiene e imposta lo stato di tutti i corsi dello studente.
  static Future<void> allStatusCourse(BuildContext context,
      User authenticatedUser, List<CourseInfo> allCourses) async {
    final StudentController totalExamController = StudentController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final selectedCareer = authProvider.selectedCareer;
    final password = authProvider.password;
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);

    if (selectedCareer == null || password == null) {
      AppLogger.warning(
          'Impossibile caricare stato corsi: carriera o password non disponibili');
      examDataProvider.setStatusCoursesMap({});
      examDataProvider.setAllStatusCourses([]);
      return;
    }

    final matId = selectedCareer['matId']?.toString();
    if (matId == null || matId.isEmpty) {
      AppLogger.warning('Impossibile caricare stato corsi: matId non disponibile');
      examDataProvider.setStatusCoursesMap({});
      examDataProvider.setAllStatusCourses([]);
      return;
    }

    try {
      // Ottiene lo stato di tutti i corsi dello studente.
      Map<String, StatusCourse> statusCoursesMap = await totalExamController
          .fetchAllCourseStatus(
        authenticatedUser,
        allCourses,
        matId: matId,
        password: password,
      );

      // Converte la mappa in una lista e aggiorna il provider con lo stato dei corsi.
      examDataProvider.setAllStatusCourses(statusCoursesMap.values.toList());
      examDataProvider.setStatusCoursesMap(statusCoursesMap);
    } catch (e, stackTrace) {
      AppLogger.error('Errore durante caricamento stato corsi', e, stackTrace);
      examDataProvider.setStatusCoursesMap({});
      examDataProvider.setAllStatusCourses([]);
      return;
    }
  }

  /// Ottiene e imposta le informazioni sulle tasse dello studente.
  static Future<void> taxesStudent(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalTaxesController = StudentController();
    try {
      // Salva il riferimento al provider PRIMA dell'operazione asincrona
      final taxesDataProvider =
          Provider.of<TaxesDataProvider>(context, listen: false);

      // Ottiene e imposta le informazioni sulle tasse dello studente.
      final allTaxesStudent =
          await totalTaxesController.setTaxes(context, authenticatedUser);

      // Aggiorna il provider con le informazioni sulle tasse dello studente.
      taxesDataProvider.setTaxesInfo(allTaxesStudent);
    } catch (_) {
      return;
    }
  }

  /// Ottiene e imposta tutti gli eventi dell'università.
  static Future<void> allEvents(BuildContext context) async {
    final UniServiceController eventController = UniServiceController();

    try {
      // Salva il riferimento al provider PRIMA dell'operazione asincrona
      final eventsDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);

      // Ottiene tutti gli eventi dell'università.
      final allEvents = await eventController.getAllEvents(context);

      // Aggiorna il provider con tutti gli eventi dell'università.
      eventsDataProvider.setAllEvents(allEvents);
    } catch (_) {
      return;
    }
  }

  /// Ottiene e imposta tutte le stanze disponibili per oggi.
  static Future<List<AllTodayRooms>> allRooms(BuildContext context) async {
    final UniServiceController roomController = UniServiceController();

    try {
      // Salva il riferimento al provider PRIMA dell'operazione asincrona
      final roomsDataProvider =
          Provider.of<RoomsProvider>(context, listen: false);

      // Ottiene tutte le stanze disponibili per oggi.
      final allrooms = await roomController.getAllTodayRoom(context);

      // Aggiorna il provider con tutte le stanze disponibili.
      roomsDataProvider.setAllTodayRooms(allrooms);

      return allrooms;
    } catch (e) {
      rethrow; // Rilancia l'eccezione per gestirla ulteriormente se necessario.
    }
  }

  /// Ottiene e imposta tutte le prenotazioni dello studente.
  static Future<void> allReservationStudent(
      BuildContext context, User? authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      if (authenticatedUser == null) {
        throw Exception('Utente non autenticato');
      }
      AppLogger.info(
          'RESERVATION LOAD start userId=${authenticatedUser.userId}');

      // Salva TUTTI i riferimenti ai provider PRIMA delle operazioni asincrone
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);

      // Ottiene le prenotazioni - il context viene usato dentro ma solo per accedere ai provider
      // quindi salviamo i dati prima
      final allReservationStudent = await totalExamController
          .fetchAllReservationStudent(authenticatedUser, context);

      // Ora è sicuro aggiornare il provider anche se il context è deactivated
      examDataProvider.setAllReservationStudent(allReservationStudent);
      AppLogger.info(
          'RESERVATION LOAD done count=${allReservationStudent.length}');
    } catch (e) {
      // Non rilanciare l'errore per evitare crash dell'app
      AppLogger.error('RESERVATION LOAD error', e);
    }
  }
}
