import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/weather_timeSerys_data.dart';
import '../../../provider/weather_provider.dart';
import '../../CustomLoadingIndicator.dart';
import 'package:appuniparthenope/main.dart';

import 'singleWeatherCard.dart';

class WeatherInfoCard extends StatelessWidget {
  final String placeName;

  const WeatherInfoCard({Key? key, required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        height: 350,
        child: Card(
          color: AppColors.primaryColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  placeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.detailsColor,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Consumer<WeatherDataProvider>(
                    builder: (context, weatherDataProvider, child) {
                      final List<Timesery> allTimeSeries =
                          weatherDataProvider.timeSeriesList;
                      if (allTimeSeries.isEmpty) {
                        return const Center(
                          child: CustomLoadingIndicator(
                            text: 'Caricamento informazioni meteo...',
                            myColor: AppColors.detailsColor,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: allTimeSeries.length,
                          itemBuilder: (context, index) {
                            final Timesery timeSeries = allTimeSeries[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: WeatherInfoWidget(
                                dateTime: timeSeries.dateTime.toString(),
                                iconAssetPath: timeSeries.icon.toString(),
                                iconDescription: timeSeries.winds.toString(),
                                temperature: timeSeries.t2C.toString(),
                                description: timeSeries.text!.it.toString(),
                                vento: timeSeries.wd10.toString(),
                                velocitaVento: timeSeries.ws10.toString(),
                                umidita: timeSeries,
                                airQuality: (timeSeries.dwd10! * 2).toString(),
                                probPioggia: (timeSeries.rh2! / 10).toString(),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
