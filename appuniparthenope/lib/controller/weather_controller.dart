import 'package:appuniparthenope/model/weather_data.dart';
import 'package:appuniparthenope/model/weather_timeSerys_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/weather_provider.dart';
import '../service/api_weather_service.dart';

class WeatherController {
  final ApiWeatherService apiWeatherService = ApiWeatherService();

  Future<List<Timesery>> getAllWeatherTime(
      BuildContext context, double latitude, double longitude) async {
    try {
      List<Timesery> allTimeSeries = [];

      // Ottieni il luogo più vicino alle coordinate specificate
      List<PlacesInfo> allPlaces = await apiWeatherService.getWeatherPlaces(
          context, latitude, longitude);
      PlacesInfo nearestPlace = allPlaces.isNotEmpty
          ? allPlaces.first
          : throw Exception('Nessun luogo trovato');

      // Ottieni il nome del luogo
      String placeName = nearestPlace.longName.it;
      if (placeName.contains("Municipalit")) {
        List<String> tmp = placeName.split("-");
        placeName = tmp.last.trim();
      }

      print('\n\nMunicipalità: $placeName');

      final weatherDataProvider =
          Provider.of<WeatherDataProvider>(context, listen: false);
      weatherDataProvider.setPlaceName(placeName);

      // Ottieni i dati meteorologici per il luogo più vicino
      List<Timesery>? timeSeries =
          await apiWeatherService.getWeatherTimeSeries(context, nearestPlace);

      // Ottieni i dati meteorologici per i prossimi 3 giorni
      DateTime today = DateTime.now();
      for (int day = 0; day < 4; day++) {
        DateTime nextDay = today.add(Duration(days: day));
        String nextDayString =
            '${DateFormat('yyyyMMdd').format(nextDay)}Z${DateFormat('HH00').format(nextDay)}';

        // Trova i dati meteorologici per il giorno specificato
        Timesery? matchingTimeSeries = timeSeries!.firstWhere(
            (timeSeries) => timeSeries.dateTime == nextDayString,
            orElse: () => throw Exception(
                'Dati meteorologici non trovati per $nextDayString'));

        // Aggiungi i dati meteorologici alla lista
        allTimeSeries.add(matchingTimeSeries);
      }

      return allTimeSeries;
    } catch (e) {
      print(
          '- getAllWeatherTime(): Errore durante il recupero dei dati meteorologici: $e');
      // Restituisco una lista vuota o lancia l'eccezione a seconda della gestione degli errori desiderata
      return [];
    }
  }
}
