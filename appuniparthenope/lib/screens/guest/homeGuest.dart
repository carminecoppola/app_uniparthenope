import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import '../../widget/GuestWidget/contactWidget.dart';
import '../../widget/GuestWidget/universitySliderWidget.dart';

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
      appBar: const NavbarComponent(role: 'Guest'),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'La nostra Storia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (showDescription)
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          text:
                              'Dal 1919, il nostro Ateneo abbraccia con passione il compito di guidare i giovani verso il successo. \n'
                              'Con oltre 15.000 studenti, 320 docenti e 250 membri del personale, offriamo un\'istruzione solida e flessibile, con uno sguardo internazionale.\n'
                              ' Mettiamo gli studenti al centro, preparandoli per ruoli di leadership. La nostra tradizione centenaria si fonde con l\'innovazione, espandendo le nostre aree di eccellenza in economia, legge, ingegneria e benessere.\n'
                              ' La ricerca multidisciplinare e internazionale è il nostro contributo al progresso del sapere, in dialogo costante con il mondo del lavoro e delle imprese.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightGray,
                          ),
                        ),
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
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              color: AppColors.primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Le nostre sedi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Qui puoi visualizzare le sedi del nostro ateneo con l\'opportunità di conoscere meglio ciascuna di esse.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGray,
                      ),
                    ),
                    SizedBox(height: 15),
                    UniversitySliderWidget(),
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
