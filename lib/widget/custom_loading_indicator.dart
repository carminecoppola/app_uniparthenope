import 'dart:async';
import 'dart:math' as math;

import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  final String text;
  final Color myColor;
  final Duration timeoutDuration;

  const CustomLoadingIndicator({
    super.key,
    required this.text,
    required this.myColor,
    this.timeoutDuration =
        const Duration(minutes: 1), // Imposta il timeout predefinito a 1 minuto
  });

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(widget.timeoutDuration, () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore nel caricamento dei dati'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: widget.myColor.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDarkColor.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * math.pi * 2,
                  child: CustomPaint(
                    size: const Size(92, 92),
                    painter: _LoadingRingPainter(color: widget.myColor),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 78,
                height: 78,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.myColor.withValues(alpha: 0.10),
                      AppColors.primaryLightColor.withValues(alpha: 0.18),
                    ],
                  ),
                ),
                child: Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.myColor.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                height: 1.25,
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [
                    widget.myColor.withValues(alpha: 0.35),
                    AppColors.detailsColor.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  final Color color;

  const _LoadingRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const strokeWidth = 5.0;
    final basePaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.05),
          color,
          AppColors.detailsColor,
          color.withValues(alpha: 0.05),
        ],
        stops: const [0.0, 0.45, 0.72, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 1.45,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoadingRingPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
