import 'dart:convert';

class CheckExamInfo {
  final String? esame;
  final int? appId;
  final String? stato;
  final String? statoDes;
  final String? docente;
  final String? docenteCompleto;
  final int? numIscritti;
  final String? note;
  final String? descrizione;
  final String? dataFine;
  final String? dataInizio;
  final String? dataEsame;

  CheckExamInfo({
    this.esame,
    this.appId,
    this.stato,
    this.statoDes,
    this.docente,
    this.docenteCompleto,
    this.numIscritti,
    this.note,
    this.descrizione,
    this.dataFine,
    this.dataInizio,
    this.dataEsame,
  });

  factory CheckExamInfo.fromRawJson(String str) =>
      CheckExamInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckExamInfo.fromJson(Map<String, dynamic> json) => CheckExamInfo(
        esame: json["esame"],
        appId: json["appId"],
        stato: json["stato"],
        statoDes: json["statoDes"],
        docente: json["docente"],
        docenteCompleto: json["docente_completo"],
        numIscritti: json["numIscritti"],
        note: json["note"],
        descrizione: json["descrizione"],
        dataFine: json["dataFine"],
        dataInizio: json["dataInizio"],
        dataEsame: json["dataEsame"],
      );

  Map<String, dynamic> toJson() => {
        "esame": esame,
        "appId": appId,
        "stato": stato,
        "statoDes": statoDes,
        "docente": docente,
        "docente_completo": docenteCompleto,
        "numIscritti": numIscritti,
        "note": note,
        "descrizione": descrizione,
        "dataFine": dataFine,
        "dataInizio": dataInizio,
        "dataEsame": dataEsame,
      };
}
