import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/weather_data.dart';
import '../model/weather_time_series_data.dart';

class ApiWeatherService {
  final String baseUrl = "https://api.meteo.uniparthenope.it";

  Future<List<PlacesInfo>> getWeatherPlaces(
      BuildContext context, double latitude, double longitude) async {
    final url = Uri.parse(
        '$baseUrl/places/search/bycoords/$latitude/$longitude?filter=com');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        List<PlacesInfo> placesList = jsonResponse
            .map((placeJson) => PlacesInfo.fromJson(placeJson))
            .toList();
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

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse == null || !jsonResponse.containsKey('timeseries')) {
        throw Exception('JSON response does not contain "timeseries" key');
      }

      try {
        TimeSerysInfo timeSeriesInfo = TimeSerysInfo.fromJson(jsonResponse);

        return timeSeriesInfo.timeseries ?? [];
      } catch (e) {
        throw Exception('Failed to parse TimeSerysInfo from JSON');
      }
    } else {
      throw Exception(
          'getWeatherTimeSeries() - Errore durante il recupero dei dati meteorologici');
    }
  }
}
