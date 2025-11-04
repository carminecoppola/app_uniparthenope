import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/logoutDialogConfirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class BottomNavBarPTAComponent extends StatelessWidget {
  const BottomNavBarPTAComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavBarProvider>(context);
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);
    final currentIndex = navigationProvider.currentIndex;

    final items = [
      {
        'icon': Icons.home_rounded,
        'label': 'Home',
        'color': AppColors.primaryColor
      },
      {
        'icon': Icons.logout_rounded,
        'label': 'Logout',
        'color': AppColors.errorColor
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == currentIndex;
                final itemColor = item['color'] as Color;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      navigationProvider.updateIndex(index);
                      _handleNavigation(context, index, examDataProvider);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubicEmphasized,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      itemColor.withOpacity(0.3),
                                      itemColor.withOpacity(0.2),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(25),
                            border: isSelected
                                ? Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 1.5,
                                  )
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: itemColor.withOpacity(0.15),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: AnimatedScale(
                            scale: isSelected ? 1.0 : 0.85,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  color:
                                      isSelected ? itemColor : Colors.grey[400],
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['label'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? itemColor
                                        : Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(
      BuildContext context, int index, ExamDataProvider examDataProvider) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/homePTA');
        break;
      case 1:
        examDataProvider.clearReservations();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const LogoutConfirmationDialog();
          },
        );
        break;
    }
  }
}
