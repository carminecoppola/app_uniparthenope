import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/EventWidget/custonSearchEventCard.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:appuniparthenope/widget/ServicesWidget/EventWidget/eventsCard.dart';
import 'package:appuniparthenope/widget/bottomNavBarProf.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/studentService/events_data.dart';
import '../../provider/auth_provider.dart';
import '../../provider/exam_provider.dart';
import '../../widget/CustomLoadingIndicator.dart';

class EventsTeachersPage extends StatefulWidget {
  const EventsTeachersPage({super.key});

  @override
  State<EventsTeachersPage> createState() => _EventsTeachersPageState();
}

class _EventsTeachersPageState extends State<EventsTeachersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    if (date.isAtSameMomentAs(startOfToday)) {
      return 'Oggi';
    } else if (date.isAtSameMomentAs(startOfTomorrow)) {
      return 'Domani';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

    final eventsDataProvider = Provider.of<ExamDataProvider>(context);
    final List<EventsInfo>? events = eventsDataProvider.allEventsList;

    // Filtrare gli eventi in base al testo di ricerca
    List<EventsInfo>? filteredEvents = events?.where((event) {
      final searchTextLower = _searchText.toLowerCase();
      final courseNameLower = event.courseName.toLowerCase();
      return courseNameLower.contains(searchTextLower);
    }).toList();

    return Scaffold(
      appBar: NavbarComponent(
        role: authenticatedUser!.user.grpDes.toString(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25, width: 30),
          const Center(
            child: Text(
              'Eventi Parthenope',
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Divider(
              color: AppColors.primaryColor,
              height: 10,
              thickness: 2,
              indent: 100,
              endIndent: 100,
            ),
          ),
          const SizedBox(height: 15),
          SearchBarEvent(
            controller: _searchController,
            onChanged: (text) {
              setState(() {
                _searchText = text;
              });
            },
          ),
          const SizedBox(height: 10),
          if (_searchText.isNotEmpty && filteredEvents != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Trovate ${filteredEvents.length} corrispondenze',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredEvents != null && filteredEvents.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final startTime = DateFormat('HH:mm').format(event.start);
                      final endTime = DateFormat('HH:mm').format(event.end);
                      final startDateString = formatDate(event.start);
                      final endDateString = formatDate(event.end);
                      final isSameDay = event.start.day == event.end.day &&
                          event.start.month == event.end.month &&
                          event.start.year == event.end.year;

                      return EventsCard(
                        title: event.courseName,
                        aula: event.room.name,
                        descrizioneAula: event.room.description,
                        dateI: startDateString,
                        timeI: startTime,
                        dateF: isSameDay ? 'In giornata' : endDateString,
                        timeF: endTime,
                        totalSeats: event.room.capacity.toInt(),
                        occupiedSeats: event.room.availability.toInt(),
                      );
                    },
                  )
                : filteredEvents != null && filteredEvents.isEmpty
                    ? const Center(
                        child: Text(
                          'Non è disponibile nessun evento.',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomLoadingIndicator(
                              text: 'Caricamento eventi...',
                              myColor: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }
}
