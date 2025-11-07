import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/utilityFunctions/studentUtilsFunction.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/logoutDialogConfirm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:io' show Platform;
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';
import '../utilityFunctions/weatherFunction.dart';

/// BottomNavBar con effetto Liquid Glass ispirato al design di Apple
/// Disponibile solo su dispositivi iOS per un'esperienza ottimale
class BottomNavBarLiquidGlassComponent extends StatelessWidget {
  const BottomNavBarLiquidGlassComponent({super.key});

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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          // Blur ultra forte per effetto liquid glass iOS nativo
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              // Effetto vibrancy - ultra trasparenza come iOS nativo
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.02), // Ultra trasparente
                  Colors.white.withOpacity(0.01),
                  Colors.white.withOpacity(0.015),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(40),
              // Bordo quasi invisibile come iOS
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 0.3,
              ),
              // Shadow sottile e diffusa
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 50,
                  spreadRadius: -8,
                  offset: const Offset(0, 8),
                ),
                // Inner glow minimo
                BoxShadow(
                  color: Colors.white.withOpacity(0.02),
                  blurRadius: 8,
                  spreadRadius: -3,
                  offset: const Offset(0, -1),
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
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubicEmphasized,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            // Effetto liquid glass per item selezionato - ultra trasparente
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primaryColor.withOpacity(0.12),
                                      AppColors.primaryColor.withOpacity(0.08),
                                      AppColors.primaryColor.withOpacity(0.10),
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(30),
                            // Bordo luminoso sottile quando selezionato
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.15),
                                    width: 0.4,
                                  )
                                : null,
                            // Shadow diffusa per item selezionato
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.15),
                                      blurRadius: 30,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: AnimatedScale(
                            scale: isSelected ? 1.0 : 0.88,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubicEmphasized,
                            child: AnimatedOpacity(
                              opacity: isSelected ? 1.0 : 0.6,
                              duration: const Duration(milliseconds: 300),
                              child: Image.asset(
                                items[index],
                                width: 34,
                                height: 34,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey[400],
                                colorBlendMode: BlendMode.srcIn,
                              ),
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
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          // Blur forte per effetto liquid glass nel menu
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            decoration: BoxDecoration(
              // Effetto vibrancy ultra trasparente
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.75), // Molto più trasparente
                  Colors.white.withOpacity(0.70),
                  Colors.white.withOpacity(0.68),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 0.3,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 50,
                  spreadRadius: 0,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar più elegante
                Container(
                  margin: const EdgeInsets.only(top: 14, bottom: 10),
                  width: 38,
                  height: 4.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[300]!.withOpacity(0.6),
                        Colors.grey[400]!.withOpacity(0.8),
                        Colors.grey[300]!.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Header con effetto liquid glass
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor.withOpacity(0.12),
                              AppColors.primaryColor.withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.15),
                            width: 0.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: AppColors.primaryColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        AppLocalizations.of(context).translate('menu'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey[300]!.withOpacity(0.5)),
                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.school,
                  title: AppLocalizations.of(context).translate('career'),
                  onTap: () {
                    Navigator.pop(context);
                    StudentUtils.fetchDataAndUpdateStats(
                        context, authenticatedUser.user);
                    Navigator.pushNamed(context, '/carrerStudent');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.credit_card,
                  title: AppLocalizations.of(context).translate('studentcard'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/qrCodePage');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.event_note,
                  title: AppLocalizations.of(context).translate('reservation'),
                  onTap: () async {
                    // Prima carichiamo i dati
                    await StudentUtils.allReservationStudent(
                        context, authenticatedUser.user);
                    // Poi chiudiamo il menu e navighiamo
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/reservationStudent');
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.book,
                  title: AppLocalizations.of(context).translate('courses'),
                  onTap: () async {
                    // Prima carichiamo i dati
                    await StudentUtils.allCourseStudent(
                        context, authenticatedUser.user);
                    if (context.mounted) {
                      await StudentUtils.allReservationStudent(
                          context, authenticatedUser.user);
                    }
                    // Poi chiudiamo il menu e navighiamo
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/courseStudent');
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance,
                  title: AppLocalizations.of(context).translate('fees_uni'),
                  onTap: () async {
                    // Prima carichiamo i dati
                    await StudentUtils.taxesStudent(
                        context, authenticatedUser.user);
                    // Poi chiudiamo il menu e navighiamo
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
                  iconColor: Colors.red,
                  showArrow: false,
                ),
                const SizedBox(height: 24),
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
    Color? iconColor,
    bool showArrow = true,
  }) {
    final displayIconColor = iconColor ?? AppColors.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: displayIconColor.withOpacity(0.05),
        highlightColor: displayIconColor.withOpacity(0.03),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!.withOpacity(0.5),
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      displayIconColor.withOpacity(0.10),
                      displayIconColor.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: displayIconColor.withOpacity(0.12),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  icon,
                  color: displayIconColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
