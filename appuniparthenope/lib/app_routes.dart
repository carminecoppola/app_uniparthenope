import 'package:appuniparthenope/screens/InfoAppPage.dart';
import 'package:appuniparthenope/screens/dottorandi/homePhD.dart';
import 'package:appuniparthenope/screens/personalCardPage.dart';
import 'package:appuniparthenope/screens/pta/libraryHome.dart';
import 'package:appuniparthenope/screens/home.dart';
import 'package:appuniparthenope/screens/pta/homePTA.dart';
import 'package:appuniparthenope/screens/pta/libraryService/registrationForm.dart';
import 'package:appuniparthenope/screens/pta/libraryService/viewAllAccess.dart';
import 'package:appuniparthenope/screens/resturant/homeResturant.dart';
import 'package:appuniparthenope/screens/student/CheckAppello.dart';
import 'package:appuniparthenope/screens/student/CourseStudent.dart';
import 'package:appuniparthenope/screens/WeatherPage.dart';
import 'package:appuniparthenope/screens/student/CareerStudent.dart';
import 'package:appuniparthenope/screens/student/ReservationStudent.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CourseWidget/professor/SessionsAvailableProfessorCourses.dart';
import 'package:flutter/material.dart';
import 'screens/guest/homeGuest.dart';
import 'screens/loginpage.dart';
import 'screens/personalProfile.dart';
import 'screens/student/FeesStudent.dart';
import 'screens/teacher/ClassroomTeachers.dart';
import 'screens/teacher/CourseTeachers.dart';
import 'screens/teacher/EventsTeachers.dart';

class AppRoutes {
  static const String loginPage = '/loginPage';
  static const String infoAppPage = '/infoAppPage';
  static const String qrCodePage = '/qrCodePage';
  static const String watherPage = '/watherPage';

  //Role
  static const String home = '/homePage';
  static const String homePTA = '/homePTA';
  static const String homeResturant = '/homeResturant';
  static const String homePhD = '/homePhD';
  static const String homeGuest = '/homeGuest';

  //Student roots
  static const String profileStudent = '/profileStudent';
  static const String carrerStudent = '/carrerStudent';
  static const String courseStudent = '/courseStudent';
  static const String feesStudent = '/feesStudent';
  static const String reservationStudent = '/reservationStudent';
  static const String checkappelloStudent = '/checkappelloStudent';

  //Teachers roots
  static const String classroomTeachers = '/classroomTeachers';
  static const String eventsTeachers = '/eventsTeachers';
  static const String courseTeachers = '/courseTeachers';
  static const String sessionsAvailableProfessorCourses = '/sessAvProfCourses';

  //Library roots
  static const String libraryPage = '/libraryPage';
  static const String registrationLibrary = '/registrationLibrary';
  static const String viewAllAccessLibrary = '/viewAllAccessLibrary';

  static final Map<String, WidgetBuilder> routes = {
    loginPage: (context) => const LoginForm(),
    infoAppPage: (context) => const InfoAppPage(),
    qrCodePage: (context) => const PersonalCardPage(),

    //Role
    home: (context) => const HomePage(),
    homePTA: (context) => const PTAHomePage(),
    homeResturant: (context) => const HomeRestaurateursPage(),
    homePhD: (context) => const HomePhDPage(),
    homeGuest: (context) => const HomeGuestPage(),

    //Student roots
    profileStudent: (context) => const PersonalProfilePage(),
    carrerStudent: (context) => const StudentCarrerPage(),
    reservationStudent: (context) => const ReservationPage(),
    checkappelloStudent: (context) => const CheckAppelloPage(),
    courseStudent: (context) => const CourseStudentPage(),
    feesStudent: (context) => const FeesUniStudentPage(),
    watherPage: (context) => const WeatherUniPage(),

    //Teachers roots
    classroomTeachers: (context) => const ClassroomTeacherPage(),
    eventsTeachers: (context) => const EventsTeachersPage(),
    courseTeachers: (context) => const CoursesTeachersPage(),
    sessionsAvailableProfessorCourses: (context) =>
        const SessionsAvailableProfessorCourses(),

    //Library roots
    libraryPage: (context) => const LibraryPage(),
    registrationLibrary: (context) => const RegistrationForm(),
    viewAllAccessLibrary: (context) => const AccessLogsTable(),
  };
}
