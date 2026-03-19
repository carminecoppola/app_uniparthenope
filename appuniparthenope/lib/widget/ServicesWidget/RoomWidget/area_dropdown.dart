import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class AreaDropdown extends StatelessWidget {
  final String selectedArea;
  final ValueChanged<String?> onChanged;

  const AreaDropdown({
    super.key,
    required this.selectedArea,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedArea.isNotEmpty &&
                  selectedArea !=
                      AppLocalizations.of(context)
                          .translate('select_menu_classroom')
              ? selectedArea
              : null,
          hint: Text(
              AppLocalizations.of(context).translate('select_menu_classroom')),
          onChanged: onChanged,
          alignment: AlignmentDirectional.center,
          style: const TextStyle(color: AppColors.primaryColor),
          items: [
            '...seleziona Ateneo...',
            'Via Acton',
            'Pacanowsky (Via Parisi)',
            'Centro Direzionale',
            'Via Medina',
            'Villa Doria',
            'Nola',
            // Aggiungi altre opzioni qui
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
