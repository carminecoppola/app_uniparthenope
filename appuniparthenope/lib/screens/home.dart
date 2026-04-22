import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarCard.dart';
import 'package:appuniparthenope/widget/alertDialog.dart';
import 'package:appuniparthenope/widget/update_dialog.dart';
import 'package:appuniparthenope/provider/update_provider.dart';
import 'package:appuniparthenope/service/notification_service.dart';
import 'package:appuniparthenope/core/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../app_localizations.dart';
import '../provider/auth_provider.dart';
import '../provider/bottomNavBar_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/studentUtilsFunction.dart';
import '../widget/HomeWidget/sectionTitle.dart';
import '../widget/ServicesWidget/AppointmentsWidget/homeAppointmentsWidget.dart';
import '../widget/HomeWidget/personalHomeWidget.dart';
import '../widget/HomeWidget/serviceUserGroup.dart';
import '../widget/bottomNavBar.dart';
import '../widget/bottomNavBarLiquidGlass.dart';
import '../widget/bottomNavBarProf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
    _checkForUpdates();
    _requestNotificationPermissions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setNavBarIndex();
  }

  /// Controlla se è disponibile un aggiornamento
  Future<void> _checkForUpdates() async {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final updateProvider =
          Provider.of<UpdateProvider>(context, listen: false);
      updateProvider.checkForUpdate().then((_) {
        if (mounted && updateProvider.hasUpdate) {
          _showUpdateDialog(updateProvider);
        }
      });
    });
  }

  /// Mostra il dialog di aggiornamento
  void _showUpdateDialog(UpdateProvider updateProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UpdateDialog(
          currentVersion: updateProvider.currentVersion,
          newVersion: updateProvider.newVersion,
          releaseNotes: updateProvider.releaseNotes,
          downloadUrl: updateProvider.downloadUrl,
          onDismiss: () {
            updateProvider.reset();
          },
        );
      },
    );
  }

  /// Richiede i permessi per le notifiche
  Future<void> _requestNotificationPermissions() async {
    final notificationService = getIt<NotificationService>();
    try {
      await notificationService.requestPermissions();
    } catch (e) {
      print('Errore nella richiesta permessi notifiche: $e');
    }
  }

  void _setNavBarIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomNavBarProvider =
          Provider.of<BottomNavBarProvider>(context, listen: false);
      bottomNavBarProvider.updateIndex(1);
    });
  }

  Future<void> _loadData() async {
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

    if (authenticatedUser != null) {
      if (!mounted) return;

      if (authenticatedUser.user.grpDes == 'Studenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        if (!mounted) return;
        await StudentUtils.allReservationStudent(
            context, authenticatedUser.user);

        // 🔔 AUTOMATICO: Il check dei nuovi voti avviene dentro
        // StudentUtils.allExamStudent() → ExamDataProvider.setAllExamStudent()
        // che trigga automaticamente _checkAndNotifyNewGrades()
      } else if (authenticatedUser.user.grpDes == 'Docenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
      } else {
        if (!mounted) return;
        CustomAlertDialog(
          title: AppLocalizations.of(context).translate('error_anagrafic'),
          content:
              AppLocalizations.of(context).translate('error_loading_anagrafic'),
          buttonText: AppLocalizations.of(context).translate('close'),
          color: AppColors.errorColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final anagrafeUser = Provider.of<AuthProvider>(context).anagrafeUser;
    final profileImage = Provider.of<AuthProvider>(context).profileImage;
    final selectedCareer =
        Provider.of<AuthProvider>(context, listen: false).selectedCareer;

    if (authenticatedUser == null) {
      return Scaffold(
        body: Container(
          color: Colors.white,
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            if (authenticatedUser.user.grpDes == 'Studenti') ...[
              PersonalCardUser(
                onTap: () async {
                  await StudentUtils.anagrafeUser(
                      context, authenticatedUser.user);
                  AuthUtilsFunction.userImg(context);
                  if (anagrafeUser != null) {
                    Navigator.pushReplacementNamed(context, '/profileStudent',
                        arguments: anagrafeUser);
                  } else {
                    CustomLoadingIndicator(
                      text: AppLocalizations.of(context)
                          .translate('loading_personal_date'),
                      myColor: AppColors.primaryColor,
                    );
                  }
                },
                firstName: authenticatedUser.user.firstName ?? '',
                lastName: authenticatedUser.user.lastName ?? '',
                identificativoLabel:
                    '${AppLocalizations.of(context).translate('studentid')}:',
                id: selectedCareer!['matricola'].toString(),
                profileImage: profileImage,
              ),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('reservation')),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/reservationStudent');
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppLocalizations.of(context).translate('showall'),
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const HomeAppointmentsCard(),
              const SizedBox(height: 20),
              // 📋 SEZIONE APPELLI DISPONIBILI
              SectionTitle(
                  title: AppLocalizations.of(context).translate('examCalls') ?? 'Appelli'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/listaAppelliStudent');
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryColor.withOpacity(0.1),
                            AppColors.primaryColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Appelli Disponibili',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Visualizza gli appelli e prenota il tuo esame',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('services')),
              ServiceGroupStudentCard(
                authenticatedUser: authenticatedUser,
              ),
              const SizedBox(height: 10),
            ] else ...[
              PersonalCardUser(
                onTap: () async {
                  await StudentUtils.anagrafeUser(
                      context, authenticatedUser.user);
                  if (anagrafeUser != null) {
                    Navigator.pushReplacementNamed(context, '/profileStudent',
                        arguments: anagrafeUser);
                  } else {
                    CustomLoadingIndicator(
                        text: AppLocalizations.of(context)
                            .translate('loading_personal_date'),
                        myColor: AppColors.primaryColor);
                  }
                },
                firstName: authenticatedUser.user.firstName ?? '',
                lastName: authenticatedUser.user.lastName ?? '',
                identificativoLabel:
                    '${AppLocalizations.of(context).translate('profid')}:',
                id: authenticatedUser.user.docenteId != null
                    ? authenticatedUser.user.docenteId.toString()
                    : 'N/A',
                profileImage: profileImage,
              ),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('calendar')),
              const CalendarCard(),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('services')),
              ServiceGroupProfCard(
                authenticatedUser: authenticatedUser,
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? (Platform.isIOS
              ? const BottomNavBarLiquidGlassComponent() // iOS: Liquid Glass
              : const BottomNavBarComponent()) // Android: Standard
          : const BottomNavBarProfComponent(),
    );
  }
}
