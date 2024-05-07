import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.successColor,
      ),
      child: const Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: AppColors.textColor,
          ),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cerca...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
