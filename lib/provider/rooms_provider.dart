import 'package:appuniparthenope/model/teacherService/room_data.dart';
import 'package:flutter/material.dart';

class RoomsProvider extends ChangeNotifier {
  List<AllTodayRooms>? _rooms;

  List<AllTodayRooms>? get rooms => _rooms;

  // Metodo per impostare gli eventi
  void setAllTodayRooms(List<AllTodayRooms> allRooms) {
    _rooms = rooms;
    notifyListeners();
  }
}
