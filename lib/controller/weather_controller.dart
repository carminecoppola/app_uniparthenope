import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/weather_data.dart';
import '../model/weather_time_series_data.dart';
import '../provider/weather_provider.dart';
import '../service/api_weather_service.dart';

class WeatherController {
  final ApiWeatherService apiWeatherService = ApiWeatherService();

  Future<List<Timesery>> getAllWeatherTime(
      BuildContext context, double latitude, double longitude) async {
    try {
      List<PlacesInfo> allPlaces = await apiWeatherService.getWeatherPlaces(
          context, latitude, longitude);
      if (!context.mounted) return [];

      PlacesInfo selectedPlace = await _fetchValidPlace(context, allPlaces);
      if (!context.mounted) return [];
      String placeName = _formatPlaceName(selectedPlace.longName.it);

      Provider.of<WeatherDataProvider>(context, listen: false)
          .setPlaceName(placeName);

      List<Timesery> allTimeSeries =
          await _getTimeSeriesForNextDays(context, selectedPlace);
      if (!context.mounted) return [];
      // Invia tutti i dati, inclusi quelli per i giorni successivi
      return allTimeSeries;
    } catch (e) {
      return [];
    }
  }

  Future<List<Timesery>> _getTimeSeriesForNextDays(
      BuildContext context, PlacesInfo selectedPlace) async {
    List<Timesery>? timeSeries =
        await apiWeatherService.getWeatherTimeSeries(context, selectedPlace);

    List<Timesery> allTimeSeries = [];
    DateTime today = DateTime.now();

    for (int day = 0; day < 4; day++) {
      DateTime nextDay = today.add(Duration(days: day));
      String nextDayString =
          '${DateFormat('yyyyMMdd').format(nextDay)}Z${DateFormat('HH00').format(nextDay)}';

      // Trova i dati meteorologici per il giorno specificato
      Timesery? matchingTimeSeries = timeSeries.firstWhere(
          (timeSeries) => timeSeries.dateTime == nextDayString,
          orElse: () => throw Exception(
              'Dati meteorologici non trovati per $nextDayString'));

      // Aggiungi i dati meteorologici alla lista
      allTimeSeries.add(matchingTimeSeries);
    }

    return allTimeSeries;
  }

  Future<PlacesInfo> _fetchValidPlace(
      BuildContext context, List<PlacesInfo> allPlaces) async {
    for (var place in allPlaces) {
      try {
        await apiWeatherService.getWeatherTimeSeries(context, place);
        return place;
      } catch (_) {
        continue;
      }
    }
    throw Exception('Nessun luogo valido trovato');
  }

  String _formatPlaceName(String placeName) {
    if (placeName.contains("Municipalit")) {
      List<String> tmp = placeName.split("-");
      return tmp.last.trim();
    }
    return placeName;
  }
}
