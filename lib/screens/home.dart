import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/widget/custom_loading_indicator.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendar_card.dart';
import 'package:appuniparthenope/widget/alert_dialog.dart';
import 'package:appuniparthenope/widget/update_dialog.dart';
import 'package:appuniparthenope/provider/update_provider.dart';
import 'package:appuniparthenope/service/notification_service.dart';
import 'package:appuniparthenope/core/service_locator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../app_localizations.dart';
import '../provider/auth_provider.dart';
import '../provider/bottom_nav_bar_provider.dart';
import '../utilityFunctions/auth_utils_function.dart';
import '../utilityFunctions/student_utils_function.dart';
import '../widget/HomeWidget/section_title.dart';
import '../widget/ServicesWidget/AppointmentsWidget/home_appointments_widget.dart';
import '../widget/HomeWidget/personal_home_widget.dart';
import '../widget/HomeWidget/service_user_group.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/bottom_nav_bar_liquid_glass.dart';
import '../widget/bottom_nav_bar_prof.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const bool _useModernHomeExperience = true;

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
    } catch (_) {
      return;
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

    AppLogger.info(
      'HOME LOAD start hasUser=${authenticatedUser != null}',
    );

    if (authenticatedUser != null) {
      if (!mounted) return;

      if (authenticatedUser.user.grpDes == 'Studenti') {
        AppLogger.info(
          'HOME LOAD role=Studenti userId=${authenticatedUser.user.userId}',
        );
        // Priorità alta: anagrafe necessaria per un render stabile.
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        if (!mounted) return;

        // Priorità media/bassa in background: non bloccare percezione startup.
        unawaited(
          AuthUtilsFunction.userImg(context).catchError((e, stackTrace) {
            AppLogger.warning('HOME LOAD user image background failure', e, stackTrace);
          }),
        );
        unawaited(
          StudentUtils.allReservationStudent(context, authenticatedUser.user)
              .catchError((e, stackTrace) {
            AppLogger.warning(
                'HOME LOAD reservations background failure', e, stackTrace);
          }),
        );
        AppLogger.info('HOME LOAD studenti data completed');

        // 🔔 AUTOMATICO: Il check dei nuovi voti avviene dentro
        // StudentUtils.allExamStudent() → ExamDataProvider.setAllExamStudent()
        // che trigga automaticamente _checkAndNotifyNewGrades()
      } else if (authenticatedUser.user.grpDes == 'Docenti') {
        AppLogger.info(
          'HOME LOAD role=Docenti userId=${authenticatedUser.user.userId}',
        );
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        if (!mounted) return;
        unawaited(
          AuthUtilsFunction.userImg(context).catchError((e, stackTrace) {
            AppLogger.warning('HOME LOAD teacher image background failure', e, stackTrace);
          }),
        );
        AppLogger.info('HOME LOAD docenti data completed');
      } else {
        AppLogger.warning(
          'HOME LOAD unsupported role=${authenticatedUser.user.grpDes}',
        );
        if (!mounted) return;
        CustomAlertDialog(
          title: AppLocalizations.of(context).translate('error_anagrafic'),
          content:
              AppLocalizations.of(context).translate('error_loading_anagrafic'),
          buttonText: AppLocalizations.of(context).translate('close'),
          color: AppColors.errorColor,
        );
      }
    } else {
      AppLogger.warning('HOME LOAD aborted: authenticatedUser is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
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

    Future<void> profileTap() async {
      await StudentUtils.anagrafeUser(context, authenticatedUser.user);
      if (!context.mounted) return;

      if (authenticatedUser.user.grpDes == 'Studenti') {
        AuthUtilsFunction.userImg(context);
      }

      final updatedAnagrafeUser =
          Provider.of<AuthProvider>(context, listen: false).anagrafeUser;
      if (updatedAnagrafeUser != null) {
        Navigator.pushReplacementNamed(context, '/profileStudent',
            arguments: updatedAnagrafeUser);
      } else {
        CustomLoadingIndicator(
          text: AppLocalizations.of(context).translate('loading_personal_date'),
          myColor: AppColors.primaryColor,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _useModernHomeExperience
          ? _buildModernHome(
              context,
              authenticatedUser: authenticatedUser,
              selectedCareer: selectedCareer,
              profileImage: profileImage,
              onProfileTap: profileTap,
            )
          : _buildLegacyHome(
              context,
              authenticatedUser: authenticatedUser,
              selectedCareer: selectedCareer,
              profileImage: profileImage,
              onProfileTap: profileTap,
            ),
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? (Platform.isIOS
              ? const BottomNavBarLiquidGlassComponent() // iOS: Liquid Glass
              : const BottomNavBarComponent()) // Android: Standard
          : const BottomNavBarProfComponent(),
    );
  }

  Widget _buildLegacyHome(
    BuildContext context, {
    required dynamic authenticatedUser,
    required dynamic selectedCareer,
    required String? profileImage,
    required VoidCallback onProfileTap,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 70),
          if (authenticatedUser.user.grpDes == 'Studenti') ...[
            PersonalCardUser(
              onTap: onProfileTap,
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
            SectionTitle(
                title: AppLocalizations.of(context).translate('services')),
            ServiceGroupStudentCard(
              authenticatedUser: authenticatedUser,
            ),
            const SizedBox(height: 10),
          ] else ...[
            PersonalCardUser(
              onTap: onProfileTap,
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
    );
  }

  Widget _buildModernHome(
    BuildContext context, {
    required dynamic authenticatedUser,
    required dynamic selectedCareer,
    required String? profileImage,
    required VoidCallback onProfileTap,
  }) {
    final isStudent = authenticatedUser.user.grpDes == 'Studenti';
    final idLabel = isStudent
        ? AppLocalizations.of(context).translate('studentid')
        : AppLocalizations.of(context).translate('profid');
    final idValue = isStudent
        ? (selectedCareer != null ? selectedCareer['matricola'].toString() : '')
        : (authenticatedUser.user.docenteId?.toString() ?? 'N/A');

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 58, 16, 18),
                  child: PersonalCardUser(
                    onTap: onProfileTap,
                    firstName: authenticatedUser.user.firstName ?? '',
                    lastName: authenticatedUser.user.lastName ?? '',
                    identificativoLabel: '$idLabel:',
                    id: idValue,
                    profileImage: profileImage,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isStudent) ...[
          SliverToBoxAdapter(
            child: _HomeSectionShell(
              title: AppLocalizations.of(context).translate('reservation'),
              actionLabel: AppLocalizations.of(context).translate('showall'),
              onActionTap: () {
                Navigator.pushNamed(context, '/reservationStudent');
              },
              child: const HomeAppointmentsCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: _HomeSectionShell(
              title: AppLocalizations.of(context).translate('services'),
              contentTopGap: 0,
              child: ServiceGroupStudentCard(
                authenticatedUser: authenticatedUser,
              ),
            ),
          ),
        ] else ...[
          SliverToBoxAdapter(
            child: _HomeSectionShell(
              title: AppLocalizations.of(context).translate('calendar'),
              child: const CalendarCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: _HomeSectionShell(
              title: AppLocalizations.of(context).translate('services'),
              contentTopGap: 0,
              child: ServiceGroupProfCard(
                authenticatedUser: authenticatedUser,
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 96),
        ),
      ],
    );
  }
}

class _HomeSectionShell extends StatelessWidget {
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final double contentTopGap;

  const _HomeSectionShell({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionTap,
    this.contentTopGap = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: AppColors.primaryColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryDarkColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (actionLabel != null && onActionTap != null)
                  TextButton(
                    onPressed: onActionTap,
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: contentTopGap),
          child,
        ],
      ),
    );
  }
}
