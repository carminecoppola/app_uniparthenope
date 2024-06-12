import 'dart:convert';

class SessionProfessorInfo {
  final String? aaCurr;
  final int? semId;
  final String? semDes;
  final String? aaId;

  SessionProfessorInfo({
    this.aaCurr,
    this.semId,
    this.semDes,
    this.aaId,
  });

  SessionProfessorInfo copyWith({
    String? aaCurr,
    int? semId,
    String? semDes,
    String? aaId,
  }) =>
      SessionProfessorInfo(
        aaCurr: aaCurr ?? this.aaCurr,
        semId: semId ?? this.semId,
        semDes: semDes ?? this.semDes,
        aaId: aaId ?? this.aaId,
      );

  factory SessionProfessorInfo.fromRawJson(String str) =>
      SessionProfessorInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SessionProfessorInfo.fromJson(Map<String, dynamic> json) =>
      SessionProfessorInfo(
        aaCurr: json["aa_curr"],
        semId: json["semId"],
        semDes: json["semDes"],
        aaId: json["aaId"],
      );

  Map<String, dynamic> toJson() => {
        "aa_curr": aaCurr,
        "semId": semId,
        "semDes": semDes,
        "aaId": aaId,
      };
}
