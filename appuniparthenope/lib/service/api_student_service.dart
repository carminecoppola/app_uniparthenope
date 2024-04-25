import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appuniparthenope/model/user_data_login.dart';

class ApiStudentService {
  final String baseUrl = "https://api.uniparthenope.it";

  /*Funzione che mi restituisce il totale degli esami:
    - Url di collegamento : /UniparthenopeApp/v1/students/totalExams/{matId}
    - Restituisce il TotExam, CFU ecc...
    - Parametri da passare:
        - {matId}
        - utente loggato {username}{password} che si trovano nella 
          classe User che posso recuperare dall'_authenticatedUser
  */

  Future<Map<String, dynamic>> studentTotalExams(User student) async {
    //Quando sarà giusto il modello utente
    //final String matId = student.trattiCarriera['matId'];

    const String matId = "253073"; //Il mio codice matId per test

    final url =
        Uri.parse('$baseUrl/UniparthenopeApp/v1/students/totalExams/$matId');

    final response = await http.get(url, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode("${student.username}:${student.password}"))}',
    });

    print('\nSono nell API, URL: ${url}');

    print('- API: studentTotalExams Status:${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('\n\n-API-Data: $data');
      return data;
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del server durante il caricamento del totale degli esami dello studente');
    } else {
      throw Exception('\nErrore durante il totale degli esami studente');
    }
  }
}
