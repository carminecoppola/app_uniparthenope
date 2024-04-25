import 'dart:convert';

class TotalExamStudent {
  int totAdSuperate;
  int numAdSuperate;
  int cfuPar;
  int cfuTot;

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
