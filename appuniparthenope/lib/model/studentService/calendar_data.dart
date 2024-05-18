import 'dart:convert';

class LecturesInfo {
  final String nomeLezione;
  final String dataLezione;
  final String orarioLezione;

  LecturesInfo(
      {required this.nomeLezione,
      required this.dataLezione,
      required this.orarioLezione});

  static fromJson(data) {}
}

