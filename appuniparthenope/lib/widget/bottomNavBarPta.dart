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

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentIndex,
      onTap: (index) {
        navigationProvider.updateIndex(index);
        switch (index) {
          case 0:
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(0);
            Navigator.pushNamed(context, '/homePTA');
            break;
          case 1:
            _showLogoutConfirmationDialog(context);
            examDataProvider.clearReservations();
            break;
        }
      },
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.lightGray,
      selectedLabelStyle: const TextStyle(color: Colors.white),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
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
