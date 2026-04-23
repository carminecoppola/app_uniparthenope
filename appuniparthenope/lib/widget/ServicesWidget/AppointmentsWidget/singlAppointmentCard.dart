import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/AppointmentsWidget/detailsAppointmentsCard.dart';
import 'package:appuniparthenope/widget/compact_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/studentService/reservation_data.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/check_exam_provider.dart';
import '../../../provider/exam_provider.dart';
import '../../../utilityFunctions/studentUtilsFunction.dart';

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
    String teacherName =
        '${toCamelCase(reservation.nomePres ?? "")} ${toCamelCase(reservation.cognomePres ?? "")}';
    String date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yy')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : 'Data non disponibile';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DetailsAppointmentCard(reservation: reservation),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color: AppColors.primaryColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      teacherName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  if (canCancel) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _handleCancelReservation(context),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(localizations.translate('cancel')),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.errorColor,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  Future<void> _handleCancelReservation(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final examTitle = reservation.nomeAppello?.split(' CFU')[0] ?? '';
    final date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yyyy HH:mm')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : 'Data non disponibile';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 14, 24, 4),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.errorColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                localizations.translate('cancel_reservation_title'),
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
        content: Text(
          '${localizations.translate('cancel_reservation_message')}\n\n'
          '$examTitle\n$date',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.translate('no')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.translate('yes')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    final checkExamProvider =
        Provider.of<CheckDateExamProvider>(context, listen: false);
    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;
    var courseList = examProvider.allCourseStudent;

    if (user == null ||
        password == null ||
        selectedCareer == null ||
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
      if (courseList == null || courseList.isEmpty) {
        await StudentUtils.allCourseStudent(context, user);
        courseList = examProvider.allCourseStudent;
      }

      if (courseList == null || courseList.isEmpty) {
        if (context.mounted) Navigator.of(context).pop();
        if (context.mounted) {
          _showErrorDialog(
            context,
            '${localizations.translate('cancel_reservation_error')}: '
            '${localizations.translate('course_list_unavailable')}',
          );
        }
        return;
      }

      final stuId = int.tryParse(selectedCareer['stuId'].toString());
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
        userId: user.userId!,
        password: password,
        cdsId: selectedCareer['cdsId'],
        adId: reservation.adId!,
        appId: reservation.appId!,
        stuId: stuId,
        dettaglioTratto: selectedCareer['dettaglioTratto'] ?? {},
        courseList: courseList,
      );

      if (result.isSuccess) {
        if (context.mounted) {
          await StudentUtils.allReservationStudent(context, user);
        }

        // Chiudi il loading solo dopo il refresh, per non mostrare la lista
        // mentre si aggiorna sotto al dialog.
        if (context.mounted) Navigator.of(context).pop();

        if (context.mounted) {
          _showMessage(
            context,
            localizations.translate('cancel_reservation_success'),
            AppColors.successColor,
          );
        }
      } else if (context.mounted) {
        Navigator.of(context).pop();

        _showCancelFallbackDialog(
          context,
          result.errorMessage ??
              localizations.translate('cancel_reservation_error'),
          selectedCareer['cdsId'],
          courseList
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

  void _showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          AppLocalizations.of(context)
              .translate('cancel_reservation_error_title'),
          style: const TextStyle(color: AppColors.errorColor),
        ),
        content: _ScrollableDialogMessage(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).translate('ok')),
          ),
        ],
      ),
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          localizations.translate('cancel_reservation_unavailable_title'),
          style: const TextStyle(color: AppColors.errorColor),
        ),
        content: _ScrollableDialogMessage('$message$missingEsse3Data'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.translate('ok')),
          ),
          if (esse3Uri != null)
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await launchUrl(
                  esse3Uri,
                  mode: LaunchMode.externalApplication,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(localizations.translate('open_esse3')),
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
