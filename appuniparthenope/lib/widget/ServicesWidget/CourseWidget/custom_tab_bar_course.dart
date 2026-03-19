import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class CustomTabBarCourse extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;
  final List<String> tabTitles;

  const CustomTabBarCourse({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
    required this.tabTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: AppColors.lightGray,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 330,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(178, 177, 175, 100),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabTitles.length, (index) {
            return GestureDetector(
              onTap: () => onTabTapped(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: selectedIndex == index
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  tabTitles[index],
                  style: TextStyle(
                    color: selectedIndex == index
                        ? Colors.white
                        : AppColors.lightGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
