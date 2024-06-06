import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/exam_provider.dart';
import '../AppointmentsWidget/singlAppointmentCard.dart';

class ReservationListWidget extends StatelessWidget {
  final String searchQuery;

  const ReservationListWidget({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final reservations =
        Provider.of<ExamDataProvider>(context).allReservationInfo;

    final filteredReservations = reservations!.where((reservation) {
      return reservation.nomeAppello
              ?.toLowerCase()
              .contains(searchQuery.toLowerCase()) ??
          false;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        ...filteredReservations.map((reservation) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: SingleAppointmentCard(
              iconData: Icons.school,
              reservation: reservation,
            ),
          );
        }).toList(),
      ],
    );
  }
}
