import 'package:appuniparthenope/provider/rooms_provider.dart';
import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import '../controller/exam_controller.dart';
import '../controller/uniService_controller.dart';
import '../model/studentService/exam_data.dart';
import '../model/studentService/student_course_data.dart';
import '../model/teacherService/room_data.dart';
import '../model/user_data_login.dart';
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';

class StudentUtils {
  //Questa classe racchiude tutte le funzioni utili per i servizi studente

  static Future<void> anagrafeStudent(
      BuildContext context, User authenticatedUser) async {
    final AuthController authController = AuthController();

    try {
      final anagrafeUser =
          await authController.setAnagrafe(context, authenticatedUser);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAnagrafeUser(anagrafeUser);

      print(anagrafeUser);
    } catch (e) {
      print('Error during _setAnagrafe: $e');
    }
  }

  //Da controllare poichè inutilizzata
  static Future<void> fetchAnagrafeDataAndProfileImage(
      BuildContext context, User authenticatedUser) async {
    try {
      await anagrafeStudent(context, authenticatedUser);
      await userImg(context);
    } catch (e) {
      print('\nErrore during fetchAnagrafeDataAndProfileImage() $e');
    }
  }

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

  static Future<void> totalExamStats(
      BuildContext context, User authenticatedUser) async {
    final ExamController totalExamController = ExamController();
    try {
      final totalExamStudent = await totalExamController.totalExamStatsStudent(
          authenticatedUser, context);

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalStatsExamStudent(totalExamStudent);
    } catch (e) {
      print('\nErrore during _totalExamStats() $e');
    }
  }

  static Future<void> averageStats(
      BuildContext context, User authenticatedUser) async {
    final ExamController totalExamController = ExamController();
    try {
      final aritmeticAverageStudent = await totalExamController.averageStudent(
          context, authenticatedUser, "A");
      final weightedAverageStudent = await totalExamController.averageStudent(
          context, authenticatedUser, "P");

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalAverageExamStudent(
          aritmeticAverageStudent, weightedAverageStudent);
    } catch (e) {
      print('\nErrore during _averageStats() $e');
    }
  }

  static Future<void> allExamStudent(
      BuildContext context, User authenticatedUser) async {
    final ExamController totalExamController = ExamController();
    try {
      final allExamStudent = await totalExamController.fetchAllExamStudent(
          authenticatedUser, context);

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllExamStudent(allExamStudent);
    } catch (e) {
      print('\nErrore during _allExamStudent() $e');
    }
  }

  static Future<void> calculateGPA(
      BuildContext context, User authenticatedUser) async {
    final ExamController totalExamController = ExamController();
    try {
      final allExamStudent = await totalExamController.fetchAllExamStudent(
          authenticatedUser, context);

      // Filtra gli esami con esito diverso da 'S' e con voto non nullo
      List<ExamData> validExams = allExamStudent
          .where((exam) => exam.status.esito == 'S' && exam.status.voto != null)
          .toList();

      print('\validExams: ${validExams}');

      // Calcola il GPA
      double gpa = 0;
      int totalCFU = 0;
      for (ExamData exam in validExams) {
        gpa += exam.cfu! *
            exam.status
                .voto!; // Aggiunge il peso dell'esame moltiplicato per il voto
        totalCFU += exam.cfu!.toInt();
      }
      gpa /= totalCFU; // Dividi per il totale dei CFU per ottenere la media

      final gapDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      gapDataProvider.setGPA(gpa);

      print('\nGPA: ${gpa}');
    } catch (e) {
      print('\nErrore during calculateGPA() $e');
    }
  }

  static Future<void> allCourseStudent(
      BuildContext context, User? authenticatedUser) async {
    final ExamController totalExamController = ExamController();
    try {
      final allCourseStudent = await totalExamController.fetchAllCourseStudent(
          authenticatedUser!, context);

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllCoursesStudent(allCourseStudent);

      allStatusCourse(context, authenticatedUser, allCourseStudent);
    } catch (e) {
      print('\nErrore during _allCourseStudent() $e');
    }
  }

  static Future<void> allStatusCourse(BuildContext context,
      User authenticatedUser, List<CourseInfo> allCourses) async {
    final ExamController totalExamController = ExamController();
    try {
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      Map<String, StatusCourse> statusCoursesMap = await totalExamController
          .fetchAllCourseStatus(authenticatedUser, allCourses, context);

      // Converti la mappa in una lista e aggiorna il provider
      examDataProvider.setAllStatusCourses(statusCoursesMap.values.toList());
      examDataProvider.setStatusCoursesMap(statusCoursesMap);
    } catch (e) {
      print('\nErrore durante _allStatusCourse() $e');
    }
  }

  static Future<void> taxesStudent(
      BuildContext context, User authenticatedUser) async {
    final AuthController authController = AuthController();
    try {
      final allTaxesStudent =
          await authController.setTaxes(context, authenticatedUser);

      final taxesDataProvider =
          Provider.of<TaxesDataProvider>(context, listen: false);
      taxesDataProvider.setTaxesInfo(allTaxesStudent);
    } catch (e) {
      print('\nError during _taxesStudent: $e');
    }
  }

  static Future<void> userImg(BuildContext context) async {
    final AuthController authController = AuthController();
    try {
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
      if (authenticatedUser != null) {
        final profileImage = await authController.getUserProfileImage(
            authenticatedUser.user, context);

        // Utilizza il provider per impostare l'immagine di profilo
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setProfileImage(profileImage);
      } else {
        print('Authenticated user is null');
      }
    } catch (e) {
      print('\nError during userImg(): $e');
    }
  }

  static Future<void> qrCodeImg(BuildContext context) async {
    final AuthController authController = AuthController();
    try {
      final authenticatedUser =
          Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
      if (authenticatedUser != null) {
        final qrCode =
            await authController.getUserQRCode(authenticatedUser.user, context);

        // Utilizza il provider per impostare l'immagine di profilo
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setQRCode(qrCode);
      } else {
        print('Authenticated user is null');
      }
    } catch (e) {
      print('\nError during qrCodeImg(): $e');
    }
  }

  static Future<void> allEvents(BuildContext context) async {
    final UniServiceController eventController = UniServiceController();

    try {
      final allEvents = await eventController.getAllEvents(context);
      final eventsDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      eventsDataProvider.setAllEvents(allEvents);
    } catch (e) {
      print('\nErrore during allEvents() $e');
    }
  }

  static Future<List<AllTodayRooms>> allRooms(BuildContext context) async {
    final UniServiceController roomController = UniServiceController();

    try {
      final allrooms = await roomController.getAllTodayRoom(context);
      final roomsDataProvider =
          Provider.of<RoomsProvider>(context, listen: false);
      roomsDataProvider.setAllTodayRooms(allrooms);
      return allrooms;
    } catch (e) {
      print('\nErrore durante allRooms() $e');
      throw e;
    }
  }
}
