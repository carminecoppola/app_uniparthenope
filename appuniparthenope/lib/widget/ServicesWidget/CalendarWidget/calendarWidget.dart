import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa questa libreria
import 'package:appuniparthenope/main.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    initializeDateFormatting('it_IT');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: 350,
        height: 355,
        child: TableCalendar(
          locale: 'it_IT', // Imposta il calendario in italiano
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2040, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          daysOfWeekHeight: 50,
          rowHeight: 40,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          weekendDays: const [DateTime.saturday, DateTime.sunday],
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            // Mostra il dialogo quando un giorno viene selezionato
            _showEventDialog(selectedDay);
          },
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            weekendStyle: TextStyle(
              color: AppColors.lightGray,
              fontSize: 17,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.primaryColor,
            ),
          ),
          headerVisible: true,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) {
            return _events
                .where((event) => isSameDay(event.date, day))
                .toList();
          },
        ),
      ),
    );
  }

  // Metodo per mostrare il dialogo dell'evento
// Metodo per mostrare il dialogo dell'evento
  void _showEventDialog(DateTime selectedDay) {
    Event? event = _events.firstWhere(
      (event) => isSameDay(event.date, selectedDay),
      orElse: () => Event(DateTime.now(), "Nessun evento",
          'Nessuna descrizione', 'Aula non disponibile'),
    );

    // Formatta la data nel formato desiderato
    String formattedDate = DateFormat('dd/MM/yyyy').format(event.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Parte superiore blu con il titolo e l'icona
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school, // Icona esame
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        event.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Parte centrale bianca con le info allineate a sinistra
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        event.description,
                        style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '\u2022 Aula: ${event.aula}',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\u2022 Data: $formattedDate',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              // Bottone chiudi di colore blu con testo bianco
              Container(
                padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Chiudi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Classe per rappresentare un evento
class Event {
  final DateTime date;
  final String name;
  final String description;
  final String aula;

  Event(this.date, this.name, this.description, this.aula);
}
