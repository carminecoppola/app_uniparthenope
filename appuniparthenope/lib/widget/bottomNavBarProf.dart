import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/weatherFunction.dart';

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
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.anagrafeUser(context, authenticatedUser!.user);
                    Navigator.pushReplacementNamed(context, '/profileStudent',
                        arguments: anagrafeUser);
                  },
                  icon: Icons.person,
                  text: 'Personal Card',
                ),
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    AuthUtilsFunction.qrCodeImg(context);
                    Navigator.pushNamed(context, '/qrCodePage');
                  },
                  icon: Icons.qr_code,
                  text: 'QR-Code',
                ),
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allRooms(context);
                    Navigator.pushNamed(context, '/classroomsTeachers');
                  },
                  icon: Icons.school_sharp,
                  text: 'Classi',
                ),
                PopupMenuItemBuilder.buildMenuItem(
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
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    StudentUtils.allEvents(context);
                    Navigator.pushNamed(context, '/eventsTeachers');
                  },
                  icon: Icons.event,
                  text: 'Eventi',
                ),
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    WeatherFunctions.getWeather(context);
                    Navigator.pushNamed(context, '/watherPage');
                  },
                  icon: Icons.wb_cloudy,
                  text: 'Meteo UniParthenope',
                ),
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () {
                    Navigator.pushNamed(context, '/infoAppPage');
                  },
                  icon: Icons.info,
                  text: 'Info',
                ),
                PopupMenuItemBuilder.buildMenuItem(
                  onTap: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    authProvider.logout();
                    Navigator.pushReplacementNamed(context, '/loginPage');
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
}

class PopupMenuItemBuilder {
  static PopupMenuItem buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return PopupMenuItem(
      padding: const EdgeInsets.all(20.0),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon), // Icona
          const SizedBox(width: 5), // Spazio tra l'icona e il testo
          Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.primaryColor, // Colore del testo
              fontSize: fontSize ?? 16, // Dimensione del testo
              fontWeight: fontWeight ?? FontWeight.bold, // Grassetto del testo
              fontFamily: fontFamily ?? 'Roboto', // Font del testo
            ),
          ),
        ],
      ),
    );
  }
}
