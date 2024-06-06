import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

import '../../widget/GuestWidget/contactWidget.dart';
import '../../widget/GuestWidget/universityWidget.dart';

class HomeGuestPage extends StatefulWidget {
  const HomeGuestPage({super.key});

  @override
  _HomeGuestPageState createState() => _HomeGuestPageState();
}

class _HomeGuestPageState extends State<HomeGuestPage> {
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showDescription = !showDescription;
                        });
                      },
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (showDescription)
                      const Text(
                        'Dal 1919, il nostro Ateneo abbraccia con passione il compito di guidare i giovani verso il successo. Con oltre 15.000 studenti, 320 docenti e 250 membri del personale, offriamo un\'istruzione solida e flessibile, con uno sguardo internazionale. Mettiamo gli studenti al centro, preparandoli per ruoli di leadership. La nostra tradizione centenaria si fonde con l\'innovazione, espandendo le nostre aree di eccellenza in economia, legge, ingegneria e benessere. La ricerca multidisciplinare e internazionale è il nostro contributo al progresso del sapere, in dialogo costante con il mondo del lavoro e delle imprese.',
                        style:
                            TextStyle(fontSize: 10, color: AppColors.lightGray),
                      ),
                    if (!showDescription)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDescription = !showDescription;
                          });
                        },
                        child: const Text(
                          'Chi siamo...',
                          style: TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              color: AppColors.primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Le nostre sedi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(6, (index) {
                        final sedeInfo = [
                          {
                            'nome': 'Monte S. Angelo',
                            'immagine': 'assets/university/uni_monte.jpg'
                          },
                          {
                            'nome': 'Centro Direzionale',
                            'immagine': 'assets/university/uni_cdn.png'
                          },
                          {
                            'nome': 'Sede Centrale',
                            'immagine': 'assets/university/uni_centrale.png'
                          },
                          {
                            'nome': 'Via Medina',
                            'immagine': 'assets/university/uni_medina.jpeg'
                          },
                          {
                            'nome': 'Nola',
                            'immagine': 'assets/university/uni_nola.jpeg'
                          },
                          {
                            'nome': 'Villa Doria',
                            'immagine': 'assets/university/uni_villadoria.jpeg'
                          },
                        ];
                        return UniversityCardWidget(
                          nome: sedeInfo[index]['nome']!,
                          immagine: sedeInfo[index]['immagine']!,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const ContactSection(),
            ],
          ),
        ),
      ),
    );
  }
}
