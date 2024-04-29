import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class SingleCourseCard extends StatelessWidget {
  final int index;

  final String cfuExam;
  final String titleExam;
  final String status;

  const SingleCourseCard(
      {Key? key,
      required this.index,
      required this.cfuExam,
      required this.titleExam,
      required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor = getStatusColor(status);

    return Card(
      color: AppColors.primaryColor,
      elevation: 4, // Altezza della card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bordo arrotondato
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor,
                border: Border.all(
                  color: AppColors.lightGray, // Colore del bordo interno
                  width: 4, // Spessore del bordo interno
                ),
              ),
              child: Center(
                child: Text(
                  '$cfuExam\nCFU', // Testo cerchio destro
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    //ontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColors.lightGray,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 20), // Spazio tra lo status e il testo
            // Testo centrale
            Expanded(
              child: Text(
                titleExam, // Testo centrale
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12), // Spazio tra il testo e status
            // Status
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5), // Spazio tra il testo e il pallino
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor, // Colore del pallino
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Metodo per ottenere il colore dello status in base al suo valore
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'superato':
        return Colors.green; // Verde per "superato"
      case 'non fatto':
        return Colors.red; // Rosso per "non fatto"
      default:
        return Colors.grey; // Grigio per qualsiasi altro status
    }
  }
}
