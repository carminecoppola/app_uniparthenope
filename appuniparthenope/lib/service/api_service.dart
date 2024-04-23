import 'dart:convert';
import 'dart:typed_data';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/login');
    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("$username:$password"))}',
    });

    if (response.statusCode == 200) {
      // Conversione della risposta JSON in una mappa di stringhe dynamiche
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Errore durante il login');
    }
  }

  Future<Map<String, dynamic>> studentAnagrafe(User student) async {
    final String persId = student.persId.toString();
    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/general/anagrafica/$persId');

    // print('\n-API-url: $url');
    // print('\n-API-authToken: ${student.authToken}');

    //final String basicAuth = base64Encode(utf8.encode("${student.username}:$password"));

    // const String username = 'carmine.coppola';
    // const String password = 'CppCmn01_';
    // String username = student.username;
    // String password = student.password;
    // print('\nUser: ${student.username}, $password');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.username}:${student.password}"))}',
    });

    print('Status:${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('\n\n-API-Data: $data');
      return data;
    } else {
      throw Exception('Errore durante l\'anagrafica');
    }
  }

  Future<Uint8List> getUserProfileImage(User student) async {
    final String persId = student.persId.toString();

    final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/general/image/$persId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${student.authToken}',
      },
    );

    if (response.statusCode == 200) {
      // Converti il corpo della risposta in Uint8List (formato immagine)
      Uint8List bytes = response.bodyBytes;
      return bytes;
    } else {
      throw Exception('Errore durante il recupero dell\'immagine');
    }
  }
}
