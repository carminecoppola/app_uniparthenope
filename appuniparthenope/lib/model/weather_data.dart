import 'dart:convert';

class PlacesInfo {
  final Bbox bbox;
  final String id;
  final Name longName;
  final Name name;
  final Pos pos;

  PlacesInfo({
    required this.bbox,
    required this.id,
    required this.longName,
    required this.name,
    required this.pos,
  });

  factory PlacesInfo.fromRawJson(String str) =>
      PlacesInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlacesInfo.fromJson(Map<String, dynamic> json) => PlacesInfo(
        bbox: Bbox.fromJson(json["bbox"]),
        id: json["id"],
        longName: Name.fromJson(json["long_name"]),
        name: Name.fromJson(json["name"]),
        pos: Pos.fromJson(json["pos"]),
      );

  Map<String, dynamic> toJson() => {
        "bbox": bbox.toJson(),
        "id": id,
        "long_name": longName.toJson(),
        "name": name.toJson(),
        "pos": pos.toJson(),
      };
}

class Bbox {
  final List<List<double>> coordinates;
  final String type;

  Bbox({
    required this.coordinates,
    required this.type,
  });

  factory Bbox.fromRawJson(String str) => Bbox.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bbox.fromJson(Map<String, dynamic> json) => Bbox(
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(
            coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "type": type,
      };
}

class Name {
  final String it;

  Name({
    required this.it,
  });

  factory Name.fromRawJson(String str) => Name.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        it: json["it"],
      );

  Map<String, dynamic> toJson() => {
        "it": it,
      };
}

class Pos {
  final List<double> coordinates;
  final String type;

  Pos({
    required this.coordinates,
    required this.type,
  });

  factory Pos.fromRawJson(String str) => Pos.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}
