import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class TaxStudentCard extends StatelessWidget {
  final String title;
  final String codInvoice;
  final String codIUR;
  final String date;
  final String amount;
  final bool isPaid; // Nuovo parametro

  const TaxStudentCard({
    super.key,
    required this.title,
    required this.codInvoice,
    required this.codIUR,
    required this.date,
    required this.amount,
    required this.isPaid, // Nuovo parametro
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailsDialog(context),
      child: SizedBox(
        width: 320, // Imposta la larghezza fissa della card
        height: 130, // Imposta l'altezza fissa della card
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.all(10.0),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      onPressed: () => _showDetailsDialog(context),
                    ),
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.lightGray,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    amount,
                    style: TextStyle(
                      fontSize: 15,
                      color: isPaid
                          ? AppColors.successColor
                          : AppColors
                              .detailsColor, // Cambia colore in base a isPaid
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: isPaid
                          ? AppColors.successColor
                          : AppColors.detailsColor, // Cambia colore anche qui
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow('Cod. Invoice', codInvoice),
                _buildDetailRow('IUR', codIUR.toUpperCase(), isValueLong: true),
                _buildDetailRow(
                    AppLocalizations.of(context).translate('date'), date),
                _buildDetailRow(
                    AppLocalizations.of(context).translate('price'), amount),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).translate('close'),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isValueLong = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.lightGray,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isValueLong ? 12 : 16,
                color: isPaid
                    ? AppColors.successColor
                    : AppColors.detailsColor, // Cambia colore in base a isPaid
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
