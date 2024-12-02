import 'package:flutter/material.dart';
import '../main.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Configurazione per il bordo giallo (spesso e solo sulle curve)
    final borderPaint = Paint()
      ..color = AppColors.detailsColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Configurazione per il riempimento
    final fillPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Onda superiore (bordo solo nella parte inferiore)
    Path topWavePath = Path()
      ..lineTo(0, 200)
      // Curva 1 (parte inferiore)
      ..quadraticBezierTo(size.width / 4, 50, size.width / 2, 200)
      // Curva 2 (parte inferiore)
      ..quadraticBezierTo(size.width * 3 / 4, 350, size.width, 200)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    // Disegna il riempimento dell'onda superiore
    canvas.drawPath(topWavePath, fillPaint);
    // Disegna il bordo solo nella parte inferiore (curva)
    Path topWaveBorder = Path()
      ..moveTo(0, 200)
      // Curva 1
      ..quadraticBezierTo(size.width / 4, 50, size.width / 2, 200)
      // Curva 2
      ..quadraticBezierTo(size.width * 3 / 4, 350, size.width, 200);
    // Disegna il bordo dell'onda superiore
    canvas.drawPath(topWaveBorder, borderPaint);

    // Onda inferiore (bordo solo nella parte superiore)
    Path bottomWavePath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - 100) // Ridotto per un'onda inferiore più bassa
      // Curva 3 (parte superiore)
      ..quadraticBezierTo(
          size.width / 4, size.height - 50, size.width / 2, size.height - 100)
      // Curva 4 (parte superiore)
      ..quadraticBezierTo(
          size.width * 3 / 4, size.height - 150, size.width, size.height - 100)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Disegna il riempimento dell'onda inferiore
    canvas.drawPath(bottomWavePath, fillPaint);
    // Disegna il bordo solo nella parte superiore (curva)
    Path bottomWaveBorder = Path()
      ..moveTo(0, size.height - 100)
      // Curva 3
      ..quadraticBezierTo(
          size.width / 4, size.height - 50, size.width / 2, size.height - 100)
      // Curva 4
      ..quadraticBezierTo(
          size.width * 3 / 4, size.height - 150, size.width, size.height - 100);
    // Disegna il bordo dell'onda inferiore
    canvas.drawPath(bottomWaveBorder, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//For loginPage I created a new class called BottomWavePainter
class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Configurazione per il riempimento
    final fillPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Onda inferiore (senza bordi)
    Path bottomWavePath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - 100) // Ridotto per un'onda inferiore più bassa
      // Curva 1 (parte superiore)
      ..quadraticBezierTo(
          size.width / 4, size.height - 50, size.width / 2, size.height - 100)
      // Curva 2 (parte superiore)
      ..quadraticBezierTo(
          size.width * 3 / 4, size.height - 150, size.width, size.height - 100)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Disegna il riempimento dell'onda inferiore
    canvas.drawPath(bottomWavePath, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
