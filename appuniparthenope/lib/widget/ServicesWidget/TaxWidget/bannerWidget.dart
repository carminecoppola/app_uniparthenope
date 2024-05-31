import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:provider/provider.dart';

import '../../../provider/taxes_provider.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key});

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
            'Situazione attuale: ${getStatus(allTaxesInfo?.semaforo)}', // Modificato qui
            style: TextStyle(
              fontSize: 18,
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

  String getStatus(String? status) {
    // Modificato qui
    if (status == 'ROSSO') {
      return 'Scadute';
    } else if (status == 'GIALLO') {
      return 'Da pagare';
    } else if (status == 'VERDE') {
      return 'Regolare';
    } else {
      return 'Non definita';
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
