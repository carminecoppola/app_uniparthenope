import 'dart:convert';

class CourseInfo {
  final String nome;
  final String codice;
  final int adId;
  final double cfu;
  final int annoId;
  final int adsceId;
  final int numAppelliPrenotabili;

  CourseInfo({
    required this.nome,
    required this.codice,
    required this.adId,
    required this.cfu,
    required this.annoId,
    required this.adsceId,
    required this.numAppelliPrenotabili,
  });

  factory CourseInfo.fromRawJson(String str) =>
      CourseInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
        nome: (json["nome"] ?? '').toString(),
        codice: (json["codice"] ?? '').toString(),
        adId: _parseInt(json["adId"]) ?? 0,
        cfu: _parseDouble(json["CFU"]) ?? 0,
        annoId: _parseInt(json["annoId"]) ?? 1,
        adsceId: _parseInt(json["adsceId"]) ?? 0,
        numAppelliPrenotabili: _parseInt(json["numAppelliPrenotabili"]) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "codice": codice,
        "adId": adId,
        "CFU": cfu,
        "annoId": annoId,
        "adsceId": adsceId,
        "numAppelliPrenotabili": numAppelliPrenotabili,
      };
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

//Status Class Model

class StatusCourse {
  final String stato;
  final String tipo;
  final String data;
  final int lode;
  final double? voto;
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
        stato: (json["stato"] ?? '').toString(),
        tipo: (json["tipo"] ?? '').toString(),
        data: (json["data"] ?? '').toString(),
        lode: _parseInt(json["lode"]) ?? 0,
        voto: _parseDouble(json["voto"]),
        anno: _parseInt(json["anno"]) ?? 0,
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
