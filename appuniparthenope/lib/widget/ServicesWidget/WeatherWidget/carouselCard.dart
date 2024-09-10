import 'package:appuniparthenope/widget/ServicesWidget/WeatherWidget/singleWeatherCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/weather_timeSerys_data.dart';
import '../../../provider/weather_provider.dart';
import 'package:appuniparthenope/main.dart';

import '../../CustomLoadingIndicator.dart';

class CarouselCard extends StatefulWidget {
  const CarouselCard({super.key});

  @override
  _CarouselCardState createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 450,
          child: Card(
            color: AppColors.primaryColor,
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Consumer<WeatherDataProvider>(
              builder: (context, weatherDataProvider, child) {
                final timeSeriesList = weatherDataProvider.timeSeriesList;

                if (timeSeriesList.isEmpty) {
                  return const Center(
                    child: CustomLoadingIndicator(
                      text: 'Caricamento\ninformazioni meteo',
                      myColor: AppColors.detailsColor,
                    ),
                  );
                } else {
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: timeSeriesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCarouselItem(index, timeSeriesList);
                    },
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Consumer<WeatherDataProvider>(
          builder: (context, weatherDataProvider, child) {
            final timeSeriesList = weatherDataProvider.timeSeriesList;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                timeSeriesList.length,
                (index) => _buildDot(index),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCarouselItem(int index, List<Timesery> timeSeriesList) {
    final timeSeries = timeSeriesList[index];
    final placeName = Provider.of<WeatherDataProvider>(context).placeName;

    // Truncate the placeName
    final truncatedPlaceName = placeName.replaceAll('Comune di ', '');

    // Debug prints
    print('DateTime: ${timeSeries.dateTime}');
    print('PlaceName: $truncatedPlaceName');

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: WeatherInfoWidget(
        municipalita: truncatedPlaceName,
        dateTime: timeSeries.dateTime.toString(),
        iconAssetPath: timeSeries.icon.toString(),
        iconDescription: timeSeries.winds.toString(),
        temperature: timeSeries.t2C.toString().split('.')[0],
        description: timeSeries.text?.it ?? '',
        vento: timeSeries.wd10.toString(),
        velocitaVento: timeSeries.ws10.toString(),
        umidita: timeSeries,
        airQuality: (timeSeries.dwd10! * 2).toString(),
        probPioggia: (timeSeries.rh2! / 10).toStringAsFixed(2),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
