import 'package:appuniparthenope/screens/info_app_page.dart';
import 'package:appuniparthenope/screens/dottorandi/home_ph_d.dart';
import 'package:appuniparthenope/screens/personal_card_page.dart';
import 'package:appuniparthenope/screens/pta/library_home.dart';
import 'package:appuniparthenope/screens/home.dart';
import 'package:appuniparthenope/screens/pta/home_pta.dart';
import 'package:appuniparthenope/screens/pta/libraryService/registration_form.dart';
import 'package:appuniparthenope/screens/pta/libraryService/view_all_access.dart';
import 'package:appuniparthenope/screens/resturant/home_resturant.dart';
import 'package:appuniparthenope/screens/student/check_appello.dart';
import 'package:appuniparthenope/screens/student/course_student.dart';
import 'package:appuniparthenope/screens/weather_page.dart';
import 'package:appuniparthenope/screens/student/career_student.dart';
import 'package:appuniparthenope/screens/student/reservation_student.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CourseWidget/professor/sessions_available_professor_courses.dart';
import 'package:flutter/material.dart';
import 'screens/guest/home_guest.dart';
import 'screens/loginpage.dart';
import 'screens/personal_profile.dart';
import 'screens/student/fees_student.dart';
import 'screens/teacher/classroom_teachers.dart';
import 'screens/teacher/course_teachers.dart';
import 'screens/teacher/events_teachers.dart';

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
