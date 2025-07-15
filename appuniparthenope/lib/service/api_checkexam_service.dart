import 'dart:convert';
import 'package:appuniparthenope/model/studentService/student_course_data.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:provider/provider.dart';

import '../model/studentService/check_appello_data.dart';
import '../provider/check_exam_provider.dart';
import '../provider/exam_provider.dart';

class ApiCheckExamService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<List<CheckAppello>> getAppelliStudent(
      User student, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;
    final password = authProvider.password;
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);

    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }

    String cdsId = selectedCareer['cdsId'].toString();
    List<CourseInfo>? courseList = examProvider.allCourseStudent;
    print('getAppelliStudent(): cdsId: $cdsId, n.corsi: ${courseList?.length}');

    List<CheckAppello> allAppelli = [];

    if (courseList != null && courseList.isNotEmpty) {
      for (final course in courseList) {
        String adId = course.adId.toString(); // <-- ID corretto!
        print('Check appello per corso: ${course.nome}, adId: $adId');

        final url = Uri.parse(
            '$baseUrl/UniparthenopeApp/v1/students/checkAppello/$cdsId/$adId');

        final response = await http.get(url, headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
        });

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData is List) {
            allAppelli.addAll(jsonData
                .map<CheckAppello>((data) => CheckAppello.fromJson(data)));
          } else if (jsonData != null) {
            allAppelli.add(CheckAppello.fromJson(jsonData));
          }
        } else {
          print(
              'Errore API su esame ${course.nome} (adId: $adId): status ${response.statusCode}');
        }
      }
      return allAppelli;
    } else {
      // Nessun corso trovato
      return [];
    }
  }

  Future<bool> bookExamAppello(BuildContext context, User student) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final selectedCareer = authProvider.selectedCareer;
    final password = authProvider.password;
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    final checkExamProvider = Provider.of<CheckDateExamProvider>(context, listen: false)
        
    if (selectedCareer == null) {
      throw Exception('Nessuna carriera selezionata trovata');
    }
    String cdsId = selectedCareer['cdsId'].toString();
    List<CheckAppello> listofAppelli = checkExamProvider.allAppelliStudent;
    

    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/bookExam/$cdsId/$adId/$appId');

    final response = await http.post(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
      'Content-Type': 'application/json', // metti comunque
    });

    if (response.statusCode == 200) {
      // Prenotazione avvenuta con successo
      return true;
    } else {
      print('Errore POST prenotazione esame: status ${response.statusCode}');
      print('Body: ${response.body}');
      return false;
    }
  }
}
