import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa questa libreria
import 'package:appuniparthenope/main.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

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
    _events.add(Event(DateTime.now(), "Titolo primo evento"));
    _events.add(Event(
        DateTime.now().add(const Duration(days: 1)), "Titolo secondo evento"));
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
  void _showEventDialog(DateTime selectedDay) {
    Event? event = _events.firstWhere(
      (event) => isSameDay(event.date, selectedDay),
      orElse: () => Event(DateTime.now(), "Nessun evento"),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.name),
          content: Text(event.date.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }
}

// Classe per rappresentare un evento
class Event {
  final DateTime date;
  final String name;

  Event(this.date, this.name);
}
