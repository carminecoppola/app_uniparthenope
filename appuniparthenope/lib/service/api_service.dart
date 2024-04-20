import 'dart:convert';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
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
    final String persId = student.persId
        .toString(); //Poiche nell'url deve essere una stringa faccio il cast
    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/general/anagrafica/$persId');

    print('\n-API-url: $url');
    print('\n-API-authToken: ${student.authToken}');
    

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${student.authToken}',
    });

    print('\nAPI-Response:$response');
    print('Status:${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('\n\n-API-Data: $data');
      return data;
    } else {
      throw Exception('Errore durante l\'anagrafica');
    }
  }

}
