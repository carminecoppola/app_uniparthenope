import 'dart:convert';

class CourseInfo {
  final String nome;
  final String codice;
  final int adId;
  final double
      cfu; //In realtà è un int quindi va tolto lo zero perche la richiesta restitisce tipo CFU 9.0
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
