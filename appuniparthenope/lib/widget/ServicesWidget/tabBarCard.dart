// CustomTabBar.dart
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final void Function(int) onTabSelected;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      onTap: onTabSelected,
    );
  }
}
