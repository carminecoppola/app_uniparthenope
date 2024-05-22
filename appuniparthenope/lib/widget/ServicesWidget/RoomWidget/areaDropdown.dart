import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

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
    return DropdownButton<String>(
      value: selectedArea,
      onChanged: onChanged,
      alignment: AlignmentDirectional.center,
      style: const TextStyle(color: AppColors.primaryColor),
      items: [
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
    );
  }
}
