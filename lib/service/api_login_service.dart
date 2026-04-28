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

    if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> userAnagrafe(
      User student, BuildContext context) async {
    final String persId = student.persId.toString();
    final String docenteId = student.docenteId.toString();

    final String? userId = student.userId;
    final String password =
        Provider.of<AuthProvider>(context, listen: false).password!;

    final String id = student.grpDes == 'Docenti' ? docenteId : persId;
    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/general/anagrafica/$id');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("$userId:$password"))}',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del server durante il caricamento dei dati anagrafici');
    } else {
      throw Exception('Errore durante l\'anagrafica');
    }
  }

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
        throw Exception('Invalid role');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("${user.userId}:$password"))}',
          'Content-Type': 'image/jpg',
        },
      );

      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;

        if (Platform.isAndroid || Platform.isIOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String filePath =
              '${appDocDir.path}/profile_image_${user.userId}.jpg';

          File imageFile = File(filePath);
          await imageFile.writeAsBytes(imageData);

          bool fileExists = await imageFile.exists();

          if (fileExists) {
            return imageFile.path;
          } else {
            throw Exception('File not found in specified path');
          }
        } else {
          // Gestione web o altre piattaforme se necessario
          return '';
        }
      } else {
        throw Exception('Error retrieving image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error retrieving profile image');
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

      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;
        final contentType = response.headers['content-type'] ?? '';

        final looksLikeImage = contentType.startsWith('image/') ||
            _hasKnownImageSignature(imageData);
        if (!looksLikeImage || imageData.isEmpty) {
          throw Exception('QR-Code non valido ricevuto dal server');
        }

        final extension = contentType.contains('png') ? 'png' : 'jpg';

        // Ottieni la directory di salvataggio dell'applicazione
        Directory appDocDir = await getApplicationDocumentsDirectory();
        // Crea un nuovo file nell'applicazione directory
        File imageFile = File('${appDocDir.path}/my_qrCode.$extension');
        // Scrivi i byte dell'immagine nel file
        await imageFile.writeAsBytes(imageData);

        return imageFile.path;
      } else {
        throw Exception(
            'Errore durante il recupero del QR-Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Errore durante il recupero QR-Code personale');
    }
  }

  bool _hasKnownImageSignature(Uint8List bytes) {
    if (bytes.length < 4) return false;
    final isPng =
        bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47;
    final isJpeg = bytes[0] == 0xFF && bytes[1] == 0xD8;
    return isPng || isJpeg;
  }

  Future<void> deleteProfileImage() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/my_img.jpg';
      File imageFile = File(filePath);

      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      final qrJpg = File('${appDocDir.path}/my_qrCode.jpg');
      if (await qrJpg.exists()) {
        await qrJpg.delete();
      }

      final qrPng = File('${appDocDir.path}/my_qrCode.png');
      if (await qrPng.exists()) {
        await qrPng.delete();
      }
    } catch (_) {
      return;
    }
  }
}
