import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class SearchBarReservationWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBarReservationWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).translate('find_reservation'),
          hintStyle: TextStyle(
            color: AppColors.primaryColor.withValues(alpha: 0.72),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.12)),
            borderRadius: BorderRadius.circular(18.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(18.0),
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
