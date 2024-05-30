import 'package:flutter/material.dart';

import '../../../../main.dart';

class LabelValueText extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueText({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.detailsColor,
            ),
            maxLines: null, // Permette al testo di andare a capo
          ),
        ],
      ),
    );
  }
}
