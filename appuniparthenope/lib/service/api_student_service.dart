import 'dart:convert';
import 'package:appuniparthenope/model/course_data.dart';
import 'package:appuniparthenope/model/exam_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:provider/provider.dart';

class ApiStudentService {
  final String baseUrl = "https://api.uniparthenope.it";

  /*Funzione che mi restituisce il totale degli esami:
    - Url di collegamento : /UniparthenopeApp/v1/students/totalExams/{matId}
    - Restituisce il TotExam, CFU ecc...
    - Parametri da passare:
        - {matId}
        - utente loggato {username}{password} che si trovano nella 
          classe User che posso recuperare dall'_authenticatedUser
  */

  Future<Map<String, dynamic>> studentTotalExamsStats(
      User student, BuildContext context) async {
    String matId = student.trattiCarriera[0].matId.toString();

    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/students/totalExams/$matId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      //print('\n\n-API-Data: $data');
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del server durante il caricamento delle statistiche dello studente');
    } else {
      throw Exception('\nErrore durante caricamento statistiche studente');
    }
  }

  Future<List<ExamData>> getStudentExams(
      User student, BuildContext context) async {
    String matId = student.trattiCarriera[0].matId.toString();

    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v2/students/myExams/$matId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      print('\nallExam:\n $jsonData');
      return jsonData.map((data) => ExamData.fromJson(data)).toList();
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento degli esami dello studente');
    } else {
      throw Exception('\nErrore durante caricamento esami dello studente');
    }
  }

  //Mi serve per altre chiamate API come quella per ottenere tutti corsi
  Future<Map<String, dynamic>> getPianoId(
      User student, BuildContext context) async {
    String stuId = student.trattiCarriera[0].stuId.toString();

    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/students/pianoId/$stuId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      final pianoId = jsonDecode(response.body);
      print('\n pianoId: $pianoId');
      return pianoId;
    } else if (response.statusCode == 500) {
      throw Exception('Errore del SERVER durante il caricamento di pianoId');
    } else {
      throw Exception('\nErrore durante caricamento del pianoId');
    }
  }

  Future<List<CourseInfo>> getAllCourse(
      User student, BuildContext context) async {
    String stuId = student.trattiCarriera[0].stuId.toString();

    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final pianoIdMap = await getPianoId(
        student, context); // Attendi il completamento del Future
    final pianoId = pianoIdMap['pianoId']
        .toString(); // Ottieni il pianoId dalla mappa restituita

    print('pianoId: $pianoId');

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
      throw Exception('\nErrore durante caricamento dei corsi dello studente');
    }
  }

  //Mi serve per gestire lo stato dei corsi
  Future<StatusCourse> getStatusExam(
      User student, CourseInfo course, BuildContext context) async {
    String matId = student.trattiCarriera[0].matId.toString();
    final String adsceId = course.adsceId.toString();

    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/checkExams/$matId/$adsceId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      final statusExamData = jsonDecode(response.body);
      final statusCourse = StatusCourse.fromJson(statusExamData);
      print('\n statusExam: $statusCourse');
      return statusCourse;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento dello status dell\'esame');
    } else {
      throw Exception('\nErrore durante caricamento del status esame');
    }
  }
}
