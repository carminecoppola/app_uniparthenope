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

  Map<String, String> formatProfName(String profString) {
    String profName = profString.split(' Aula')[0];
    String label;
    String value;

    if (profName.contains('prof.ssa')) {
      label = 'Prof.ssa: ';
      value = profName.replaceFirst('prof.ssa ', '');
    } else if (profName.contains('Prof.')) {
      label = 'Prof: ';
      value = profName.replaceFirst('Prof. ', '');
    } else if (profName.contains('Proff.')) {
      label = 'Prof: ';
      value = profName.replaceFirst('Proff. ', '');
    } else if (profName.contains('proff.')) {
      label = 'Prof: ';
      value = profName.replaceFirst('proff. ', '');
    } else if (profName.contains('prof.')) {
      label = 'Prof: ';
      value = profName.replaceFirst('prof. ', '');
    } else if (profName.contains('Prof.ssa')) {
      label = 'Prof.ssa: ';
      value = profName.replaceFirst('Prof.ssa ', '');
    } else {
      label = 'Prof: ';
      value = profName;
    }

    return {'label': label, 'value': value};
  }

  @override
  Widget build(BuildContext context) {
    final filteredRooms =
        rooms.where((room) => room.area == selectedArea).toList();

    if (filteredRooms.isEmpty) {
      return const CustomMessageCard(
        icon: Icons.event_busy,
        text: 'Nessuna aula è stata prenotata per questo ateneo oggi',
        color: AppColors.errorColor,
      );
    } else if (filteredRooms == '...seleziona Ateneo...') {
      return const CustomMessageCard(
        icon: Icons.arrow_upward,
        text: 'Non hai selezionato nessun Ateneo...',
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

            final dateI = DateFormat('yyyy-MM-dd').format(dateTimeStart);
            final timeI = DateFormat('HH:mm').format(dateTimeStart);
            final dateF = DateFormat('yyyy-MM-dd').format(dateTimeEnd);
            final timeF = DateFormat('HH:mm').format(dateTimeEnd);
            final profInfo = formatProfName(service.prof.toString());

            return RoomsCard(
              title: service.courseName.toString().replaceAll('"', ''),
              profLabel: profInfo['label']!,
              profValue: profInfo['value']!,
              aula: service.room!.name.toString(),
              descrizioneAula: service.room!.description.toString(),
              dateI: dateI,
              timeI: timeI,
              dateF: dateF,
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
