import 'dart:convert';

class ListStudentsExam {
  final int? adregId;
  final int? adsceId;
  final String? codFisStudente;
  final String? cognomeStudente;
  final String? matricola;
  final String? nomeStudente;
  final int? stuId;
  final String? userId;

  ListStudentsExam({
    this.adregId,
    this.adsceId,
    this.codFisStudente,
    this.cognomeStudente,
    this.matricola,
    this.nomeStudente,
    this.stuId,
    this.userId,
  });

  factory ListStudentsExam.fromRawJson(String str) =>
      ListStudentsExam.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListStudentsExam.fromJson(Map<String, dynamic> json) =>
      ListStudentsExam(
        adregId: json["adregId"],
        adsceId: json["adsceId"],
        codFisStudente: json["codFisStudente"],
        cognomeStudente: json["cognomeStudente"],
        matricola: json["matricola"],
        nomeStudente: json["nomeStudente"],
        stuId: json["stuId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "adregId": adregId,
        "adsceId": adsceId,
        "codFisStudente": codFisStudente,
        "cognomeStudente": cognomeStudente,
        "matricola": matricola,
        "nomeStudente": nomeStudente,
        "stuId": stuId,
        "userId": userId,
      };
}
