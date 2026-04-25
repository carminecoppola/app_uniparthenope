import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottom_nav_bar_provider.dart';
import 'package:appuniparthenope/widget/logout_dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';
import '../utilityFunctions/weather_function.dart';

class BottomNavBarProfComponent extends StatelessWidget {
  const BottomNavBarProfComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavBarProvider>(context);
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final examDataProvider =
        Provider.of<ExamDataProvider>(context, listen: false);
    final currentIndex = navigationProvider.currentIndex;

    final items = [
      'assets/icon/services/courses.png', // Corsi
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
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
                                      AppColors.primaryColor.withValues(alpha: 0.3),
                                      AppColors.primaryColor.withValues(alpha: 0.2),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(25),
                            border: isSelected
                                ? Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 1.5,
                                  )
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.15),
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
        _pushIfNeeded(context, '/courseTeachers');
        break;
      case 1:
        _replaceIfNeeded(context, '/homePage');
        break;
      case 2:
        _showMenu(context, authenticatedUser, examDataProvider);
        break;
    }
  }

  void _showMenu(BuildContext context, dynamic authenticatedUser,
      ExamDataProvider examDataProvider) {
    final pageContext = context;

    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.94),
                  const Color(0xFFF7FBFF).withValues(alpha: 0.96),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.78),
                  width: 1.4,
                ),
                left: BorderSide(
                  color: Colors.white.withValues(alpha: 0.28),
                  width: 1,
                ),
                right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.28),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 34,
                  spreadRadius: 0,
                  offset: const Offset(0, -12),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey[300]!.withValues(alpha: 0.65),
                            Colors.grey[400]!.withValues(alpha: 0.9),
                            Colors.grey[300]!.withValues(alpha: 0.65),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryColor.withValues(alpha: 0.12),
                            AppColors.primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: AppColors.blueGradient,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.18),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate('menu'),
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDarkColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.credit_card,
                  title:
                      AppLocalizations.of(context).translate('professorcard'),
                  onTap: () {
                    Navigator.pop(context);
                    _pushIfNeeded(pageContext, '/qrCodePage');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.wb_sunny,
                  title: AppLocalizations.of(context).translate('weather_uni'),
                  onTap: () {
                    Navigator.pop(context);
                    WeatherFunctions.getWeather(pageContext);
                    _pushIfNeeded(pageContext, '/watherPage');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: AppLocalizations.of(context).translate('info_app'),
                  onTap: () {
                    Navigator.pop(context);
                    _pushIfNeeded(pageContext, '/infoAppPage');
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
                  iconColor: Colors.red,
                  showArrow: false,
                ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _pushIfNeeded(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name == routeName) {
      return;
    }

    Navigator.pushNamed(context, routeName);
  }

  void _replaceIfNeeded(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name == routeName) {
      return;
    }

    Navigator.pushReplacementNamed(context, routeName);
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
    Color? iconColor,
    bool showArrow = true,
  }) {
    final displayIconColor = iconColor ?? AppColors.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: displayIconColor.withValues(alpha: 0.06),
        highlightColor: displayIconColor.withValues(alpha: 0.03),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: displayIconColor.withValues(
                alpha: isLast ? 0.18 : 0.10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      displayIconColor.withValues(alpha: 0.18),
                      displayIconColor.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: displayIconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: isLast ? FontWeight.w700 : FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (showArrow)
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
