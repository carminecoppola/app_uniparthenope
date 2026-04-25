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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: List.generate(tabTitles.length, (index) {
            final isSelected = selectedIndex == index;

            return Padding(
              padding: EdgeInsets.only(right: index == tabTitles.length - 1 ? 0 : 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTabTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.blueGradient : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.primaryDarkColor.withValues(alpha: 0.14),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tabTitles[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.primaryDarkColor,
                      fontWeight: FontWeight.w700,
                    ),
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
