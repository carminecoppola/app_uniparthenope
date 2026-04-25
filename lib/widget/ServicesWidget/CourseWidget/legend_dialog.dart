import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

void showLegendDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            AppLocalizations.of(context).translate('state_legend'),
            style: const TextStyle(
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
                      AppLocalizations.of(context)
                          .translate('planned_teaching_activity'),
                      AppColors.detailsColor),
                  _legendItem(
                      AppLocalizations.of(context)
                          .translate('unattended_teaching_activity'),
                      AppColors.lightGray),
                  _legendItem(
                      AppLocalizations.of(context)
                          .translate('attended_teaching_activity'),
                      AppColors.accentColor),
                  _legendItem(
                      AppLocalizations.of(context)
                          .translate('recognized_entire_activity'),
                      AppColors.successColor),
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
            child: Text(
              AppLocalizations.of(context).translate('close'),
              style: const TextStyle(
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
