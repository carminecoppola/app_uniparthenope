import 'package:flutter/material.dart';

import '../../main.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: AppColors.primaryColor,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
