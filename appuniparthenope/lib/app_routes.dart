import 'package:appuniparthenope/screens/dottorandi/homePhD.dart';
import 'package:appuniparthenope/screens/guest/homeGuest.dart';
import 'package:appuniparthenope/screens/loadingpage.dart';
import 'package:appuniparthenope/screens/resturant/homeResturant.dart';
import 'package:appuniparthenope/screens/student/services/CourseStudent.dart';
import 'package:appuniparthenope/screens/student/services/FeesUniStudent.dart';
import 'package:appuniparthenope/screens/student/services/WatherStudent.dart';
import 'package:appuniparthenope/screens/student/homeStudent.dart';
import 'package:appuniparthenope/screens/student/services/myCarrer.dart';
import 'package:appuniparthenope/screens/student/services/profileStudent.dart';
import 'package:appuniparthenope/screens/teacher/homeTeacher.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loadingPage = '/loadingFirstPage';
  //Role
  static const String homeStudent = '/homeStudent';
  static const String homeTeacher = '/homeTeacher';
  static const String homeResturant = '/homeResturant';
  static const String homePhD = '/homePhD';
  static const String homeGuest = '/homeGuest';

  //Student roots
  static const String profileStudent = '/profileStudent';
  static const String carrerStudent = '/carrerStudent';
  static const String courseStudent = '/courseStudent';
  static const String feesStudent = '/feesStudent';
  static const String watherStudent = '/watherStudent';

  static final Map<String, WidgetBuilder> routes = {
    loadingPage: (context) => const LoadingFristPage(),

    //Role
    homeStudent: (context) => const HomeStudentPage(),
    homeTeacher: (context) => const HomeTeacherPage(),
    homeResturant: (context) => const HomeRestaurateursPage(),
    homePhD: (context) => const HomePhDPage(),
    homeGuest: (context) => const HomeGuestPage(),

    //Student roots
    profileStudent: (context) => const StudentProfilePage(),
    carrerStudent: (context) => const StudentCarrerPage(),
    courseStudent: (context) => const CourseStudentPage(),
    feesStudent: (context) => const FeesUniStudentPage(),
    watherStudent: (context) => const WatherUniPage(),
  };
}
