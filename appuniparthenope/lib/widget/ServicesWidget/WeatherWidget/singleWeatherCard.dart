import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/model/weather_timeSerys_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../utilityFunctions/weatherFunction.dart';

class WeatherInfoWidget extends StatelessWidget {
  final String municipalita;
  final String dateTime;
  final String iconAssetPath;
  final String iconDescription;
  final String temperature;
  final String description;
  final String vento;
  final String velocitaVento;
  final Timesery umidita;
  final String airQuality;
  final String probPioggia;

  const WeatherInfoWidget({
    super.key,
    required this.municipalita,
    required this.dateTime,
    required this.iconAssetPath,
    required this.iconDescription,
    required this.temperature,
    required this.description,
    required this.vento,
    required this.velocitaVento,
    required this.umidita,
    required this.airQuality,
    required this.probPioggia,
  });

  String _getDayOfWeek(String dateTime) {
    final year = int.parse(dateTime.substring(0, 4));
    final month = int.parse(dateTime.substring(4, 6));
    final day = int.parse(dateTime.substring(6, 8));

    final date = DateTime(year, month, day);
    final DateFormat formatter =
        DateFormat('EEEE | d MMM', 'it_IT'); // Locale Italian
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = _getDayOfWeek(dateTime);

    final assets = WeatherFunctions.getIconAssetPath(iconAssetPath);

    final relativeHumidity =
        '${WeatherFunctions.calculateRelativeHumidity(umidita).toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          WeatherFunctions.toCamelCase(municipalita),
          style: const TextStyle(
              color: AppColors.detailsColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Center(
          child: Image.asset(
            assets,
            width: 120,
            height: 120,
          ),
        ),
        Text(
          WeatherFunctions.toCamelCase(dayOfWeek),
          style: const TextStyle(
              color: AppColors.backgroundColor,
              fontSize: 10,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          '$temperature°',
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          WeatherFunctions.toCamelCase(
              description.replaceAll('It.', '').replaceAll('_', ' ')),
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 10,
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 2,
          height: 30,
          indent: 20,
          endIndent: 20,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 3.0,
            padding: const EdgeInsets.all(10),
            children: [
              _buildWeatherDetail(FontAwesomeIcons.wind, '$velocitaVento km/h'),
              _buildWeatherDetail(
                  FontAwesomeIcons.cloudShowersHeavy, '$probPioggia%'),
              _buildWeatherDetail(FontAwesomeIcons.droplet, relativeHumidity),
              _buildWeatherDetail(Icons.air, airQuality),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: AppColors.backgroundColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.backgroundColor,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
