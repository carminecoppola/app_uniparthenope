import 'package:appuniparthenope/provider/weather_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/weather_controller.dart';
import '../model/weather_timeSerys_data.dart';
import 'package:flutter/cupertino.dart';

class WeatherFunctions {
  static Future<void> getWeather(BuildContext context) async {
    final WeatherController weatherController = WeatherController();

    const latitude = 40.7;
    const longitude = 14.17;

    try {
      final allTimeSeries = await weatherController.getAllWeatherTime(
          context, latitude, longitude);
      final weatherDataProvider =
          Provider.of<WeatherDataProvider>(context, listen: false);
      weatherDataProvider.setWeatherInfo(allTimeSeries);
    } catch (e) {
      print('Error during getWeather(): $e');
    }
  }

  static String getDayOfWeek(String dateTime) {
    final year = int.parse(dateTime.substring(0, 4));
    final month = int.parse(dateTime.substring(4, 6));
    final day = int.parse(dateTime.substring(6, 8));

    final date = DateTime(year, month, day);
    final DateFormat formatter = DateFormat('EEE', 'it_IT'); // Locale Italian
    return formatter.format(date);
  }

  static double calculateRelativeHumidity(Timesery umidita) {
    // Calcola la media dell'umidità relativa a diverse altitudini
    final rh2 = umidita.rh2 ?? 0.0;
    final rh300 = umidita.rh300 ?? 0.0;
    final rh500 = umidita.rh500 ?? 0.0;
    final rh700 = umidita.rh700 ?? 0.0;
    final rh850 = umidita.rh850 ?? 0.0;
    final rh925 = umidita.rh925 ?? 0.0;

    // Calcola la media
    final average = (rh2 + rh300 + rh500 + rh700 + rh850 + rh925) / 6;

    return average;
  }

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

  static String getIconAssetPath(String icon) {
    switch (icon) {
      case 'cloudy1_night.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy1.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy2_night.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy2.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy4_night.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy4.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy5_night.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'cloudy5.png':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'shower1.png':
        return 'assets/icon/weather/Pioggia.png';
      case 'sunny_night.png':
        return 'assets/icon/weather/Soleggiato.png';
      case 'sunny.png':
        return 'assets/icon/weather/Sole.png';
      default:
        return 'assets/icon/weather/default.png'; // valore di default
    }
  }

  static String toCamelCase(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return '';
    }).join(' ');
  }
}
