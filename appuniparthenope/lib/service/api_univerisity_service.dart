import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/studentService/events_data.dart';
import '../model/teacherService/room_data.dart';
import '../provider/auth_provider.dart';

class ApiUniversityService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<List<EventsInfo>> getEvents(BuildContext context) async {
    final url = Uri.parse('$baseUrl/GAUniparthenope/v1/getEvents');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('\n\njsonData: $jsonData');

      return jsonData.map((data) => EventsInfo.fromJson(data)).toList();
    } else if (response.statusCode == 500) {
      throw Exception('Errore del SERVER durante il caricamento degli eventi');
    } else {
      throw Exception('\nErrore durante caricamento degli eventi');
    }
  }

  Future<List<AllTodayRooms>> getAllTodayRoom(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String password = authProvider.password!;
    final userId = authProvider.authenticatedUser!.user.userId;

    final url = Uri.parse('$baseUrl/GAUniparthenope/v2/getAllTodayRooms');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("$userId:$password"))}',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('\n\njsonData: $jsonData');

      return jsonData.map((data) => AllTodayRooms.fromJson(data)).toList();
    } else if (response.statusCode == 500) {
      throw Exception('Errore del SERVER durante il caricamento delle aule');
    } else {
      throw Exception('\nErrore durante caricamento deglle aule');
    }
  }
}
