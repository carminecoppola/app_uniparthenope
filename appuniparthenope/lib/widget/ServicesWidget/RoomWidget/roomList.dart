import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appuniparthenope/model/teacherService/room_data.dart';
import '../../../widget/ServicesWidget/RoomWidget/roomsCard.dart';
import 'messageCard.dart';

class RoomsList extends StatelessWidget {
  final List<AllTodayRooms> rooms;
  final String selectedArea;

  const RoomsList({
    super.key,
    required this.rooms,
    required this.selectedArea,
  });

  Map<String, String> formatProfName(String profString, context) {
    String profName = profString.split(' Aula')[0];
    String label;
    String value;

    if (profName.contains('prof.ssa')) {
      label = '${AppLocalizations.of(context).translate('profssa_label')}: ';
      value = profName.replaceFirst('prof.ssa ', '');
    } else if (profName.contains('Prof.')) {
      label = '${AppLocalizations.of(context).translate('prof_label')}: ';
      value = profName.replaceFirst('Prof. ', '');
    } else if (profName.contains('Proff.')) {
      label = '${AppLocalizations.of(context).translate('prof_label')}: ';
      value = profName.replaceFirst('Proff. ', '');
    } else if (profName.contains('proff.')) {
      label = '${AppLocalizations.of(context).translate('prof_label')}: ';
      value = profName.replaceFirst('proff. ', '');
    } else if (profName.contains('prof.')) {
      label = '${AppLocalizations.of(context).translate('prof_label')}: ';
      value = profName.replaceFirst('prof. ', '');
    } else if (profName.contains('Prof.ssa')) {
      label = '${AppLocalizations.of(context).translate('profssa_label')}: ';
      value = profName.replaceFirst('Prof.ssa ', '');
    } else {
      label = '${AppLocalizations.of(context).translate('prof_label')}: ';
      value = profName;
    }

    return {'label': label, 'value': value};
  }

  String formatDate(DateTime date, context) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    if (date.year == startOfToday.year &&
        date.month == startOfToday.month &&
        date.day == startOfToday.day) {
      return AppLocalizations.of(context).translate('today');
    } else if (date.year == startOfTomorrow.year &&
        date.month == startOfTomorrow.month &&
        date.day == startOfTomorrow.day) {
      return AppLocalizations.of(context).translate('tomorrow');
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRooms =
        rooms.where((room) => room.area == selectedArea).toList();

    if (filteredRooms.isEmpty) {
      return CustomMessageCard(
        icon: Icons.event_busy,
        text: AppLocalizations.of(context).translate('not_reserved_rooms'),
        color: AppColors.errorColor,
      );
    } else if (filteredRooms == '...seleziona Ateneo...') {
      return CustomMessageCard(
        icon: Icons.arrow_upward,
        text: AppLocalizations.of(context).translate('not_selected_rooms'),
        color: AppColors.detailsColor,
      );
    }

    return ListView.builder(
      itemCount: filteredRooms.length,
      itemBuilder: (context, index) {
        final room = filteredRooms[index];
        return Column(
          children: room.services!.map((service) {
            final dateTimeStart = DateTime.parse(service.start.toString());
            final dateTimeEnd = DateTime.parse(service.end.toString());

            final startDateString = formatDate(dateTimeStart, context);
            final endDateString = formatDate(dateTimeEnd, context);
            final isSameDay = dateTimeStart.day == dateTimeEnd.day &&
                dateTimeStart.month == dateTimeEnd.month &&
                dateTimeStart.year == dateTimeEnd.year;

            final timeI = DateFormat('HH:mm').format(dateTimeStart);
            final timeF = DateFormat('HH:mm').format(dateTimeEnd);
            final profInfo = formatProfName(service.prof.toString(), context);

            return RoomsCard(
              title: service.courseName.toString().replaceAll('"', ''),
              profLabel: profInfo['label']!,
              profValue: profInfo['value']!,
              aula: service.room!.name.toString(),
              descrizioneAula: service.room!.description.toString(),
              dateI: startDateString,
              timeI: timeI,
              dateF: isSameDay
                  ? AppLocalizations.of(context).translate('today2')
                  : endDateString,
              timeF: timeF,
              totalSeats: service.room!.capacity!,
              occupiedSeats: service.room!.availability!,
            );
          }).toList(),
        );
      },
    );
  }
}
