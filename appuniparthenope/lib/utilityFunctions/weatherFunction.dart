import 'package:appuniparthenope/controller/weather_controller.dart';
import 'package:appuniparthenope/model/weather_timeSerys_data.dart';
import 'package:appuniparthenope/provider/weather_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

/// Classe di utility per le operazioni legate al meteo.
class WeatherFunctions {
  /// Ottiene i dati meteo sulla posizione corrente e aggiorna il provider.
  static Future<void> getWeather(BuildContext context) async {
    final WeatherController weatherController = WeatherController();

    try {
      // Ottiene i dati sulla posizione corrente.
      final locationData = await getLocation();

      if (locationData != null) {
        // Imposta la latitudine e la longitudine, usate come parametri per ottenere i dati meteo.
        final latitude = locationData.latitude ?? 40.7;
        final longitude = locationData.longitude ?? 14.17;

        // Ottiene tutti i dati meteo per la latitudine e la longitudine specificate.
        final allTimeSeries = await weatherController.getAllWeatherTime(
            context, latitude, longitude);

        // Aggiorna il provider con i dati meteo ottenuti.
        final weatherDataProvider =
            Provider.of<WeatherDataProvider>(context, listen: false);
        weatherDataProvider.setWeatherInfo(allTimeSeries);
      } else {
        print('Location data is null');
      }
    } catch (e) {
      print('Error during getWeather(): $e');
    }
  }

  /// Ottiene i dati sulla posizione attuale.
  static Future<LocationData?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData; // Dati sulla posizione, opzionali

    // Verifica se il servizio di localizzazione è abilitato.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Richiede all'utente di abilitare il servizio di localizzazione.
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Servizio di localizzazione disabilitato');
      }
    }

    // Verifica lo stato del permesso di localizzazione.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // Richiede all'utente il permesso di accedere alla posizione.
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Permesso di localizzazione negato');
      }
    }

    // Ottiene la posizione solo se il servizio e il permesso sono stati abilitati.
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      locationData = await location.getLocation();
    }

    return locationData;
  }

  /// Ottiene il giorno della settimana da una data nel formato specificato.
  static String getDayOfWeek(String dateTime) {
    final year = int.parse(dateTime.substring(0, 4));
    final month = int.parse(dateTime.substring(4, 6));
    final day = int.parse(dateTime.substring(6, 8));

    final date = DateTime(year, month, day);
    final DateFormat formatter = DateFormat('EEE', 'it_IT'); // Locale Italiano
    return formatter.format(date);
  }

  /// Calcola l'umidità relativa media basata su diverse altitudini.
  static double calculateRelativeHumidity(Timesery umidita) {
    final rh2 = umidita.rh2 ?? 0.0;
    final rh300 = umidita.rh300 ?? 0.0;
    final rh500 = umidita.rh500 ?? 0.0;
    final rh700 = umidita.rh700 ?? 0.0;
    final rh850 = umidita.rh850 ?? 0.0;
    final rh925 = umidita.rh925 ?? 0.0;

    // Calcola la media dell'umidità relativa.
    final average = (rh2 + rh300 + rh500 + rh700 + rh850 + rh925) / 6;

    return average;
  }

  /// Calcola la pressione atmosferica media basata su una lista di serie temporali.
  static double calculateAveragePressure(List<Timesery> timeseries) {
    double sum = 0;
    int count = 0;
    for (var timeSeries in timeseries) {
      if (timeSeries.slp != null) {
        sum += timeSeries.slp!;
        count++;
      }
    }
    return count > 0 ? sum / count : 0;
  }

  /// Restituisce il percorso dell'icona del tempo in base al nome dell'icona.
  static String getIconAssetPath(String icon) {
    switch (icon) {
      case 'cloudy1_night.png':
      case 'cloudy1.png':
      case 'cloudy2_night.png':
      case 'cloudy2.png':
      case 'cloudy4_night.png':
      case 'cloudy4.png':
      case 'cloudy5_night.png':
      case 'cloudy5.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'shower1.png':
        return 'assets/icon/weather/Pioggia.png';
      case 'sunny_night.png':
        return 'assets/icon/weather/Soleggiato.png';
      case 'sunny.png':
        return 'assets/icon/weather/Sole.png';
      default:
        return 'assets/icon/weather/default.png'; // Icona di default
    }
  }
}
