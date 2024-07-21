import 'package:appuniparthenope/model/teacherService/room_data.dart';
import 'package:flutter/material.dart';

import '../model/studentService/events_data.dart';
import '../service/api_univerisity_service.dart';

class UniServiceController {
  final ApiUniversityService apiService = ApiUniversityService();

  /// Ottiene tutti gli eventi.
  /// Ritorna una lista di [EventsInfo].
  Future<List<EventsInfo>> getAllEvents(BuildContext context) async {
    try {
      List<EventsInfo> events = [];
      List<EventsInfo> allEvents = await apiService.getEvents(context);

      events.addAll(allEvents);
      return events;
    } catch (e) {
      throw Exception('Errore durante il caricamento degli eventi: $e');
    }
  }

  /// Ottiene tutte le aule di oggi.
  /// Ritorna una lista di [AllTodayRooms].
  Future<List<AllTodayRooms>> getAllTodayRoom(BuildContext context) async {
    try {
      List<AllTodayRooms> rooms = [];
      List<AllTodayRooms> allRooms = await apiService.getAllTodayRoom(context);

      rooms.addAll(allRooms);
      return rooms;
    } catch (e) {
      throw Exception('Errore durante il caricamento delle aule di oggi: $e');
    }
  }
}
