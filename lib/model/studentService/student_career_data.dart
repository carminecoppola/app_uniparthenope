import 'dart:convert';

class TotalExamStudent {
  int totAdSuperate;
  int numAdSuperate;
  double cfuPar;
  double cfuTot;

  TotalExamStudent({
    required this.totAdSuperate,
    required this.numAdSuperate,
    required this.cfuPar,
    required this.cfuTot,
  });

  factory TotalExamStudent.fromRawJson(String str) =>
      TotalExamStudent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalExamStudent.fromJson(Map<String, dynamic> json) =>
      TotalExamStudent(
        totAdSuperate: json["totAdSuperate"],
        numAdSuperate: json["numAdSuperate"],
        cfuPar: json["cfuPar"],
        cfuTot: json["cfuTot"],
      );

  Map<String, dynamic> toJson() => {
        "totAdSuperate": totAdSuperate,
        "numAdSuperate": numAdSuperate,
        "cfuPar": cfuPar,
        "cfuTot": cfuTot,
      };
}

//Average Model
class AverageInfo {
  final double trenta;
  final int baseTrenta;
  final int baseCentodieci;
  final double centodieci;

  AverageInfo({
    required this.trenta,
    required this.baseTrenta,
    required this.baseCentodieci,
    required this.centodieci,
  });

  factory AverageInfo.fromRawJson(String str) =>
      AverageInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AverageInfo.fromJson(Map<String, dynamic> json) => AverageInfo(
        trenta: json["trenta"]?.toDouble(),
        baseTrenta: json["base_trenta"],
        baseCentodieci: json["base_centodieci"],
        centodieci: json["centodieci"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "trenta": trenta,
        "base_trenta": baseTrenta,
        "base_centodieci": baseCentodieci,
        "centodieci": centodieci,
      };
}
