import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/main.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../provider/exam_provider.dart';
import 'singlAppointmentCard.dart';

class HomeAppointmentsCard extends StatefulWidget {
  const HomeAppointmentsCard({super.key});

  @override
  _HomeAppointmentsCardState createState() => _HomeAppointmentsCardState();
}

class _HomeAppointmentsCardState extends State<HomeAppointmentsCard> {
  bool _isVisible = false;
  bool _isLoadingTimedOut = false;

  @override
  void initState() {
    super.initState();
    // Ritarda la visualizzazione dei card per consentire l'animazione
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });

    // Imposta il timeout per il caricamento
    Timer(const Duration(seconds: 30), () {
      if (!mounted) return; // Verifica se il widget è ancora montato
      setState(() {
        _isLoadingTimedOut = true;
      });
    });
  }

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

    // Se i dati sono ancora in caricamento e non è scaduto il timeout, mostra il caricamento
    if (reservationExam == null && !_isLoadingTimedOut) {
      return Center(
        child: CustomLoadingIndicator(
          text: AppLocalizations.of(context).translate('loading_reservation'),
          myColor: AppColors.primaryColor,
        ),
      );
    }

    // Mostra il messaggio di timeout se i dati non sono disponibili e il timeout è scaduto
    if (reservationExam == null && _isLoadingTimedOut) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.detailsColor,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)
                    .translate('error_loading_reservation'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.lightGray,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (reservationExam != null && reservationExam.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Text(
            AppLocalizations.of(context).translate('empty_reservation'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.lightGray,
            ),
          ),
        ),
      );
    }

    // Prendi le ultime due prenotazioni, se disponibili
    final lastTwoReservations =
        reservationExam != null && reservationExam.length >= 2
            ? reservationExam.sublist(0, 2)
            : reservationExam ?? [];

    // Crea una lista di SingleAppointmentCard per le ultime due prenotazioni
    final appointmentCards = lastTwoReservations.map((reservation) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: SingleAppointmentCard(
            iconData: Icons.school,
            reservation: reservation,
          ),
        ),
      );
    }).toList();

    return Column(
      children: appointmentCards,
    );
  }
}
