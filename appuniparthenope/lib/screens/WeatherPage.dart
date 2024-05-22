import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/weather_timeSerys_data.dart';
import '../provider/weather_provider.dart';
import '../widget/ServicesWidget/weatherInfoWidget.dart';
import '../widget/bottomNavBar.dart';
import '../widget/CustomLoadingIndicator.dart';
import '../widget/navbar.dart';

class WeatherUniPage extends StatelessWidget {
  const WeatherUniPage({super.key});

  @override
  Widget build(BuildContext context) {
    final placeName = Provider.of<WeatherDataProvider>(context).placeName;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Weather',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              '@Uniparthenope',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Container(
              width: 120,
              height: 2,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 50),
            // Card Meteo
            Center(
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
                          placeName, //Qui
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
                                    final Timesery timeSeries =
                                        allTimeSeries[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: WeatherInfoWidget(
                                        dateTime:
                                            timeSeries.dateTime.toString(),
                                        iconAssetPath:
                                            timeSeries.icon.toString(),
                                        iconDescription:
                                            timeSeries.winds.toString(),
                                        temperature: timeSeries.t2C.toString(),
                                        description:
                                            timeSeries.text!.it.toString(),
                                        vento: timeSeries.wd10.toString(),
                                        velocitaVento:
                                            timeSeries.ws10.toString(),
                                        umidita: timeSeries,
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
            ),
            const SizedBox(height: 40),
            // Card Download
            GestureDetector(
              onTap: () {
                //Link download
              },
              child: SizedBox(
                width: 350,
                height: 100,
                child: Card(
                  color: AppColors.primaryColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/meteoUniLogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Text(
                            "Scarica la nostra app",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
