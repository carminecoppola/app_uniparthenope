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

    // Aggiungi degli eventi di esempio
    _events.add(Event(DateTime.now(), "Esame Architettura Dei Calcolatori",
        'Prova pratica', 'AULA 1 Primo Piano'));
    _events.add(Event(DateTime.now().add(const Duration(days: 4)),
        "Esame Tecnologie Web", 'Prova orale', 'AULA 6'));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
          title: Center(
            child: Text(
              event.name,
              style: const TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Descrizione: ${event.description}',
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                ),
              ),
              Text(
                'Aula: ${event.aula}',
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                ),
              ),
              Text(
                'Data: $formattedDate',
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Chiudi',
                style: TextStyle(color: AppColors.backgroundColor),
              ),
            ),
          ],
          backgroundColor:
              AppColors.primaryColor, // Colore dello sfondo della modale
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
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
