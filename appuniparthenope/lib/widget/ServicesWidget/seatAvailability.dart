import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class ProgressiveCircleSeat extends StatelessWidget {
  final int totalSeats; // Numero totale di posti disponibili
  final int availableSeats; // Numero di posti disponibili

  const ProgressiveCircleSeat({
    super.key,
    required this.totalSeats,
    required this.availableSeats,
  });

  @override
  Widget build(BuildContext context) {
    // Calcola la percentuale di posti disponibili
    double availablePercentage = availableSeats / totalSeats;

    // Determina il colore del cerchio in base alla percentuale di posti disponibili
    Color circleColor;
    if (availablePercentage > 0.5) {
      circleColor =
          AppColors.successColor; // Verde se più della metà disponibili
    } else {
      circleColor = AppColors.detailsColor;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Cerchio di caricamento
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value:
                availablePercentage, // Valore di posti disponibili (da 0 a 1)
            backgroundColor: Colors.transparent, // Colore di sfondo del cerchio
            valueColor: AlwaysStoppedAnimation<Color>(
                circleColor), // Colore del cerchio
            strokeWidth: 5, // Spessore del cerchio
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              availableSeats.toString(),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: AppColors.detailsColor,
              ),
            ),
            Text(
              '/${totalSeats.toString()}',
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
