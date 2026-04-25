import 'package:appuniparthenope/main.dart'; // Importa il file main.dart che contiene le costanti dei colori dell'app
import 'package:flutter/material.dart';

class ProgressCircleCounter extends StatelessWidget {
  final int totalCount; // Numero totale di esami
  final int completedExams; // Numero di esami superati
  final Color textColor;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? secondaryTextColor;

  const ProgressCircleCounter({
    super.key,
    required this.totalCount,
    required this.completedExams,
    required this.textColor,
    this.size = 100,
    this.strokeWidth = 10,
    this.backgroundColor,
    this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    double completionPercentage = completedExams / totalCount;
    Color circleColor;
    if (completionPercentage == 1.0) {
      circleColor = AppColors.successColor;
    } else {
      circleColor = AppColors.detailsColor;
    }

    return Container(
      width: size + 20,
      height: size + 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size + 8,
            height: size + 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: completionPercentage,
              strokeCap: StrokeCap.round,
              backgroundColor:
                  backgroundColor ?? Colors.white.withValues(alpha: 0.18),
              valueColor: AlwaysStoppedAnimation<Color>(circleColor),
              strokeWidth: strokeWidth,
            ),
          ),
          Container(
            width: size - (strokeWidth * 2.4),
            height: size - (strokeWidth * 2.4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                completedExams.toString(),
                style: TextStyle(
                  fontSize: size * 0.24,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              Text(
                '/$totalCount',
                style: TextStyle(
                  fontSize: size * 0.13,
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
