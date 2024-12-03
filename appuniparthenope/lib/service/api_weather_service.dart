import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/weather_data.dart';
import '../model/weather_timeSerys_data.dart';

class ApiWeatherService {
  final String baseUrl = "https://api.meteo.uniparthenope.it";

  Future<List<PlacesInfo>> getWeatherPlaces(
      BuildContext context, double latitude, double longitude) async {
    final url = Uri.parse(
        '$baseUrl/places/search/bycoords/$latitude/$longitude?filter=com');
    print('Richiesta API a: $url');

    final startTime = DateTime.now(); // Inizio misurazione tempo
    final response = await http.get(url);
    final endTime = DateTime.now(); // Fine misurazione tempo

    final responseTime = endTime.difference(startTime).inMilliseconds;
    print('Tempo di risposta API: ${responseTime}ms');

    print('getWeatherPlaces() - Status code: ${response.statusCode}');
    print('Coordinate inviate: Latitude: $latitude, Longitude: $longitude');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Risposta API ricevuta: $jsonResponse');

      if (jsonResponse is List) {
        List<PlacesInfo> placesList = jsonResponse
            .map((placeJson) => PlacesInfo.fromJson(placeJson))
            .toList();
        print('Luoghi trovati: ${placesList.length}');
        return placesList;
      } else if (jsonResponse is Map<String, dynamic>) {
        return [PlacesInfo.fromJson(jsonResponse)];
      } else {
        throw Exception('Risposta vuota o formato non valido');
      }
    } else if (response.statusCode == 500) {
      throw Exception(
          'Errore del SERVER durante il caricamento dei places del meteo');
    } else {
      throw Exception('Errore durante il caricamento dei places del meteo');
    }
  }

  Future<List<Timesery>> getWeatherTimeSeries(
      BuildContext context, PlacesInfo place) async {
    final url =
        Uri.parse('$baseUrl/products/wrf5/timeseries/${place.id}?filter=com');
    print('Richiesta dati meteo per placeId: ${place.id} a $url');

    final startTime = DateTime.now(); // Inizio misurazione tempo
    final response = await http.get(url);
    final endTime = DateTime.now(); // Fine misurazione tempo

    final responseTime = endTime.difference(startTime).inMilliseconds;
    print('Tempo di risposta API: ${responseTime}ms');

    print('getWeatherTimeSeries() - Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Risposta TimeSeries API: $jsonResponse');

      if (jsonResponse == null || !jsonResponse.containsKey('timeseries')) {
        throw Exception('JSON response does not contain "timeseries" key');
      }

      try {
        TimeSerysInfo timeSeriesInfo = TimeSerysInfo.fromJson(jsonResponse);

        print('Parsing TimeSeries completato');
        return timeSeriesInfo.timeseries ?? [];
      } catch (e) {
        print('Errore durante il parsing di TimeSerysInfo: $e');
        throw Exception('Failed to parse TimeSerysInfo from JSON');
      }
    } else {
      throw Exception(
          'getWeatherTimeSeries() - Errore durante il recupero dei dati meteorologici');
    }
  }
}
