import 'dart:convert';
import 'dart:typed_data';
import 'package:appuniparthenope/model/user_data_login.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  // Ottieni l'immagine del profilo dell'utente dal server
  Future<String> userProfileImage(User user, BuildContext context) async {
    try {
      final String role = user.grpDes.toString();
      final String persId = user.persId.toString();
      final String idAb = user.idAb.toString();
      final String password =
          Provider.of<AuthProvider>(context, listen: false).password!;

      String url;
      if (role == 'Studenti') {
        url = '$baseUrl/UniparthenopeApp/v1/general/image/$persId';
      } else if (role == 'Docenti') {
        url = '$baseUrl/UniparthenopeApp/v1/general/image_prof/$idAb';
      } else {
        throw Exception('Ruolo non valido');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("${user.userId}:$password"))}',
          'Content-Type': 'image/jpg',
        },
      );

      print('Status userProfileImage(): ${response.statusCode}');

      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;

        Directory appDocDir = await getApplicationDocumentsDirectory();
        File imageFile = File('${appDocDir.path}/my_img.jpg');
        await imageFile.writeAsBytes(imageData);

        return imageFile.path;
      } else {
        throw Exception(
            'Errore durante il recupero dell\'immagine: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during userProfileImage: $e');
      throw Exception('Errore durante il recupero dell\'immagine di profilo');
    }
  }

  Future<String> userQRCode(User student, BuildContext context) async {
    try {
      final String password =
          Provider.of<AuthProvider>(context, listen: false).password!;
      final url = Uri.parse('$baseUrl/Badges/v2/generateQrCode');

      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("${student.userId}:$password"))}',
          'Content-Type': 'image/jpg',
        },
      );

      print('Status userQRCode(): ${response.statusCode}');

      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;

        // Ottieni la directory di salvataggio dell'applicazione
        Directory appDocDir = await getApplicationDocumentsDirectory();
        // Crea un nuovo file nell'applicazione directory
        File imageFile = File('${appDocDir.path}/my_qrCode.jpg');
        // Scrivi i byte dell'immagine nel file
        await imageFile.writeAsBytes(imageData);

        return imageFile.path;
      } else {
        throw Exception(
            'Errore durante il recupero del QR-Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during userQRCode: $e');
      throw Exception('Errore durante il recupero QR-Code personale');
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

  Future<void> logout(BuildContext context) async {
    try {
      final String authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken!;
      final url = Uri.parse('$baseUrl/UniparthenopeApp/v1/logout');

      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $authToken',
      });

      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.pushReplacementNamed(context, '/loginPage');
      } else if (response.statusCode == 500) {
        throw Exception('Errore nel Server durante il logout');
      } else if (response.statusCode == 401) {
        throw Exception('Auth Token is missing');
      } else {
        throw Exception('Errore durante il logout');
      }
    } catch (e) {
      throw Exception('Errore durante il logout: $e');
    }
  }
}
