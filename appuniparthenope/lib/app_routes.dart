import 'dart:js';

import 'package:appuniparthenope/screens/dottorandi/homePhD.dart';
import 'package:appuniparthenope/screens/guest/homeGuest.dart';
import 'package:appuniparthenope/screens/resturant/homeResturant.dart';
import 'package:appuniparthenope/screens/student/homeStudent.dart';
import 'package:appuniparthenope/screens/student/profileStudent.dart';
import 'package:appuniparthenope/screens/teacher/homeTeacher.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  //Role
  static const String homeStudent = '/homeStudent';
  static const String homeTeacher = '/homeTeacher';
  static const String homeResturant = '/homeResturant';
  static const String homePhD = '/homePhD';
  static const String homeGuest = '/homeGuest';

  //Student roots
  static const String profileStudent = '/profileStudent';

  static final Map<String, WidgetBuilder> routes = {
    //Role
    homeStudent: (context) => const HomeStudentPage(),
    homeTeacher: (context) => const HomeTeacherPage(),
    homeResturant: (context) => const HomeRestaurateursPage(),
    homePhD: (context) => const HomePhDPage(),
    homeGuest: (context) => const HomeGuestPage(),
    

    //Student roots
    profileStudent: (context) => const StudentProfilePage(),
  };
}
