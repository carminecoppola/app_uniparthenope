import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/widget/ServicesWidget/AppointmentsWidget/singlAppointmentCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../provider/exam_provider.dart';

enum FilterType { past, upcoming }

class ReservationListWidget extends StatelessWidget {
  final String searchQuery;
  final FilterType filterType;

  const ReservationListWidget({
    super.key,
    required this.searchQuery,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    // Ottieni tutte le informazioni sulle prenotazioni dal provider
    final reservations =
        Provider.of<ExamDataProvider>(context).allReservationInfo;

    final now = DateTime.now(); // Data e ora attuali

    // Filtra le prenotazioni in base alla query di ricerca e al tipo di filtro (passato o futuro)
    final filteredReservations = reservations!.where((reservation) {
      final isMatch = reservation.nomeAppello
              ?.toLowerCase()
              .contains(searchQuery.toLowerCase()) ??
          false;

      // Converte la stringa dataEsa in DateTime e gestisce eventuali errori di conversione
      DateTime? reservationDate;
      try {
        reservationDate =
            DateTime.parse(reservation.dataEsa!.replaceAll('/', '-'));
      } catch (e) {
        // Se la conversione fallisce, considera la data nulla.
        reservationDate = null;
      }

      // Determina se la prenotazione è passata o futura
      final isPast = reservationDate != null && reservationDate.isBefore(now);
      final isUpcoming = reservationDate != null &&
          (reservationDate.isAfter(now) ||
              reservationDate.isAtSameMomentAs(now));

      // Restituisce il risultato del filtro in base al tipo specificato
      if (filterType == FilterType.past) {
        return isMatch && isPast;
      } else {
        return isMatch && isUpcoming;
      }
    }).toList();

    // Messaggi di testo e icone per il caso in cui non ci siano prenotazioni
    String emptyMessage = '';
    IconData emptyIcon;
    if (filterType == FilterType.past) {
      emptyMessage = AppLocalizations.of(context).translate('no_past_reservations');
      emptyIcon = Icons.history;
    } else {
      emptyMessage = AppLocalizations.of(context).translate('no_upcoming_reservations');
      emptyIcon = Icons.event;
    }

    // Restituisce il widget principale, decorato e contenente la lista di prenotazioni filtrate
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      // Controlla se la lista filtrata è vuota e mostra un messaggio appropriato
      child: filteredReservations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    emptyIcon,
                    size: 50,
                    color: AppColors.backgroundColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.backgroundColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView(
              // Aggiungi ListView per rendere la lista verticale scorrevole
              children: [
                // Mappa ogni prenotazione filtrata a un widget di visualizzazione
                ...filteredReservations.map((reservation) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(5.0),
                    child: SingleAppointmentCard(
                      iconData: Icons.school,
                      reservation: reservation,
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
