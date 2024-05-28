import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../model/teacherService/course_professr_data.dart';
import '../model/user_data_login.dart';
import '../provider/auth_provider.dart';

class ApiTeacherService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<List<CourseProfessorInfo>> getAllCourse(
      User professor, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String password = authProvider.password!;
    final aaId = 2023;

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
}
