import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/AppointmentsWidget/details_appointments_card.dart';
import 'package:appuniparthenope/widget/compact_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/studentService/reservation_data.dart';
import '../../../provider/check_exam_provider.dart';
import '../../../utilityFunctions/exam_utils_function.dart';
import '../../../utilityFunctions/student_utils_function.dart';

class SingleAppointmentCard extends StatelessWidget {
  final IconData iconData;
  final ReservationInfo reservation;
  final bool canCancel;

  const SingleAppointmentCard({
    super.key,
    required this.iconData,
    required this.reservation,
    this.canCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    String examTitle = reservation.nomeAppello?.split(' CFU')[0] ?? '';
    if (examTitle.trim().isEmpty) {
      examTitle = localizations.translate('reservation');
    }
    String teacherName =
        '${toCamelCase(reservation.nomePres ?? "")} ${toCamelCase(reservation.cognomePres ?? "")}';
    if (teacherName.trim().isEmpty) {
      teacherName = localizations.translate('not_available');
    }
    String date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yy')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : localizations.translate('not_available');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: DetailsAppointmentCard(reservation: reservation),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.18)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  iconData,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDarkColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _AppointmentChip(
                            icon: Icons.person_outline_rounded,
                            text: teacherName,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _AppointmentChip(
                            icon: Icons.event_outlined,
                            text: date,
                          ),
                        ),
                      ],
                    ),
                    if (canCancel) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => _handleCancelReservation(context),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: Text(localizations.translate('cancel')),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.errorColor,
                            backgroundColor:
                                AppColors.errorColor.withValues(alpha: 0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCancelReservation(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final examTitle = reservation.nomeAppello?.split(' CFU')[0] ?? '';
    final date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yyyy HH:mm')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : localizations.translate('not_available');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.errorColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        localizations.translate('cancel_reservation_title'),
                        style: const TextStyle(
                          color: AppColors.errorColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localizations.translate('cancel_reservation_message'),
                style: const TextStyle(
                  color: AppColors.primaryDarkColor,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              _AppointmentChip(
                icon: Icons.menu_book_rounded,
                text: examTitle,
              ),
              const SizedBox(height: 8),
              _AppointmentChip(
                icon: Icons.event_outlined,
                text: date,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDarkColor,
                        side: BorderSide(
                          color: AppColors.errorColor.withValues(alpha: 0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(localizations.translate('no')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.delete_forever_outlined),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      label: Text(localizations.translate('yes')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final checkExamProvider =
        Provider.of<CheckDateExamProvider>(context, listen: false);
    final examSessionContext =
        await CheckExamUtils.resolveStudentExamSessionContext(context);
    if (!context.mounted) return;

    if (examSessionContext == null ||
        reservation.adId == null ||
        reservation.appId == null ||
        reservation.adId == 0 ||
        reservation.appId == 0) {
      _showErrorDialog(
        context,
        '${localizations.translate('cancel_reservation_error')}: '
        '${localizations.translate('reservation_or_user_data_unavailable')}',
      );
      return;
    }

    showCompactLoadingDialog(
      context,
      message: localizations.translate('cancel_reservation_loading'),
    );

    try {
      final stuId = examSessionContext.stuId;
      if (stuId == null || stuId == 0) {
        if (context.mounted) Navigator.of(context).pop();
        if (context.mounted) {
          _showErrorDialog(
            context,
            '${localizations.translate('cancel_reservation_error')}: '
            '${localizations.translate('student_id_unavailable')}',
          );
        }
        return;
      }

      final result = await checkExamProvider.cancelExamReservation(
        userId: examSessionContext.user.userId!,
        password: examSessionContext.password,
        cdsId: examSessionContext.cdsId,
        adId: reservation.adId!,
        appId: reservation.appId!,
        stuId: stuId,
        dettaglioTratto: examSessionContext.dettaglioTratto,
        courseList: examSessionContext.courseList,
      );

      if (result.isSuccess) {
        if (context.mounted) {
          await StudentUtils.allReservationStudent(
              context, examSessionContext.user);
        }

        // Chiudi il loading solo dopo il refresh, per non mostrare la lista
        // mentre si aggiorna sotto al dialog.
        if (context.mounted) Navigator.of(context).pop();

        if (context.mounted) {
          _showFeedbackDialog(
            context,
            title: localizations.translate('success'),
            message: localizations.translate('cancel_reservation_success'),
            accentColor: AppColors.successColor,
            icon: Icons.check_circle_rounded,
          );
        }
      } else if (context.mounted) {
        Navigator.of(context).pop();

        _showCancelFallbackDialog(
          context,
          result.errorMessage ??
              localizations.translate('cancel_reservation_error'),
          examSessionContext.cdsId,
          examSessionContext.courseList
              .firstWhere((course) => course.adId == reservation.adId)
              .adsceId,
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        _showErrorDialog(
          context,
          '${localizations.translate('cancel_reservation_error')}: $e',
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    _showFeedbackDialog(
      context,
      title: AppLocalizations.of(context)
          .translate('cancel_reservation_error_title'),
      message: message,
      accentColor: AppColors.errorColor,
      icon: Icons.error_outline_rounded,
      scrollable: true,
    );
  }

  void _showCancelFallbackDialog(
    BuildContext context,
    String message,
    int cdsId,
    int adsceId,
  ) {
    final esse3Uri = reservation.buildEsse3CancellationUri(
      fallbackCdsId: cdsId,
      fallbackAdsceId: adsceId,
    );
    final localizations = AppLocalizations.of(context);
    final missingEsse3Data = esse3Uri == null
        ? '\n\n${localizations.translate('missing_esse3_app_list_id')}'
        : '';

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.errorColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.link_off_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        localizations
                            .translate('cancel_reservation_unavailable_title'),
                        style: const TextStyle(
                          color: AppColors.errorColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _ScrollableDialogMessage('$message$missingEsse3Data'),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDarkColor,
                        side: BorderSide(
                          color: AppColors.primaryColor.withValues(alpha: 0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(localizations.translate('ok')),
                    ),
                  ),
                  if (esse3Uri != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await launchUrl(
                            esse3Uri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(localizations.translate('open_esse3')),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog(
    BuildContext context, {
    required String title,
    required String message,
    required Color accentColor,
    required IconData icon,
    bool scrollable = false,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              scrollable
                  ? _ScrollableDialogMessage(message)
                  : Text(
                      message,
                      style: const TextStyle(
                        color: AppColors.primaryDarkColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(AppLocalizations.of(context).translate('ok')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AppointmentChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollableDialogMessage extends StatelessWidget {
  final String message;

  const _ScrollableDialogMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: SingleChildScrollView(
        child: Text(message),
      ),
    );
  }
}
