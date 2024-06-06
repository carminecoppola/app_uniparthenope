import 'package:flutter/material.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/main.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../../provider/exam_provider.dart';
import 'singlAppointmentCard.dart';

class HomeAppointmentsCard extends StatelessWidget {
  const HomeAppointmentsCard({
    super.key,
  });

  // Funzione per formattare la data nel formato desiderato
  String formatAppointmentDate(DateTime date) {
    final String dayOfMonth = DateFormat('dd', 'it_IT').format(date);
    final String month = DateFormat('MM', 'it_IT').format(date);
    return '$dayOfMonth/$month';
  }

  @override
  Widget build(BuildContext context) {
    // Inizializza la localizzazione per l'italiano
    initializeDateFormatting('it_IT');

    final reservationExam =
        Provider.of<ExamDataProvider>(context).allReservationInfo;

    // Se i dati sono ancora in caricamento, mostra il caricamento
    if (reservationExam == null) {
      return const Center(
        child: CustomLoadingIndicator(
          text: 'Caricamento ultime prenotazioni...',
          myColor: AppColors.primaryColor,
        ),
      );
    }

    // Prendi le ultime due prenotazioni, se disponibili
    final lastTwoReservations = reservationExam.length >= 2
        ? reservationExam.sublist(0, 2)
        : reservationExam;

    // Crea una lista di SingleAppointmentCard per le ultime due prenotazioni
    final appointmentCards = lastTwoReservations.map((reservation) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleAppointmentCard(
          iconData: Icons.school,
          reservation: reservation,
        ),
      );
    }).toList();

    return Column(
      children: appointmentCards,
    );
  }
}
