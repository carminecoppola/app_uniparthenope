import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/weather_timeSerys_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../controller/weatherFunction.dart';

class WeatherInfoWidget extends StatelessWidget {
  final String dateTime;
  final String iconAssetPath;
  final String iconDescription;
  final String temperature;
  final String description;
  final String vento;
  final String velocitaVento;
  final Timesery umidita;

  const WeatherInfoWidget({
    super.key,
    required this.dateTime,
    required this.iconAssetPath,
    required this.iconDescription,
    required this.temperature,
    required this.description,
    required this.vento,
    required this.velocitaVento,
    required this.umidita,
  });

  String _getDayOfWeek(String dateTime) {
    final year = int.parse(dateTime.substring(0, 4));
    final month = int.parse(dateTime.substring(4, 6));
    final day = int.parse(dateTime.substring(6, 8));

    final date = DateTime(year, month, day);
    final DateFormat formatter = DateFormat('EEE', 'it_IT'); // Locale Italian
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Estrai il giorno e il mese dalla stringa dateTime
    final dayMonth = '${dateTime.substring(6, 8)}/${dateTime.substring(4, 6)}';
    final dayOfWeek = _getDayOfWeek(dateTime);

    final assets = WeatherFunctions.getIconAssetPath(iconAssetPath);

    final relativeHumidity =
        '${WeatherFunctions.calculateRelativeHumidity(umidita).toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                WeatherFunctions.toCamelCase(dayOfWeek),
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dayMonth,
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Image.asset(
          assets,
          width: 60,
          height: 60,
        ),
        const SizedBox(height: 10),
        Text(
          WeatherFunctions.toCamelCase(
              description.replaceAll('It.', '').replaceAll('_', ' ')),
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '$temperature°C',
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 12,
          ),
        ),
        Text(
          iconDescription,
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 12,
          ),
        ),
        Text(
          '$velocitaVento m/s',
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 12,
          ),
        ),
        Text(
          relativeHumidity,
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
