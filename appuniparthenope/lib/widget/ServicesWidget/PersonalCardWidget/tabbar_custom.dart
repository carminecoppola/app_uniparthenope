import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: AppColors.lightGray,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 290,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(178, 177, 175, 100),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => onTabTapped(0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: selectedIndex == 0
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  'Personali',
                  style: TextStyle(
                    color:
                        selectedIndex == 0 ? Colors.white : AppColors.lightGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(), // Spazio flessibile per centrare la linea divisoria
            Container(
              width: 1,
              color: Colors.white,
            ),
            const Spacer(), // Spazio flessibile per centrare la linea divisoria
            GestureDetector(
              onTap: () => onTabTapped(1),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: selectedIndex == 1
                      ? AppColors.primaryColor
                      : Colors.transparent,
                ),
                child: Text(
                  'Accademiche',
                  style: TextStyle(
                    color:
                        selectedIndex == 1 ? Colors.white : AppColors.lightGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
