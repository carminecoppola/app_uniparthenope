import 'dart:convert';
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

  // Aggiungi questa funzione nella classe ApiService per gestire il logout
  Future<void> logout(String authToken) async {
    try {
      final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/logout');
      final response = await http.get(url, headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode("$authToken:"))}',
      });

      print('-1)API-Logout-authToken: $authToken');

      if (response.statusCode == 200) {
        print('Logout effettuato con successo');
        print('-2)API-Logout-authToken: $authToken');
      } else {
        print('Errore durante il logout: ${response.body}');
      }
    } catch (e) {
      print('Errore durante il logout: $e');
    }
  }

  //Funzione per ottenere l'anagrafica
  Future<Map<String, dynamic>> getUserDetails(User user) async {
    print('-API-PersId:${user.persId}');
    print('-API-Token:${user.authToken}');

    final String id =
        user.persId.toString(); //Converto l'id in stringa xx passarlo all'url

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/general/anagrafica/$id');

    print('\nAPI-url: $url');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${user.authToken}:"))}',
    });

    print('\n-API-Status: ${response.statusCode}');
    print('\n\n-API-response:${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print('Errore durante la richiesta: ${response.body}');
      throw Exception('Errore durante il recupero dei dettagli dell\'utente');
    }
  }
}
