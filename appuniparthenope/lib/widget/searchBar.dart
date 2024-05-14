import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Cerca per titolo...',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
