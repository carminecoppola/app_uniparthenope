import 'package:flutter/material.dart';
import '../model/weather_timeSerys_data.dart';

class WeatherDataProvider extends ChangeNotifier {
  String _palceName = 'Napoli';
  List<Timesery> _timeSeriesList = []; // Non nullable

  String get placeName => _palceName;
  List<Timesery> get timeSeriesList => _timeSeriesList;

  // Metodo per impostare le informazioni sul meteo
  void setPlaceName(String placeName) {
    _palceName = placeName;
    notifyListeners();
  }

  // Metodo per impostare le informazioni sul meteo
  void setWeatherInfo(List<Timesery> timeSeriesList) {
    _timeSeriesList = timeSeriesList;
    notifyListeners();
  }
}
