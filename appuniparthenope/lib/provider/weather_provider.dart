import 'package:flutter/material.dart';
import '../model/weather_timeSerys_data.dart';

class WeatherDataProvider extends ChangeNotifier {
  List<Timesery> _timeSeriesList = []; // Non nullable

  List<Timesery> get timeSeriesList => _timeSeriesList;

  // Metodo per impostare le informazioni sul meteo
  void setWeatherInfo(List<Timesery> timeSeriesList) {
    _timeSeriesList = timeSeriesList;
    notifyListeners();
  }
}
