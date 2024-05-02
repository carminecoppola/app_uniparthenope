import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class SingleExamCard extends StatelessWidget {
  final int index;

  final String cfuExam;
  final String titleExam;
  final String voteExam;
  final String dateExam;

  const SingleExamCard(
      {super.key,
      required this.index,
      required this.cfuExam,
      required this.titleExam,
      required this.voteExam,
      required this.dateExam});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryColor,
      elevation: 8, // Altezza della card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bordo arrotondato
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Cerchio sinistro
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white, // Colore del bordo
                  width: 5, // Spessore del bordo
                ),
              ),
              child: Center(
                child: Text(
                  voteExam, // Testo cerchio sinistro
                  style: const TextStyle(
                    color: AppColors.detailsColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Spazio tra i cerchi e il testo
            // Testo centrale
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleExam,
                    style: const TextStyle(
                      color: AppColors.backgroundColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    dateExam,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            //const SizedBox(height: 5),

            const SizedBox(
                width: 10), // Spazio tra il testo e il cerchio destro
            // Cerchio destro
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor,
                border: Border.all(
                  color: AppColors.backgroundColor, // Colore del bordo interno
                  width: 5, // Spessore del bordo interno
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.backgroundColor
                        .withOpacity(0.2), // Colore dell'ombra
                    spreadRadius: 2, // Estensione dell'ombra
                    blurRadius: 5, // Sfocatura dell'ombra
                    offset: const Offset(0, 2), // Direzione dell'ombra
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$cfuExam\nCFU', // Testo cerchio destro
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.lightGray,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
