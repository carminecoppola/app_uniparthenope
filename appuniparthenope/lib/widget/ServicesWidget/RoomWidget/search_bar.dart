import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class SearchBarCustom extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBarCustom({
    Key? key,
    required this.onChanged, required TextEditingController controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          hintText: 'Cerca aule...',
          hintStyle: const TextStyle(color: AppColors.primaryColor),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          filled: true,
          fillColor: AppColors.backgroundColor,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
