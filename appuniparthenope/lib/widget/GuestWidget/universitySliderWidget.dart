import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

import 'universityWidget.dart';

class UniversitySliderWidget extends StatefulWidget {
  const UniversitySliderWidget({super.key});

  @override
  _UniversitySliderWidgetState createState() => _UniversitySliderWidgetState();
}

class _UniversitySliderWidgetState extends State<UniversitySliderWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<UniversityInfo> sedeInfo = [
      UniversityInfo(
        nome: 'Monte S. Angelo',
        descrizione: AppLocalizations.of(context).translate('monte_s_angelo'),
        indirizzo: 'Via Generale Parisi, 13, 80132 Napoli NA',
        immagini: [
          'assets/university/uni_monte.jpg',
          'assets/university/caroselloSedi/SedePaca1.png',
          'assets/university/caroselloSedi/SedePaca2.png',
          'assets/university/caroselloSedi/SedePaca3.png',
          'assets/university/caroselloSedi/SedePaca4.png',
          'assets/university/caroselloSedi/SedePaca5.png',
          'assets/university/caroselloSedi/SedePaca6.png',
          // altre immagini
        ],
      ),
      UniversityInfo(
        nome: 'Centro Direzionale',
        descrizione:
            AppLocalizations.of(context).translate('centro_direzionale'),
        indirizzo: 'Centro Direzionale ISOLA C4, 80133 Napoli',
        immagini: [
          'assets/university/caroselloSedi/SedeCD0.png',
          'assets/university/caroselloSedi/SedeCD1.png',
          'assets/university/caroselloSedi/SedeCD2.png',
          'assets/university/caroselloSedi/SedeCD3.png',
          'assets/university/caroselloSedi/SedeCD4.png',
          'assets/university/caroselloSedi/SedeCD5.png',
          'assets/university/caroselloSedi/SedeCD6.png',
          'assets/university/caroselloSedi/SedeCD7.png',
          'assets/university/caroselloSedi/SedeCD8.png',
          // altre immagini
        ],
      ),
      UniversityInfo(
        nome: 'Sede Centrale',
        descrizione: AppLocalizations.of(context).translate('sede_centrale'),
        indirizzo: 'Via Ammiraglio Ferdinando Acton, 38, 80133 Napoli NA',
        immagini: [
          'assets/university/caroselloSedi/SedeC1.jpg',
          'assets/university/caroselloSedi/SedeC2.png',
          'assets/university/caroselloSedi/SedeC3.png',
          'assets/university/caroselloSedi/SedeC4.png',
          'assets/university/caroselloSedi/SedeC5.png',
          'assets/university/caroselloSedi/SedeC6.png',
        ],
      ),
      UniversityInfo(
        nome: 'Villa Doria',
        descrizione: AppLocalizations.of(context).translate('villa_doria'),
        indirizzo: 'Via Francesco Petrarca, 80, 80123 Napoli NA',
        immagini: [
          'assets/university/caroselloSedi/SedeVDA0.png',
          'assets/university/caroselloSedi/SedeVDA1.png',
          'assets/university/caroselloSedi/SedeVDA2.png',
          'assets/university/caroselloSedi/SedeVDA3.png',
          'assets/university/caroselloSedi/SedeVDA4.png',
          'assets/university/caroselloSedi/SedeVDA5.png',
          'assets/university/caroselloSedi/SedeVDA6.png',
          // altre immagini
        ],
      ),
      UniversityInfo(
        nome: 'Via Medina',
        descrizione: AppLocalizations.of(context).translate('monte_s_angelo'),
        indirizzo: 'Via Medina, 40, 80133 Napoli NA',
        immagini: [
          'assets/university/caroselloSedi/SedeMed0.png',
          'assets/university/caroselloSedi/SedeMed1.png'
          // altre immagini
        ],
      ),
      UniversityInfo(
        nome: 'Nola',
        descrizione: AppLocalizations.of(context).translate('nola'),
        indirizzo: 'Via Guglielmo Pepe, Nola (NA)',
        immagini: [
          'assets/university/uni_nola.jpeg',
          // altre immagini
        ],
      )
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: (sedeInfo.length / 2).ceil(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              int firstIndex = index * 2;
              int secondIndex = firstIndex + 1;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (firstIndex < sedeInfo.length)
                    UniversityCardWidget(
                      universityInfo: sedeInfo[firstIndex],
                    ),
                  if (secondIndex < sedeInfo.length)
                    UniversityCardWidget(
                      universityInfo: sedeInfo[secondIndex],
                    ),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate((sedeInfo.length / 2).ceil(), (index) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? AppColors.primaryColor
                    : AppColors.lightGray,
              ),
            );
          }),
        ),
      ],
    );
  }
}
