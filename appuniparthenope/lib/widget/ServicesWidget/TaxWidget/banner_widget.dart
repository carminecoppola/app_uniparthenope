import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:provider/provider.dart';

import '../../../provider/taxes_provider.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final allTaxesInfo = Provider.of<TaxesDataProvider>(context).allTaxesInfo;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 229, 229, 229),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppLocalizations.of(context).translate('actual_situation')}: ${getStatus(allTaxesInfo?.semaforo, context)}', // Modificato qui
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  getColorForStatus(allTaxesInfo?.semaforo), // Modificato qui
            ),
          ),
          getIconForStatus(allTaxesInfo?.semaforo), // Modificato qui
        ],
      ),
    );
  }

  String getStatus(String? status,context) {
    // Modificato qui
    if (status == 'ROSSO') {
      return AppLocalizations.of(context).translate('not_regular');
    } else if (status == 'GIALLO') {
      return AppLocalizations.of(context).translate('not_paid');
    } else if (status == 'VERDE') {
      return AppLocalizations.of(context).translate('regular');
    } else {
      return AppLocalizations.of(context).translate('not_available');
    }
  }

  Icon getIconForStatus(String? status) {
    // Modificato qui
    if (status == 'ROSSO') {
      return const Icon(
        Icons.error,
        color: AppColors.errorColor,
      );
    } else if (status == 'GIALLO') {
      return const Icon(
        Icons.warning,
        color: AppColors.detailsColor,
      );
    } else if (status == 'VERDE') {
      return const Icon(
        Icons.check_circle,
        color: AppColors.successColor,
      );
    } else {
      return const Icon(
        Icons.error_outline,
        color: AppColors.lightGray,
      );
    }
  }

  Color getColorForStatus(String? status) {
    // Modificato qui
    if (status == 'ROSSO') {
      return AppColors.errorColor;
    } else if (status == 'GIALLO') {
      return AppColors.detailsColor;
    } else if (status == 'VERDE') {
      return AppColors.successColor;
    } else {
      return AppColors.lightGray;
    }
  }
}
