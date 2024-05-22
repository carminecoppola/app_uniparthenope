import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class TaxStudentCard extends StatelessWidget {
  final String title;
  final String codInvoice;
  final String codIUR;
  final String date;
  final String amount;

  const TaxStudentCard({
    super.key,
    required this.title,
    required this.codInvoice,
    required this.codIUR,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320, // Imposta la larghezza fissa della card
      height: 170, // Imposta l'altezza fissa della card
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10.0),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\u2022 Cod. Invoice: $codInvoice',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\u2022 IUR: $codIUR',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryColor,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.primaryColor,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
