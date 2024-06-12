import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/logoutDialogConfirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/weatherFunction.dart';
import 'popupMenuItem.dart';

class BottomNavBarProfComponent extends StatelessWidget {
  const BottomNavBarProfComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavBarProvider>(context);
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final anagrafeUser = Provider.of<AuthProvider>(context).anagrafeUser;

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentIndex,
      onTap: (index) {
        navigationProvider.updateIndex(index);
        switch (index) {
          case 0:
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(0);
            Navigator.pushNamed(context, '/homePage');
            break;
          case 1:
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(1);
            Navigator.pushNamed(context, '/courseTeachers');
            break;
          case 2:
            // Mostra il menu quando viene premuto l'elemento 2 del BottomNavigationBar
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
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.anagrafeUser(context, authenticatedUser!.user);
                    Navigator.pushReplacementNamed(context, '/profileStudent',
                        arguments: anagrafeUser);
                  },
                  icon: Icons.person,
                  text: 'Personal Card',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    AuthUtilsFunction.qrCodeImg(context);
                    Navigator.pushNamed(context, '/qrCodePage');
                  },
                  icon: Icons.qr_code,
                  text: 'QR-Code',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allRooms(context);
                    Navigator.pushNamed(context, '/classroomsTeachers');
                  },
                  icon: Icons.school_sharp,
                  text: 'Classi',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allCourseStudent(
                        context, authenticatedUser!.user);
                    final bottomNavBarProvider =
                        Provider.of<BottomNavBarProvider>(context,
                            listen: false);
                    bottomNavBarProvider.updateIndex(1);
                    Navigator.pushNamed(context, '/courseTeachers');
                  },
                  icon: Icons.book,
                  text: 'Corsi',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allEvents(context);
                    Navigator.pushNamed(context, '/eventsTeachers');
                  },
                  icon: Icons.event,
                  text: 'Eventi',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    WeatherFunctions.getWeather(context);
                    Navigator.pushNamed(context, '/watherPage');
                  },
                  icon: Icons.wb_cloudy,
                  text: 'Meteo UniParthenope',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    Navigator.pushNamed(context, '/infoAppPage');
                  },
                  icon: Icons.info,
                  text: 'Info',
                ),
                CustomPopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  icon: Icons.logout,
                  text: 'Logout',
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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: 'Corsi',
        ),
        BottomNavigationBarItem(
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
