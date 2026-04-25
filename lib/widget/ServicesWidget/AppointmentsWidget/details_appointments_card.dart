import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/model/studentService/reservation_data.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:intl/intl.dart';

class DetailsAppointmentCard extends StatelessWidget {
  final ReservationInfo reservation;

  const DetailsAppointmentCard({
    super.key,
    required this.reservation,
  });

  // Funzione per selezionare l'asset in base al valore di courseInfo
  String getAssetForCourseInfo(String courseInfo) {
    if (courseInfo.toLowerCase().contains('pratica') ||
        courseInfo.toLowerCase().contains('pratico') ||
        courseInfo.toLowerCase().contains('intercorso') ||
        courseInfo.toLowerCase().contains('scritta') ||
        courseInfo.toLowerCase().contains('scritto')) {
      return 'assets/icon/practicalTest.png';
    } else if (courseInfo.toLowerCase().contains('orale')) {
      return 'assets/icon/discussionIcon.png';
    } else {
      return 'assets/icon/appointmentIcon.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    String examTitle = reservation.nomeAppello?.split(' CFU')[0] ?? '';
    String teacherName =
        '${toCamelCase(reservation.nomePres ?? "")} ${toCamelCase(reservation.cognomePres ?? "")}';
    String date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : localizations.translate('not_available');
    String formattedTime = reservation.dataEsa != null
        ? DateFormat('HH:mm')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : localizations.translate('not_available');
    String courseInfo = (reservation.desApp ?? '').trim();
    String room = (reservation.aulaDes ?? '').trim();
    if (examTitle.trim().isEmpty) {
      examTitle = localizations.translate('reservation_details_title');
    }
    if (teacherName.trim().isEmpty) {
      teacherName = localizations.translate('not_available');
    }
    if (room.isEmpty) {
      room = localizations.translate('not_available');
    }

    return IntrinsicHeight(
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                gradient: AppColors.blueGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('reservation_details_title'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    examTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _DetailChip(
                        icon: Icons.calendar_today_outlined,
                        text: toCamelCase(date),
                      ),
                      _DetailChip(
                        icon: Icons.access_time,
                        text: formattedTime,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(getAssetForCourseInfo(courseInfo)),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailLine(
                          icon: Icons.person_outline_rounded,
                          text: teacherName,
                        ),
                        if (courseInfo.isNotEmpty)
                          _DetailLine(
                            icon: Icons.description_outlined,
                            text: courseInfo,
                          ),
                        _DetailLine(
                          icon: Icons.location_on_outlined,
                          text:
                              '${AppLocalizations.of(context).translate('reservation_room')}: $room',
                              
                        ),
                        _DetailLine(
                          icon: Icons.groups_outlined,
                          text:
                              '${localizations.translate('reservation_number')}: ${reservation.numIscritti ?? localizations.translate('not_available')}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
