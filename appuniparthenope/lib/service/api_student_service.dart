import 'dart:convert';
import 'package:appuniparthenope/model/studentService/calendar_data.dart';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/model/studentService/exam_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:provider/provider.dart';


class ApiStudentService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<Map<String, dynamic>> studentTotalExamsStats(
      User student, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String matId = selectedCareer['matId'].toString();
    final String password = authProvider.password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/students/totalExams/$matId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del server durante il caricamento delle statistiche dello studente');
    } else {
      throw Exception('Errore durante caricamento statistiche studente');
    }
  }

  Future<Map<String, dynamic>> studentAverage(
      BuildContext context, User student, String averageType) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String matId = selectedCareer['matId'].toString();
    final String password = authProvider.password!;

    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/average/$matId/$averageType');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('\n\n-API-Data Average $averageType: $data');
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del server durante il caricamento della media $averageType dello studente');
    } else {
      throw Exception('Errore durante caricamento della media studente');
    }
  }

  Future<List<ExamData>> getStudentExams(
      User student, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String matId = selectedCareer['matId'].toString();
    final String password = authProvider.password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v2/students/myExams/$matId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      print('\nallExam:\n $jsonData');
      return jsonData.map((data) => ExamData.fromJson(data)).toList();
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento degli esami dello studente');
    } else {
      throw Exception('Errore durante caricamento esami dello studente');
    }
  }

  Future<Map<String, dynamic>> getPianoId(
      User student, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String stuId = selectedCareer['stuId'].toString();
    final String password = authProvider.password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/students/pianoId/$stuId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final pianoId = jsonDecode(response.body);
      return pianoId;
    } else if (response.statusCode == 500) {
      throw Exception('Errore del SERVER durante il caricamento di pianoId');
    } else {
      throw Exception('Errore durante caricamento del pianoId');
    }
  }

  Future<List<CourseInfo>> getAllCourse(
      User student, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String stuId = selectedCareer['stuId'].toString();
    final String password = authProvider.password!;

    final pianoIdMap = await getPianoId(
        student, context); // Attendi il completamento del Future
    final pianoId = pianoIdMap['pianoId']
        .toString(); // Ottieni il pianoId dalla mappa restituita

    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/exams/$stuId/$pianoId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      print('\n allCourse:\n $jsonData');
      return jsonData.map((data) => CourseInfo.fromJson(data)).toList();
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento dei corsi dello studente');
    } else {
      throw Exception('Errore durante caricamento dei corsi dello studente');
    }
  }

  Future<StatusCourse> getStatusExam(
      User student, CourseInfo course, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String matId = selectedCareer['matId'].toString();
    final String adsceId = course.adsceId.toString();
    final String password = authProvider.password!;

    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/checkExams/$matId/$adsceId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final statusExamData = jsonDecode(response.body);
      final statusCourse = StatusCourse.fromJson(statusExamData);
      return statusCourse;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento dello status dell\'esame');
    } else {
      throw Exception('Errore durante caricamento del status esame');
    }
  }

  Future<List<LecturesInfo>> getLectures(
      User student, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String matId = selectedCareer['matId'].toString();
    final String password = authProvider.password!;

    final url = Uri.parse('$baseUrl/GAUniparthenope/v1/getLectures/$matId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      LecturesInfo.fromJson(data);
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento delle lezioni dello studente');
    } else {
      throw Exception('Errore durante caricamento delle lezioni');
    }
  }
}
