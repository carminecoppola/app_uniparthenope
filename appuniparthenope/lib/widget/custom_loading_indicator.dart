import 'dart:async';

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
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(widget.timeoutDuration, () {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(widget.myColor),
                strokeWidth: 5.0,
              ),
            ),
            // Replace this with your own logo asset
            Image.asset(
              'assets/logo.png',
              width: 60,
              height: 60,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: widget.myColor,
          ),
        ),
      ],
    );
  }
}
