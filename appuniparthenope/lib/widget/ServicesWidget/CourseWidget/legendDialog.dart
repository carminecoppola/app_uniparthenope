import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

void showLegendDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Legenda Stato',
            style: TextStyle(
              color: AppColors.detailsColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: AppColors.detailsColor, thickness: 2),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem(
                      'Attività Didattica Pianificata', AppColors.detailsColor),
                  _legendItem('Attività Didattica Non frequentata',
                      AppColors.lightGray),
                  _legendItem(
                      'Attività Didattica Frequentata', AppColors.accentColor),
                  _legendItem(
                      'Riconosciuta intera Attività', AppColors.successColor),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Chiudi',
              style: TextStyle(
                  color: AppColors.detailsColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

Widget _legendItem(String text, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.textColor, width: 1),
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}
