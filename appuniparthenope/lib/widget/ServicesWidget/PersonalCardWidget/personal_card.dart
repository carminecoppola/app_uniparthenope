import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'avatar_widget.dart';

class PersonalCardWidget extends StatelessWidget {
  final String? nome;
  final String? cognome;
  final String? identificativoLabel;
  final String? identificativo;

  const PersonalCardWidget({
    super.key,
    required this.nome,
    required this.cognome,
    required this.identificativoLabel,
    this.identificativo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AvatarWidget(),
            const SizedBox(height: 10),
            Text(
              '${toCamelCase(nome!)} ${toCamelCase(cognome!)}',
              style: const TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              identificativo ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.detailsColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
