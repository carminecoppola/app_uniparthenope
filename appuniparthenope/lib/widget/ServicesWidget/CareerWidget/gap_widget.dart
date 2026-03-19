import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class GPAProgressIndicator extends StatelessWidget {
  final double? gpa;

  const GPAProgressIndicator({super.key, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Grade Point Average (GPA)',
            style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 20),
          CircularProgressIndicator(
            value: gpa, // Utilizza il valore del GPA come progresso del cerchio
          ),
          const SizedBox(height: 10),
          Text(
            'GPA: ${gpa?.toStringAsFixed(2)}', // Visualizza il valore del GPA
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
