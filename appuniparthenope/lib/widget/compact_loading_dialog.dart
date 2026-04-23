import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 190,
            maxWidth: 240,
            minHeight: 160,
            maxHeight: 210,
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
