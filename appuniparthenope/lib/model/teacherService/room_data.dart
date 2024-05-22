import 'dart:convert';

class AllTodayRooms {
  final String? area;
  final List<Service>? services;

  AllTodayRooms({
    this.area,
    this.services,
  });

  AllTodayRooms copyWith({
    String? area,
    List<Service>? services,
  }) =>
      AllTodayRooms(
        area: area ?? this.area,
        services: services ?? this.services,
      );

  factory AllTodayRooms.fromRawJson(String str) =>
      AllTodayRooms.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllTodayRooms.fromJson(Map<String, dynamic> json) => AllTodayRooms(
        area: json["area"],
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "area": area,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class Service {
  final int? id;
  final String? idCorso;
  final DateTime? start;
  final DateTime? end;
  final Room? room;
  final String? courseName;
  final String? prof;
  final Reservation? reservation;

  Service({
    this.id,
    this.idCorso,
    this.start,
    this.end,
    this.room,
    this.courseName,
    this.prof,
    this.reservation,
  });

  Service copyWith({
    int? id,
    String? idCorso,
    DateTime? start,
    DateTime? end,
    Room? room,
    String? courseName,
    String? prof,
    Reservation? reservation,
  }) =>
      Service(
        id: id ?? this.id,
        idCorso: idCorso ?? this.idCorso,
        start: start ?? this.start,
        end: end ?? this.end,
        room: room ?? this.room,
        courseName: courseName ?? this.courseName,
        prof: prof ?? this.prof,
        reservation: reservation ?? this.reservation,
      );

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        idCorso: json["id_corso"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        room: json["room"] == null ? null : Room.fromJson(json["room"]),
        courseName: json["course_name"],
        prof: json["prof"],
        reservation: json["reservation"] == null
            ? null
            : Reservation.fromJson(json["reservation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_corso": idCorso,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "room": room?.toJson(),
        "course_name": courseName,
        "prof": prof,
        "reservation": reservation?.toJson(),
      };
}

class Reservation {
  final dynamic reservedId;
  final bool? reserved;
  final dynamic reservedBy;

  Reservation({
    this.reservedId,
    this.reserved,
    this.reservedBy,
  });

  Reservation copyWith({
    dynamic reservedId,
    bool? reserved,
    dynamic reservedBy,
  }) =>
      Reservation(
        reservedId: reservedId ?? this.reservedId,
        reserved: reserved ?? this.reserved,
        reservedBy: reservedBy ?? this.reservedBy,
      );

  factory Reservation.fromRawJson(String str) =>
      Reservation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
        reservedId: json["reserved_id"],
        reserved: json["reserved"],
        reservedBy: json["reserved_by"],
      );

  Map<String, dynamic> toJson() => {
        "reserved_id": reservedId,
        "reserved": reserved,
        "reserved_by": reservedBy,
      };
}

class Room {
  final String? name;
  final int? capacity;
  final String? description;
  final int? availability;

  Room({
    this.name,
    this.capacity,
    this.description,
    this.availability,
  });

  Room copyWith({
    String? name,
    int? capacity,
    String? description,
    int? availability,
  }) =>
      Room(
        name: name ?? this.name,
        capacity: capacity ?? this.capacity,
        description: description ?? this.description,
        availability: availability ?? this.availability,
      );

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
