import 'package:intl/intl.dart';
import '../model/weather_timeSerys_data.dart';
import 'package:flutter/cupertino.dart';

class WeatherFunctions {
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

  static String getIconAssetPath(String icon) {
    switch (icon) {
      case 'Icon.CLOUDY1_NIGHT_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY1_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY2_NIGHT_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY2_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY4_NIGHT_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY4_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY5_NIGHT_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.CLOUDY5_PNG':
        return 'assets/icon/weather/Nuvoloso.png';
      case 'Icon.SHOWER1_NIGHT_PNG':
        return 'assets/icon/weather/Pioggia.png';
      case 'Icon.SUNNY_NIGHT_PNG':
        return 'assets/icon/weather/Soleggiato.png';
      case 'Icon.SUNNY_PNG':
        return 'assets/icon/weather/Sole.png';
      default:
        return 'assets/icon/weather/default.png'; // valore di default
    }
  }

  static IconData getIOSCupertinoIcon(String text) {
    switch (text.toLowerCase()) {
      case 'humidity':
        return CupertinoIcons.drop;
      case 'wind':
        return CupertinoIcons.wind;
      default:
        return CupertinoIcons.question;
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
