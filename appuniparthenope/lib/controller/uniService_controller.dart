import 'package:appuniparthenope/model/teacherService/room_data.dart';
import 'package:flutter/material.dart';

import '../model/studentService/events_data.dart';
import '../service/api_univerisity_service.dart';

class UniServiceController {
  final ApiUniversityService apiService =
      ApiUniversityService();

  Future<List<EventsInfo>> getAllEvents(BuildContext context) async {
    try {
      List<EventsInfo>? events = [];
      List<EventsInfo> allEvents = await apiService.getEvents(context);

      events.addAll(allEvents);
      return events;
    } catch (e) {
      throw Exception('Errore Caricamento Eventi $e');
    }
  }

  Future<List<AllTodayRooms>> getAllTodayRoom(BuildContext context) async {
    try {
      List<AllTodayRooms>? rooms = [];
      List<AllTodayRooms> allRooms = await apiService.getAllTodayRoom(context);

      rooms.addAll(allRooms);
      return rooms;
    } catch (e) {
      throw Exception(
          '\n getAllTodayRoom(): Errore Caricamento Aule del giorno $e');
    }
  }

  
}
