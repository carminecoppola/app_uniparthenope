import 'dart:convert';
import 'dart:typed_data';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl = "https://api.uniparthenope.it";

  Future<Map<String, dynamic>> login(
      String username, String password, BuildContext context) async {
    final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/login');
    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("$username:$password"))}',
    });
    print('Stato: ${response.statusCode}');
    print('Response API:${response.body}');

    if (response.statusCode == 200) {
      // Conversione della risposta JSON in una mappa di stringhe dynamiche
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else if (response.statusCode == 401) {
      throw Exception('Errore Credenziali Invalide');
      //Mostra una modale
    } else if (response.statusCode == 500) {
      throw Exception('Errore del server durante il login');
    } else {
      throw Exception('Errore durante il login');
    }
  }

  Future<Map<String, dynamic>> studentAnagrafe(
      User student, BuildContext context) async {
    final String persId = student.persId.toString();
    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/general/anagrafica/$persId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    print('Status:${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('\n\n-API-Data: $data');
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del server durante il caricamento dei dati anagrafici');
    } else {
      throw Exception('Errore durante l\'anagrafica');
    }
  }

  Future<Uint8List> getUserProfileImage(
      User student, BuildContext context) async {
    final String persId = student.persId.toString();

    final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/general/image/$persId');

    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer ${Provider.of<AuthProvider>(context, listen: false).authToken}',
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

  Future<Map<String, dynamic>> getTaxes(
      User student, BuildContext context) async {
    final String persId = student.persId.toString();

     final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/students/taxes/$persId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      final allTaxes = jsonDecode(response.body);
      print('\n allTaxes:\n $allTaxes');
      return allTaxes;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento delle tasse dello studente');
    } else {
      throw Exception('\nErrore durante caricamento delle tasse studente');
    }
  }
}
