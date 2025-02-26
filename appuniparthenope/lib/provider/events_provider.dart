import 'package:flutter/material.dart';

import '../model/studentService/events_data.dart'; // Importa il servizio degli eventi

class EventsProvider extends ChangeNotifier {
  List<EventsInfo>? _events;

  List<EventsInfo>? get events => _events;

  // Metodo per impostare gli eventi
  void setAllEvents(List<EventsInfo> allEvents) {
    _events = events;
    notifyListeners();
  }
}
