import 'package:appuniparthenope/screens/student/homeStudent.dart';
import 'package:appuniparthenope/screens/student/profileStudent.dart';
import 'package:appuniparthenope/screens/teacher/homeTeacher.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String homeStudent = '/homeStudent';
  static const String homeTeacher = '/homeTeacher';
  static const String profileStudent = '/profileStudent';

  static final Map<String, WidgetBuilder> routes = {
    homeStudent: (context) => const HomeStudentPage(),
    homeTeacher: (context) => const HomeTeacherPage(),
    //Rotte xx altri ruoli
    //....
    //....
    profileStudent: (context) => const StudentProfilePage(),

  };
}