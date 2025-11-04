import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/logoutDialogConfirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';
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
                final isSelected = index == currentIndex &&
                    index != 2; // Il menu non è mai "selezionato"
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      navigationProvider.updateIndex(index);
                      _handleNavigation(
                          context, index, authenticatedUser, examDataProvider);
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
                                      AppColors.primaryColor.withOpacity(0.3),
                                      AppColors.primaryColor.withOpacity(0.2),
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
                                      color: AppColors.primaryColor
                                          .withOpacity(0.15),
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
                            child: Image.asset(
                              items[index],
                              width: 32,
                              height: 32,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey[400],
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

  void _handleNavigation(BuildContext context, int index,
      dynamic authenticatedUser, ExamDataProvider examDataProvider) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/carrerStudent',
            arguments: StudentUtils.fetchDataAndUpdateStats(
                context, authenticatedUser.user));
        break;
      case 1:
        // Controlla se siamo già sulla home page
        if (ModalRoute.of(context)?.settings.name != '/homePage') {
          Navigator.pushReplacementNamed(context, '/homePage');
        }
        break;
      case 2:
        _showMenu(context, authenticatedUser, examDataProvider);
        break;
    }
  }

  void _showMenu(BuildContext context, dynamic authenticatedUser,
      ExamDataProvider examDataProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.85),
                  Colors.white.withOpacity(0.8),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
                left: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                right: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context).translate('menu'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance,
                  title: AppLocalizations.of(context).translate('fees_uni'),
                  onTap: () async {
                    await StudentUtils.taxesStudent(
                        context, authenticatedUser.user);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/feesStudent');
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.wb_sunny,
                  title: AppLocalizations.of(context).translate('weather_uni'),
                  onTap: () {
                    Navigator.pop(context);
                    WeatherFunctions.getWeather(context);
                    Navigator.pushNamed(context, '/watherPage');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: AppLocalizations.of(context).translate('info_app'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/infoAppPage');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: AppLocalizations.of(context).translate('logout'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LogoutConfirmationDialog();
                      },
                    );
                  },
                  isLast: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
