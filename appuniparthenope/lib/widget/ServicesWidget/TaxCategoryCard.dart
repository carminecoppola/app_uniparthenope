// TaxCategoryCard.dart
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class TaxCategoryCard extends StatelessWidget {
  final String title;
  final Color iconColor;
  final Color backgroundColor;
  final List<Widget> children;

  const TaxCategoryCard({
    super.key,
    required this.title,
    required this.iconColor,
    required this.backgroundColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: AppColors.lightGray,
      elevation: 4,
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        children: children.isEmpty // Verifica se non ci sono tasse da pagare
            ? [
                const Padding(
                  padding: EdgeInsets.all(16.0), // Aggiunta del margine
                  child: Text(
                    'Non ci sono tasse da pagare',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ]
            : children, // Altrimenti mostra le tasse
      ),
    );
  }
}
