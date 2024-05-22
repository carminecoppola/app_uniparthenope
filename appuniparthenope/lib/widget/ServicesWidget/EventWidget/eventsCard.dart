import 'package:appuniparthenope/widget/ServicesWidget/EventWidget/seatAvailability.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class EventsCard extends StatelessWidget {
  final String title;
  final String aula;
  final String descrizioneAula;
  final String dateI;
  final String timeI;
  final String dateF;
  final String timeF;
  final int totalSeats;
  final int occupiedSeats;

  const EventsCard({
    super.key,
    required this.title,
    required this.aula,
    required this.descrizioneAula,
    required this.dateI,
    required this.timeI,
    required this.dateF,
    required this.timeF,
    required this.totalSeats,
    required this.occupiedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColor,
      elevation: 9,
      margin: const EdgeInsets.all(14.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '\u2022 Aula: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '$aula ($descrizioneAula)',
                    style: const TextStyle(
                      color: AppColors.detailsColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\u2022 Inizio: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: dateI,
                        style: const TextStyle(
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\u2022 Ora: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: timeI,
                        style: const TextStyle(
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\u2022 Fine: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: dateF,
                        style: const TextStyle(
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '\u2022 Ora: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: timeF,
                        style: const TextStyle(
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Posti:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    width: 10), // Aggiunge uno spazio tra il testo e il cerchio
                SizedBox(
                  width: 50, // Imposta la larghezza desiderata
                  height: 50, // Imposta l'altezza desiderata
                  child: ProgressiveCircleSeat(
                    totalSeats: totalSeats,
                    availableSeats: occupiedSeats,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
