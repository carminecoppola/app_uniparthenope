import 'package:appuniparthenope/widget/ServicesWidget/WeatherWidget/singleWeatherCard.dart';
import 'package:appuniparthenope/widget/ServicesWidget/WeatherWidget/weatherInfoCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/weather_provider.dart';
import 'package:appuniparthenope/main.dart';

class CarouselCard extends StatefulWidget {
  const CarouselCard({Key? key});

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
          height: 400,
          child: Card(
            color: AppColors.primaryColor,
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: Provider.of<WeatherDataProvider>(context)
                      .timeSeriesList
                      .length ??
                  0,
              itemBuilder: (BuildContext context, int index) {
                return _buildCarouselItem(index);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            Provider.of<WeatherDataProvider>(context).timeSeriesList.length ??
                0,
            (index) => _buildDot(index),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(int index) {
    final timeSeries =
        Provider.of<WeatherDataProvider>(context).timeSeriesList[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
