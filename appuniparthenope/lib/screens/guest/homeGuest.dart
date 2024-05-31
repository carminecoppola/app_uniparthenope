import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeGuestPage extends StatefulWidget {
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
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage(sedeInfo[index]['immagine']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                sedeInfo[index]['nome']!,
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  backgroundColor:
                                      Color.fromARGB(255, 226, 226, 226),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contatti',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.facebook,
                            color: AppColors.primaryColor,
                            size: 50,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            FontAwesomeIcons.instagram,
                            color: AppColors.primaryColor,
                            size: 50,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            FontAwesomeIcons.envelope,
                            color: AppColors.primaryColor,
                            size: 50,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            FontAwesomeIcons.linkedin,
                            color: AppColors.primaryColor,
                            size: 50,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            FontAwesomeIcons.youtube,
                            color: AppColors.primaryColor,
                            size: 50,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: AppColors.primaryColor,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '+39 081 1234567',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: AppColors.primaryColor,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Indirizzo: Via Università, 1, Napoli',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.maps_home_work_outlined,
                            color: AppColors.primaryColor,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Sede centrale: Via Amm. F. Acton, 38 - 80133 Napoli, ITALY',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.fileInvoice,
                            color: AppColors.primaryColor,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'P.IVA 01877320638 - C.F. 80018240632',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
