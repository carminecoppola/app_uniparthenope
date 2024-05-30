import 'package:appuniparthenope/screens/InfoAppPage.dart';
import 'package:appuniparthenope/screens/dottorandi/homePhD.dart';
import 'package:appuniparthenope/screens/guest/homeGuest.dart';
import 'package:appuniparthenope/screens/home.dart';
import 'package:appuniparthenope/screens/loadingpage.dart';
import 'package:appuniparthenope/screens/resturant/homeResturant.dart';
import 'package:appuniparthenope/screens/student/CourseStudent.dart';
import 'package:appuniparthenope/screens/student/FeesUniStudent.dart';
import 'package:appuniparthenope/screens/WeatherPage.dart';
import 'package:appuniparthenope/screens/student/CareerStudent.dart';
import 'package:flutter/material.dart';
import 'screens/loginpage.dart';
import 'screens/personalProfile.dart';
import 'screens/qrCodePage.dart';
import 'screens/teacher/ClassroomTeachers.dart';
import 'screens/teacher/CourseTeachers.dart';
import 'screens/teacher/EventsTeachers.dart';

class AppRoutes {
  static const String loadingPage = '/loadingFirstPage';
  static const String loginPage = '/loginPage';
  static const String infoAppPage = '/infoAppPage';
  static const String qrCodePage = '/qrCodePage';
  //Role
  static const String home = '/homePage';
  static const String homeResturant = '/homeResturant';
  static const String homePhD = '/homePhD';
  static const String homeGuest = '/homeGuest';

  //Student roots
  static const String profileStudent = '/profileStudent';
  static const String carrerStudent = '/carrerStudent';
  static const String courseStudent = '/courseStudent';
  static const String feesStudent = '/feesStudent';
  static const String watherPage = '/watherPage';

  //Teachers roots
  static const String classroomTeachers = '/classroomTeachers';
  static const String eventsTeachers = '/eventsTeachers';
  static const String courseTeachers = '/courseTeachers';

  static final Map<String, WidgetBuilder> routes = {
    loadingPage: (context) => const LoadingFristPage(),
    loginPage: (context) => const LoginForm(),
    infoAppPage: (context) => const InfoAppPage(),
    qrCodePage: (context) => const QRCodePage(),

    //Role
    home: (context) => const HomePage(),
    homeResturant: (context) => const HomeRestaurateursPage(),
    homePhD: (context) => const HomePhDPage(),
    homeGuest: (context) => HomeGuestPage(),

    //Student roots
    profileStudent: (context) => const PersonalProfilePage(),
    carrerStudent: (context) => const StudentCarrerPage(),
    courseStudent: (context) => const CourseStudentPage(),
    feesStudent: (context) => const FeesUniStudentPage(),
    watherPage: (context) => const WeatherUniPage(),

    //Teachers roots
    classroomTeachers: (context) => const ClassroomTeacherPage(),
    eventsTeachers: (context) => const EventsTeachersPage(),
    courseTeachers: (context) => const CoursesTeachersPage(),
  };
}
