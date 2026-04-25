import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/custom_loading_indicator.dart';
import 'package:flutter/material.dart';

Future<void> showCompactLoadingDialog(
  BuildContext context, {
  required String message,
  Color color = AppColors.primaryColor,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.18),
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 48),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 190,
            maxWidth: 280,
            minHeight: 160,
            maxHeight: 280,
          ),
          child: CustomLoadingIndicator(
            text: message,
            myColor: color,
            timeoutDuration: const Duration(minutes: 2),
          ),
        ),
      ),
    ),
  );
}
