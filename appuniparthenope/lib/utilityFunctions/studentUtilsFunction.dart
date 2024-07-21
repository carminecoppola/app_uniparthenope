import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/controller/student_controller.dart';
import 'package:appuniparthenope/controller/uniService_controller.dart';
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

    try {
      // Ottiene e imposta i dati dell'anagrafe dell'utente.
      final anagrafeUser =
          await authController.setAnagrafe(context, authenticatedUser);

      // Aggiorna il provider con i dati dell'anagrafe dell'utente.
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAnagrafeUser(anagrafeUser);
    } catch (e) {
      print('Error during _setAnagrafe: $e');
    }
  }

  /// Ottiene e aggiorna le statistiche totali degli esami dello studente.
  static Future<void> fetchDataAndUpdateStats(
      BuildContext context, User authenticatedUser) async {
    try {
      await totalExamStats(context, authenticatedUser);
      await averageStats(context, authenticatedUser);
      await allExamStudent(context, authenticatedUser);
    } catch (e) {
      print('\nErrore during fetchDataAndUpdateStats() $e');
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

      // Aggiorna il provider con le statistiche totali degli esami dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalStatsExamStudent(totalExamStudent);
    } catch (e) {
      print('\nErrore during _totalExamStats() $e');
    }
  }

  /// Ottiene e imposta le statistiche medie degli esami dello studente.
  static Future<void> averageStats(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Ottiene la media aritmetica degli esami dello studente.
      final aritmeticAverageStudent = await totalExamController.averageStudent(
          context, authenticatedUser, "A");

      // Ottiene la media ponderata degli esami dello studente.
      final weightedAverageStudent = await totalExamController.averageStudent(
          context, authenticatedUser, "P");

      // Aggiorna il provider con le statistiche medie degli esami dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalAverageExamStudent(
          aritmeticAverageStudent, weightedAverageStudent);
    } catch (e) {
      print('\nErrore during _averageStats() $e');
    }
  }

  /// Ottiene e imposta tutti gli esami dello studente.
  static Future<void> allExamStudent(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Ottiene tutti gli esami dello studente.
      final allExamStudent = await totalExamController.fetchAllExamStudent(
          authenticatedUser, context);

      // Aggiorna il provider con tutti gli esami dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllExamStudent(allExamStudent);
    } catch (e) {
      print('\nErrore during _allExamStudent() $e');
    }
  }

  /// Ottiene e imposta tutti i corsi dello studente.
  static Future<void> allCourseStudent(
      BuildContext context, User? authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Ottiene tutti i corsi dello studente.
      final allCourseStudent = await totalExamController.fetchAllCourseStudent(
          authenticatedUser!, context);

      // Aggiorna il provider con tutti i corsi dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllCoursesStudent(allCourseStudent);

      // Ottiene e imposta lo stato di tutti i corsi dello studente.
      allStatusCourse(context, authenticatedUser, allCourseStudent);
    } catch (e) {
      print('\nErrore during _allCourseStudent() $e');
    }
  }

  /// Ottiene e imposta lo stato di tutti i corsi dello studente.
  static Future<void> allStatusCourse(BuildContext context,
      User authenticatedUser, List<CourseInfo> allCourses) async {
    final StudentController totalExamController = StudentController();
    try {
      // Ottiene lo stato di tutti i corsi dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      Map<String, StatusCourse> statusCoursesMap = await totalExamController
          .fetchAllCourseStatus(authenticatedUser, allCourses, context);

      // Converte la mappa in una lista e aggiorna il provider con lo stato dei corsi.
      examDataProvider.setAllStatusCourses(statusCoursesMap.values.toList());
      examDataProvider.setStatusCoursesMap(statusCoursesMap);
    } catch (e) {
      print('\nErrore durante _allStatusCourse() $e');
    }
  }

  /// Ottiene e imposta le informazioni sulle tasse dello studente.
  static Future<void> taxesStudent(
      BuildContext context, User authenticatedUser) async {
    final StudentController totalTaxesController = StudentController();
    try {
      // Ottiene e imposta le informazioni sulle tasse dello studente.
      final allTaxesStudent =
          await totalTaxesController.setTaxes(context, authenticatedUser);

      // Aggiorna il provider con le informazioni sulle tasse dello studente.
      final taxesDataProvider =
          Provider.of<TaxesDataProvider>(context, listen: false);
      taxesDataProvider.setTaxesInfo(allTaxesStudent);
    } catch (e) {
      print('\nError during _taxesStudent: $e');
    }
  }

  /// Ottiene e imposta tutti gli eventi dell'università.
  static Future<void> allEvents(BuildContext context) async {
    final UniServiceController eventController = UniServiceController();

    try {
      // Ottiene tutti gli eventi dell'università.
      final allEvents = await eventController.getAllEvents(context);

      // Aggiorna il provider con tutti gli eventi dell'università.
      final eventsDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      eventsDataProvider.setAllEvents(allEvents);
    } catch (e) {
      print('\nErrore during allEvents() $e');
    }
  }

  /// Ottiene e imposta tutte le stanze disponibili per oggi.
  static Future<List<AllTodayRooms>> allRooms(BuildContext context) async {
    final UniServiceController roomController = UniServiceController();

    try {
      // Ottiene tutte le stanze disponibili per oggi.
      final allrooms = await roomController.getAllTodayRoom(context);

      // Aggiorna il provider con tutte le stanze disponibili.
      final roomsDataProvider =
          Provider.of<RoomsProvider>(context, listen: false);
      roomsDataProvider.setAllTodayRooms(allrooms);

      return allrooms;
    } catch (e) {
      print('\nErrore durante allRooms() $e');
      rethrow; // Rilancia l'eccezione per gestirla ulteriormente se necessario.
    }
  }

  /// Ottiene e imposta tutte le prenotazioni dello studente.
  static Future<void> allReservationStudent(
      BuildContext context, User? authenticatedUser) async {
    final StudentController totalExamController = StudentController();
    try {
      // Ottiene tutte le prenotazioni dello studente.
      final allReservationStudent = await totalExamController
          .fetchAllReservationStudent(authenticatedUser!, context);

      // Aggiorna il provider con tutte le prenotazioni dello studente.
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllReservationStudent(allReservationStudent);
    } catch (e) {
      print('\nErrore during _allReservationStudent() $e');
    }
  }
}
