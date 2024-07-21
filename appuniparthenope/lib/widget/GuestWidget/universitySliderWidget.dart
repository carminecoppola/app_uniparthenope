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
        descrizione:
            'Il Palazzo Pacanowski è situato a Napoli, in Via Generale Parisi n. 13, nelle adiacenze della Scuola Militare Nunziatella. L’edificio, espressione tipica dell’architettura italiana degli anni ‘50, presenta una struttura a forma di U, con una corte rivolta a sud, che si apre in direzione del mare. Particolarmente caratteristici sono i giardini del palazzo, attraversati da viali alberati con piante di alto fusto.\n\nIl Palazzo costituisce la sede della Scuola Economico Giuridica cui afferiscono i seguenti Dipartimenti:\n\n- Dipartimento di Giurisprudenza\n- Dipartimento di Studi Aziendali ed Economici\n- Dipartimento di Studi Aziendali e Quantitativi\n- Dipartimento di Studi Economici e Giuridici',
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
            'Il Centro Direzionale ospita il Dipartimento di Ingegneria e del Dipartimento di Scienze e Tecnologie. La struttura, che sorge a ridosso della stazione di Napoli Centrale, è costituita da un insieme di moderni grattacieli, che rientrano all’interno di un più ampio complesso urbano, progettato dall’architetto giapponese Kenzō Tange.',
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
        descrizione:
            'La sede centrale dell’Università degli Studi di Napoli “Parthenope” è collocata in Via Ammiraglio Ferdinando Acton n. 38 e consiste di un complesso monumentale storico risalente al XVI secolo, la “Palazzina Spagnola”, e di un un fabbricato più moderno realizzato alla fine degli anni ’60.',
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
        descrizione: '''
Villa Doria d’Angri è una delle più importanti ville neoclassiche italiane.

La villa, che si erge maestosa su uno sperone tufaceo della collina di Posillipo, fu costruita per volere del principe Marcantonio Doria d’Angri, ultimo esponente di spicco della nobile famiglia di origine genovese. All’interno di un vasto appezzamento di terreno, in parte ripido e scosceso, in parte dolcemente degradante lungo il crinale, la dimora di svago doveva avere un carattere aulico, consono al ruolo di prestigio che il principe rivestiva in quegli anni a corte.

La proprietà dei Doria si estendeva lungo il crinale della collina e arrivava alla spiaggia di Mergellina con terrazzamenti di vigneti ed alberi da frutto. La tenuta era pervenuta alla nobile famiglia nel 1592 per donazione di Vittoria Carafa, fu trasformata da masseria in residenza principesca neoclassica per opera dell’architetto Bartolomeo Grasso e completata nel 1833. Rappresenta, inoltre, un segno tangibile del rango che avevano i Doria e delle loro tradizioni marinaresche.

Dopo la morte del principe Marcantonio nel 1837 venne ceduta in fitto e, successivamente, nel 1857, venduta alla nobile inglese Ellinor Giovanna Susanna Maitland. L’edificio fa parte dal 1998 del patrimonio immobiliare dell’Università degli Studi di Napoli Parthenope ed è destinata all’alta formazione, ai convegni scientifici nazionali ed internazionali, agli incontri culturali. Inoltre, è sede della preziosa collezione di modelli statici di navi e parti di imbarcazioni mercantili e militari, strumenti nautici e attrezzature conservate all’interno del Museo Navale.
  ''',
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
        descrizione:
            'In Via Medina, in un fabbricato dell’inizio degli anni ’50 ad angolo con Piazza Municipio, ha sede il Dipartimento di scienze motorie e del benessere.',
        indirizzo: 'Via Medina, 40, 80133 Napoli NA',
        immagini: [
          'assets/university/caroselloSedi/SedeMed0.png',
          'assets/university/caroselloSedi/SedeMed1.png'
          // altre immagini
        ],
      ),
      UniversityInfo(
        nome: 'Nola',
        descrizione:
            'Il campus di Nola ospita tre corsi di laurea triennale in “Economia & Management”, “Ingegneria e Scienze Informatiche per la Cybersecurity” e “Scienze Motorie” e un corso di laurea magistrale a ciclo unico in “Giurisprudenza”.',
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
