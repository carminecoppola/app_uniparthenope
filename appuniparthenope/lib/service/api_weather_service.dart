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
    //Messe in maniera costante
    // latitude = 40.7;
    // longitude = 14.17;

    final url = Uri.parse(
        '$baseUrl/places/search/bycoords/$latitude/$longitude?filter=com');

    final response = await http.get(url);

    print('getWeatherPlaces() Status: ${response.statusCode}');
    print('Latitude:$latitude & longitude: $longitude');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      print('\n$jsonResponse');

      if (jsonResponse is List) {
        // Se la risposta è una lista, converti ogni elemento in un oggetto PlacesInfo
        List<PlacesInfo> placesList = jsonResponse
            .map((placeJson) => PlacesInfo.fromJson(placeJson))
            .toList();
        return placesList;
      } else if (jsonResponse is Map<String, dynamic>) {
        // Se la risposta è un oggetto JSON, convertilo direttamente in un oggetto PlacesInfo
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
    final url = Uri.parse('$baseUrl/products/wrf5/timeseries/${place.id}');

    print('\nPlace Id: {place.id}');

    final response = await http.get(url);

    print('\ngetWeatherTimeSeries() Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      print('\nTimeSeries: $jsonResponse');

      if (jsonResponse == null || !jsonResponse.containsKey('timeseries')) {
        throw Exception('JSON response does not contain "timeseries" key');
      }

      // Converti il JSON nella tua classe TimeSeriesInfo
      try {
        TimeSerysInfo timeSeriesInfo = TimeSerysInfo.fromJson(jsonResponse);

        // Ritorna la lista di timeseries
        return timeSeriesInfo.timeseries ?? [];
      } catch (e) {
        print('Error parsing TimeSerysInfo: $e');
        throw Exception('Failed to parse TimeSerysInfo from JSON');
      }
    } else {
      throw Exception(
          '- getWeatherTimeSeries() : Errore durante il recupero dei dati meteorologici');
    }
  }
}
