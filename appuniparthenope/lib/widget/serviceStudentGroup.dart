import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String root;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.root,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, root);
      },
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            const SizedBox(height: 2),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 170,
                height: 170,
                alignment: Alignment.center,
                child: Image.asset(imagePath),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 160,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Gruppo Card Studenti
class ServiceGroupStudentCard extends StatelessWidget {
  const ServiceGroupStudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    child: const ServiceCard(
                      imagePath: 'assets/icon/student.png',
                      title: 'Carriera',
                      description:
                          'Qui puoi visualizzare i dettagli relativi agli esami che hai superato.',
                      root: '/carrerStudent',
                    ),
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  const ServiceCard(
                    imagePath: 'assets/icon/courses.png',
                    title: 'Corsi',
                    description:
                        'Puoi visualizzare per ogni anno accademico i corsi da seguire.',
                    root: '/courseStudent',
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  const ServiceCard(
                    imagePath: 'assets/icon/tax.png',
                    title: 'Tasse Universitarie',
                    description:
                        'Puoi tenere sotto controllo la situazione delle tasse universitarie qui.',
                    root: '/feesStudent',
                  ),
                  const SizedBox(width: 5), // Spazio tra le card
                  const ServiceCard(
                    imagePath: 'assets/icon/weather.png',
                    title: 'Meteo Uniparthenope',
                    description:
                        'Qui puoi utilizzare il nostro servizio meteorologico dell\'Università Parthenope.',
                    root: '/watherStudent',
                  ),
                  const SizedBox(width: 5), // Spazio finale per l'estetica
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
