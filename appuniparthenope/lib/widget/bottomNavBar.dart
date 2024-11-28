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
    final anagrafeUser = Provider.of<AuthProvider>(context).anagrafeUser;
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentIndex,
      onTap: (index) {
        navigationProvider.updateIndex(index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/homePage');
            break;
          case 1:
            StudentUtils.totalExamStats(context, authenticatedUser!.user);
            StudentUtils.averageStats(context, authenticatedUser.user);
            StudentUtils.allExamStudent(context, authenticatedUser.user);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(1);
            Navigator.pushNamed(context, '/carrerStudent');
            break;
          case 2:
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.fromDirection(5.0),
                    ancestor: overlay),
                button.localToGlobal(button.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );
            showMenu(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              shadowColor: AppColors.lightGray,
              context: context,
              position: position,
              items: [
                // CustomPopupMenuItemBuilder.buildMenuItem(
                //   onTap: () {
                //     StudentUtils.anagrafeUser(context, authenticatedUser!.user);
                //     Navigator.pushReplacementNamed(context, '/profileStudent',
                //         arguments: anagrafeUser);
                //   },
                //   icon: Icons.person,
                //   text: AppLocalizations.of(context)
                //       .translate('personal_profile'),
                // ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    AuthUtilsFunction.qrCodeImg(context);
                    Navigator.pushNamed(context, '/qrCodePage');
                  },
                  icon: Icons.qr_code,
                  text: AppLocalizations.of(context).translate('uniCard'),
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.fetchDataAndUpdateStats(
                        context, authenticatedUser!.user);
                    Navigator.pushNamed(context, '/carrerStudent');
                  },
                  icon: Icons.school,
                  text: AppLocalizations.of(context).translate('career'),
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allReservationStudent(
                        context, authenticatedUser!.user);
                    Navigator.pushNamed(context, '/reservationStudent');
                  },
                  icon: Icons.calendar_month,
                  text: AppLocalizations.of(context).translate('reservation'),
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allCourseStudent(
                        context, authenticatedUser!.user);
                    Navigator.pushNamed(context, '/courseStudent');
                  },
                  icon: Icons.book,
                  text: AppLocalizations.of(context).translate('courses'),
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.taxesStudent(context, authenticatedUser!.user);
                    Navigator.pushNamed(context, '/feesStudent');
                  },
                  icon: Icons.attach_money_outlined,
                  text: AppLocalizations.of(context).translate('fees_uni'),
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    WeatherFunctions.getWeather(context);
                    Navigator.pushNamed(context, '/watherPage');
                  },
                  icon: Icons.wb_cloudy,
                  text: AppLocalizations.of(context).translate('weather_uni'),
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    Navigator.pushNamed(context, '/infoAppPage');
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
            break;
        }
      },
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.lightGray,
      selectedLabelStyle: const TextStyle(color: Colors.white),
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.school),
          label: AppLocalizations.of(context).translate('career'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
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
