import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class InfoStudentTemplate extends StatelessWidget {
  final String idText;
  final String contentText;

  const InfoStudentTemplate({
    super.key,
    required this.idText,
    required this.contentText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Aggiungi spazio
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            idText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            contentText,
            style: const TextStyle(
              color: AppColors.detailsColor,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
