import 'dart:convert';

class EventsInfo {
  final int id;
  final DateTime start;
  final DateTime end;
  final Room room;
  final String courseName;
  final Description description;
  final Type type;

  EventsInfo({
    required this.id,
    required this.start,
    required this.end,
    required this.room,
    required this.courseName,
    required this.description,
    required this.type,
  });

  factory EventsInfo.fromRawJson(String str) =>
      EventsInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventsInfo.fromJson(Map<String, dynamic> json) {
    return EventsInfo(
      id: json["id"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
      room: Room.fromJson(json["room"]),
      courseName: json["course_name"],
      description: json["description"] != null
          ? descriptionValues.map[json["description"]] ?? Description.EMPTY
          : Description.EMPTY,
      type: json["type"] != null
          ? typeValues.map[json["type"]] ?? Type.B
          : Type.B,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "room": room.toJson(),
        "course_name": courseName,
        "description": descriptionValues.reverse[description],
        "type": typeValues.reverse[type],
      };
}

enum Description { EMPTY, PROF_SCHIAVONE }

final descriptionValues = EnumValues(
    {"": Description.EMPTY, "PROF.SCHIAVONE": Description.PROF_SCHIAVONE});

class Room {
  final String name;
  final double capacity;
  final String description;
  final double availability;

  Room({
    required this.name,
    required this.capacity,
    required this.description,
    required this.availability,
  });

  factory Room.fromRawJson(String str) => Room.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        name: json["name"],
        capacity: json["capacity"],
        description: json["description"],
        availability: json["availability"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "capacity": capacity,
        "description": description,
        "availability": availability,
      };
}

enum Type { B, O }

final typeValues = EnumValues({"b": Type.B, "O": Type.O});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }

  T? fromString(String? key) {
    if (key == null || !map.containsKey(key)) {
      return null; // or a default value if needed
    }
    return map[key];
  }
}
