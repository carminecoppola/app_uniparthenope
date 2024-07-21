import 'package:appuniparthenope/main.dart'; // Importa il file main.dart che contiene le costanti dei colori dell'app
import 'package:flutter/material.dart';

class ProgressCircleCounter extends StatelessWidget {
  final int totalCount; // Numero totale di esami
  final int completedExams; // Numero di esami superati
  final Color textColor;

  const ProgressCircleCounter({
    super.key,
    required this.totalCount,
    required this.completedExams,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Calcola la percentuale di completamento
    double completionPercentage = completedExams / totalCount;

    // Determina il colore del cerchio in base alla percentuale
    Color circleColor;
    if (completionPercentage == 1.0) {
      circleColor = AppColors.successColor; // Verde se completato
    } else {
      circleColor = AppColors.detailsColor; // Colore personalizzato
    }

    return Stack(alignment: Alignment.center, children: [
      // Cerchio di caricamento
      SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
              value: completionPercentage, // Valore di completamento (da 0 a 1)
              backgroundColor: const Color.fromARGB(255, 187, 187, 187),
              valueColor: AlwaysStoppedAnimation<Color>(circleColor),
              strokeWidth: 10)),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            completedExams.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          Text(
            '/${totalCount.toString()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ]);
  }
}
