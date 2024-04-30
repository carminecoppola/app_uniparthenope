import 'dart:convert';

class CourseInfo {
  final String nome;
  final String codice;
  final int adId;
  final double cfu;
  final int annoId;
  final int adsceId;

  CourseInfo({
    required this.nome,
    required this.codice,
    required this.adId,
    required this.cfu,
    required this.annoId,
    required this.adsceId,
  });

  factory CourseInfo.fromRawJson(String str) =>
      CourseInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
        nome: json["nome"],
        codice: json["codice"],
        adId: json["adId"],
        cfu: json["CFU"],
        annoId: json["annoId"],
        adsceId: json["adsceId"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "codice": codice,
        "adId": adId,
        "CFU": cfu,
        "annoId": annoId,
        "adsceId": adsceId,
      };
}

//Status Class Model

class StatusCourse {
  final String stato;
  final String tipo;
  final String data;
  final int lode;
  final int voto;
  final int anno;

  StatusCourse({
    required this.stato,
    required this.tipo,
    required this.data,
    required this.lode,
    required this.voto,
    required this.anno,
  });

  factory StatusCourse.fromRawJson(String str) =>
      StatusCourse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatusCourse.fromJson(Map<String, dynamic> json) => StatusCourse(
        stato: json["stato"],
        tipo: json["tipo"],
        data: json["data"],
        lode: json["lode"],
        voto: json["voto"],
        anno: json["anno"],
      );

  Map<String, dynamic> toJson() => {
        "stato": stato,
        "tipo": tipo,
        "data": data,
        "lode": lode,
        "voto": voto,
        "anno": anno,
      };
}
