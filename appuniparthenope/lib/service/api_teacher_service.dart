import 'dart:convert';
import 'package:appuniparthenope/model/teacherService/session_professor_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../model/teacherService/check_exam_data.dart';
import '../model/teacherService/course_professor_data.dart';
import '../model/user_data_login.dart';
import '../provider/auth_provider.dart';

class ApiTeacherService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<List<CourseProfessorInfo>> getAllCourse(
      User professor, int aaId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String password = authProvider.password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/professor/getCourses/$aaId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${professor.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData
          .map((data) => CourseProfessorInfo.fromJson(data))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento dei corsi del professore');
    } else {
      throw Exception('Errore durante caricamento dei corsi del professore');
    }
  }

  Future<SessionProfessorInfo> getSession(
      User professor, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String password = authProvider.password!;

    final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/professor/getSession');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${professor.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return SessionProfessorInfo.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento della sessione attuale del professore');
    } else {
      throw Exception(
          'Errore durante caricamento della sessione attuale del professore');
    }
  }

  Future<DetailsCourseInfo> getDetailsCourse(
      User professor, int adLogId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String password = authProvider.password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/general/infoCourse/$adLogId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${professor.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('\ngetDetailsCourse(): $jsonData');
      return DetailsCourseInfo.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento delle informazioni dei corsi del professore');
    } else {
      throw Exception(
          'Errore durante caricamento delle informazioni dei corsi del professore');
    }
  }

  Future<List<CheckExamInfo>> getCheckExamInfo(
      User professor, int cdsId, int adId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String password = authProvider.password!;

    final url = Uri.parse(
        '$baseUrl/UniparthenopeApp/v1/students/checkAppello/$cdsId/$adId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${professor.userId}:$password"))}',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((data) => CheckExamInfo.fromJson(data)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento degli appelli del professore');
    } else {
      throw Exception(
          'Errore durante caricamento degli appelli del professore');
    }
  }
}
