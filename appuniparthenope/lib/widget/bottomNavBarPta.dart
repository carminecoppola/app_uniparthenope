import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/logoutDialogConfirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarPTAComponent extends StatelessWidget {
  const BottomNavBarPTAComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavBarProvider>(context);
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width - 32,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              assetPath: 'assets/icon/homeIcon.png',
              label: 'Home',
              isSelected: navigationProvider.currentIndex == 0,
              onTap: () {
                navigationProvider.updateIndex(0);
                Navigator.pushNamed(context, '/homePTA');
              },
            ),
            _buildNavItem(
              context: context,
              index: 1,
              assetPath: 'assets/icon/logoutIcon.png',
              label: 'Logout',
              isSelected: navigationProvider.currentIndex == 1,
              onTap: () {
                _showLogoutConfirmationDialog(context);
                examDataProvider.clearReservations();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String assetPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            width: isSelected ? 35 : 27,
            height: isSelected ? 35 : 27,
            color: isSelected ? AppColors.primaryColor : AppColors.lightGray,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primaryColor : AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogoutConfirmationDialog();
      },
    );
  }
}
