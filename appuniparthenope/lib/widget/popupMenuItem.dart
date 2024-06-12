import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuItemBuilder {
  static PopupMenuItem buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return PopupMenuItem(
      padding: const EdgeInsets.all(5.0),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0), // Aggiungi padding al contenitore
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(
                  255, 192, 192, 192)), // Aggiungi un bordo
          borderRadius: BorderRadius.circular(20.0), // Bordi arrotondati
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
            ), // Icona
            const SizedBox(width: 10), // Spazio tra l'icona e il testo
            Text(
              text,
              style: TextStyle(
                color: textColor ?? AppColors.primaryColor, // Colore del testo
                fontSize: fontSize ?? 16, // Dimensione del testo
                fontWeight:
                    fontWeight ?? FontWeight.bold, // Grassetto del testo
                fontFamily: fontFamily ?? 'Roboto', // Font del testo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
