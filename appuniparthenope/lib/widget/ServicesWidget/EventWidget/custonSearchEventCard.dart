import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class SearchBarEvent extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarEvent({
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
          labelText: AppLocalizations.of(context).translate('search_events_label'),
          labelStyle: const TextStyle(
            color: AppColors.primaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}