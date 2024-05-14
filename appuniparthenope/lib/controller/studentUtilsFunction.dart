import 'package:appuniparthenope/provider/taxes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import '../controller/exam_controller.dart';
import '../model/studentService/course_data.dart';
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

      for (CourseInfo course in allCourses) {
        List<StatusCourse> statusCourses = await totalExamController
            .fetchAllCourseStatus(authenticatedUser, [course], context);

        // Assicurati che lo stato del corso sia disponibile
        if (statusCourses.isNotEmpty) {
          // Aggiungi lo stato del corso all'elenco in ExamDataProvider
          examDataProvider.setAllStatusCourses(
              [...examDataProvider.allStatusCourses ?? [], ...statusCourses]);
        }
      }
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
      print('\nError during _userImg(): $e');
    }
  }

  static Future<void> allEvents(BuildContext context) async {
    final ExamController eventController = ExamController();

    try {
      final allEvents = await eventController.getAllEvents(context);
      final eventsDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      eventsDataProvider.setAllEvents(allEvents);
    } catch (e) {
      print('\nErrore during allEvents() $e');
    }
  }
}
