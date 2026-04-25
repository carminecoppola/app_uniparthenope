import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa questa libreria
import 'package:appuniparthenope/main.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
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
    final locale = Localizations.localeOf(context).toString();
    final monthLabel = DateFormat('MMMM yyyy', locale).format(_focusedDay);
    final selectedLabel = DateFormat('EEE d MMM', locale).format(_selectedDay);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDarkColor.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monthLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.76),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _CalendarNavButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month - 1);
                  }),
                ),
                const SizedBox(width: 6),
                _CalendarNavButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month + 1);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TableCalendar(
            locale: locale,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2040, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            daysOfWeekHeight: 28,
            rowHeight: 36,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            weekendDays: const [DateTime.saturday, DateTime.sunday],
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showEventDialog(selectedDay);
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              weekendStyle: TextStyle(
                color: AppColors.lightGray,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            headerStyle: const HeaderStyle(
              headerPadding: EdgeInsets.zero,
              leftChevronVisible: false,
              rightChevronVisible: false,
              formatButtonVisible: false,
              titleTextFormatter: _emptyHeaderTitle,
              titleTextStyle: TextStyle(
                fontSize: 0,
              ),
            ),
            headerVisible: false,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: const EdgeInsets.all(3),
              defaultTextStyle: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.w700,
              ),
              weekendTextStyle: TextStyle(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.56),
                fontWeight: FontWeight.w700,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.w800,
              ),
              selectedDecoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.26),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            eventLoader: (day) {
              return _events
                  .where((event) => isSameDay(event.date, day))
                  .toList();
            },
          ),
        ],
      ),
    );
  }

  // Metodo per mostrare il dialogo dell'evento
// Metodo per mostrare il dialogo dell'evento
  void _showEventDialog(DateTime selectedDay) {
    Event? event = _events.firstWhere(
      (event) => isSameDay(event.date, selectedDay),
      orElse: () => Event(
          DateTime.now(),
          AppLocalizations.of(context).translate('no_events_found2'),
          AppLocalizations.of(context).translate('no_dsc'),
          AppLocalizations.of(context).translate('no_rooms')),
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
                      '\u2022 ${AppLocalizations.of(context).translate('rooms')}: ${event.aula}',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\u2022 ${AppLocalizations.of(context).translate('date')}: $formattedDate',
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
                    child: Text(
                      AppLocalizations.of(context).translate('close'),
                      style: const TextStyle(
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

String _emptyHeaderTitle(DateTime date, dynamic locale) => '';

class _CalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CalendarNavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
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
