import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String adDes;
  final String cdsDes;
  final String inizio;
  final String fine;
  final String ultMod;
  final String sede;

  const CourseCard({
    Key? key,
    required this.adDes,
    required this.cdsDes,
    required this.inizio,
    required this.fine,
    required this.ultMod,
    required this.sede,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Card(
        color: AppColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adDes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cdsDes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inizio: $inizio',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                'Fine: $fine',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                'Ultima Modifica: $ultMod',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                'Sede: $sede',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
