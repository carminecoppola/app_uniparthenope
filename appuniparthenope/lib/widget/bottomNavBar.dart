import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/logoutDialogConfirm.dart';
import 'package:appuniparthenope/widget/popupMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/weatherFunction.dart';

class BottomNavBarComponent extends StatelessWidget {
  const BottomNavBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavBarProvider>(context);
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);
    final currentIndex = navigationProvider.currentIndex;

    final items = [
      'assets/icon/careerIcon.png', // Carriera
      'assets/icon/homeIcon.png', // Home
      'assets/icon/menubarIcon.png', // Menu
    ];

    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animazione focus solo sugli elementi della bottom bar
          if (currentIndex != 3)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: (currentIndex *
                      (MediaQuery.of(context).size.width - 64) /
                      items.length) +
                  30,
              child: Container(
                width: (MediaQuery.of(context).size.width - 64) / items.length -
                    32,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == currentIndex;
              return GestureDetector(
                onTap: () {
                  navigationProvider.updateIndex(index);
                  _handleNavigation(
                      context, index, authenticatedUser, examDataProvider);
                },
                child: Image.asset(
                  items[index],
                  width: isSelected ? 35 : 30,
                  height: isSelected ? 35 : 30,
                  color: isSelected ? Colors.white : Colors.grey[300],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index,
      dynamic authenticatedUser, ExamDataProvider examDataProvider) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/carrerStudent',
            arguments: StudentUtils.fetchDataAndUpdateStats(
                context, authenticatedUser.user));
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/homePage');
        break;
      case 2:
        _showMenu(context, authenticatedUser, examDataProvider);
        break;
      case 3:
        // Nessuna azione e nessun focus
        break;
    }
  }

  void _showMenu(BuildContext context, dynamic authenticatedUser,
      ExamDataProvider examDataProvider) {
    showMenu(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      shadowColor: const Color.fromARGB(255, 129, 128, 128),
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 250,
        400,
        20,
        0,
      ),
      items: [
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            AuthUtilsFunction.qrCodeImg(context);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(3);
            Navigator.pushNamed(context, '/qrCodePage');
          },
          icon: Icons.qr_code,
          text: AppLocalizations.of(context).translate('uniCardStudent'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(0);
            Navigator.pushNamed(context, '/carrerStudent',
                arguments: StudentUtils.fetchDataAndUpdateStats(
                    context, authenticatedUser.user));
          },
          icon: Icons.school,
          text: AppLocalizations.of(context).translate('career'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            if (authenticatedUser != null) {
              StudentUtils.allReservationStudent(
                  context, authenticatedUser.user);
            }
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(3);
            Navigator.pushReplacementNamed(context, '/reservationStudent');
          },
          icon: Icons.calendar_month,
          text: AppLocalizations.of(context).translate('reservation'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            if (authenticatedUser != null) {
              StudentUtils.allCourseStudent(context, authenticatedUser.user);
            }
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(3);
            Navigator.pushReplacementNamed(context, '/courseStudent');
          },
          icon: Icons.book,
          text: AppLocalizations.of(context).translate('courses'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            if (authenticatedUser != null) {
              StudentUtils.taxesStudent(context, authenticatedUser.user);
            }
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(3);
            Navigator.pushReplacementNamed(context, '/feesStudent');
          },
          icon: Icons.attach_money_outlined,
          text: AppLocalizations.of(context).translate('fees_uni'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            WeatherFunctions.getWeather(context);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(3);
            Navigator.pushReplacementNamed(context, '/watherPage');
          },
          icon: Icons.wb_cloudy,
          text: AppLocalizations.of(context).translate('weather_uni'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(3);
            Navigator.pushReplacementNamed(context, '/infoAppPage');
          },
          icon: Icons.info,
          text: AppLocalizations.of(context).translate('info_app'),
        ),
        CustomPopupMenuItemBuilder.buildMenuItem(
          onTap: () {
            _showLogoutConfirmationDialog(context);
            examDataProvider.clearReservations();
          },
          icon: Icons.logout,
          text: AppLocalizations.of(context).translate('logout'),
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
