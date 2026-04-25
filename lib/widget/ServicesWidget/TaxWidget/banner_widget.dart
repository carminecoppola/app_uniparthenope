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
    final statusColor = getColorForStatus(allTaxesInfo?.semaforo);
    final statusLabel = getStatus(allTaxesInfo?.semaforo, context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.12),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: statusColor.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: getIconForStatus(allTaxesInfo?.semaforo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('actual_situation'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDarkColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getStatus(String? status, context) {
    // Modificato qui
    if (status == 'ROSSO') {
      return AppLocalizations.of(context).translate('not_regular');
    } else if (status == 'GIALLO') {
      return AppLocalizations.of(context).translate('not_paid');
    } else if (status == 'VERDE') {
      return AppLocalizations.of(context).translate('regular');
    } else {
      return AppLocalizations.of(context).translate('fees_status_unknown');
    }
  }

  Icon getIconForStatus(String? status) {
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
        Icons.help_outline,
        color: AppColors.lightGray,
      );
    }
  }

  Color getColorForStatus(String? status) {
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
