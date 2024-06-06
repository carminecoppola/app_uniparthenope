import 'dart:convert';

class CourseProfessorInfo {
  final String? adDes;
  final int? adId;
  final String? cdsDes;
  final int? cdsId;
  final String? adDefAppCod;
  final String? cfu;
  final int? durata;
  final String? obbligatoria;
  final String? libera;
  final String? tipo;
  final String? settCod;
  final String? semCod;
  final String? semDes;
  final String? inizio;
  final String? fine;
  final String? ultMod;
  final String? sede;
  final int? adLogId;

  CourseProfessorInfo({
    this.adDes,
    this.adId,
    this.cdsDes,
    this.cdsId,
    this.adDefAppCod,
    this.cfu,
    this.durata,
    this.obbligatoria,
    this.libera,
    this.tipo,
    this.settCod,
    this.semCod,
    this.semDes,
    this.inizio,
    this.fine,
    this.ultMod,
    this.sede,
    this.adLogId,
  });

  CourseProfessorInfo copyWith({
    String? adDes,
    int? adId,
    String? cdsDes,
    int? cdsId,
    String? adDefAppCod,
    String? cfu,
    int? durata,
    String? obbligatoria,
    String? libera,
    String? tipo,
    String? settCod,
    String? semCod,
    String? semDes,
    String? inizio,
    String? fine,
    String? ultMod,
    String? sede,
    int? adLogId,
  }) =>
      CourseProfessorInfo(
        adDes: adDes ?? this.adDes,
        adId: adId ?? this.adId,
        cdsDes: cdsDes ?? this.cdsDes,
        cdsId: cdsId ?? this.cdsId,
        adDefAppCod: adDefAppCod ?? this.adDefAppCod,
        cfu: cfu ?? this.cfu,
        durata: durata ?? this.durata,
        obbligatoria: obbligatoria ?? this.obbligatoria,
        libera: libera ?? this.libera,
        tipo: tipo ?? this.tipo,
        settCod: settCod ?? this.settCod,
        semCod: semCod ?? this.semCod,
        semDes: semDes ?? this.semDes,
        inizio: inizio ?? this.inizio,
        fine: fine ?? this.fine,
        ultMod: ultMod ?? this.ultMod,
        sede: sede ?? this.sede,
        adLogId: adLogId ?? this.adLogId,
      );

  factory CourseProfessorInfo.fromRawJson(String str) =>
      CourseProfessorInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourseProfessorInfo.fromJson(Map<String, dynamic> json) =>
      CourseProfessorInfo(
        adDes: json["adDes"],
        adId: json["adId"],
        cdsDes: json["cdsDes"],
        cdsId: json["cdsId"],
        adDefAppCod: json["adDefAppCod"],
        cfu: json["cfu"],
        durata: json["durata"],
        obbligatoria: json["obbligatoria"],
        libera: json["libera"],
        tipo: json["tipo"],
        settCod: json["settCod"],
        semCod: json["semCod"],
        semDes: json["semDes"],
        inizio: json["inizio"],
        fine: json["fine"],
        ultMod: json["ultMod"],
        sede: json["sede"],
        adLogId: json["adLogId"],
      );

  Map<String, dynamic> toJson() => {
        "adDes": adDes,
        "adId": adId,
        "cdsDes": cdsDes,
        "cdsId": cdsId,
        "adDefAppCod": adDefAppCod,
        "cfu": cfu,
        "durata": durata,
        "obbligatoria": obbligatoria,
        "libera": libera,
        "tipo": tipo,
        "settCod": settCod,
        "semCod": semCod,
        "semDes": semDes,
        "inizio": inizio,
        "fine": fine,
        "ultMod": ultMod,
        "sede": sede,
        "adLogId": adLogId,
      };
}

class DetailsCourseInfo {
  final String? contenuti;
  final String? metodi;
  final String? verifica;
  final String? obiettivi;
  final String? prerequisiti;
  final String? testi;
  final String? altro;

  DetailsCourseInfo({
    this.contenuti,
    this.metodi,
    this.verifica,
    this.obiettivi,
    this.prerequisiti,
    this.testi,
    this.altro,
  });

  factory DetailsCourseInfo.fromRawJson(String str) =>
      DetailsCourseInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailsCourseInfo.fromJson(Map<String, dynamic> json) =>
      DetailsCourseInfo(
        contenuti: json["contenuti"],
        metodi: json["metodi"],
        verifica: json["verifica"],
        obiettivi: json["obiettivi"],
        prerequisiti: json["prerequisiti"],
        testi: json["testi"],
        altro: json["altro"],
      );

  Map<String, dynamic> toJson() => {
        "contenuti": contenuti,
        "metodi": metodi,
        "verifica": verifica,
        "obiettivi": obiettivi,
        "prerequisiti": prerequisiti,
        "testi": testi,
        "altro": altro,
      };
}
