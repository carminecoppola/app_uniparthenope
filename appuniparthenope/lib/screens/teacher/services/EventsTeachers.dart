import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:appuniparthenope/widget/ServicesWidget/eventsCard.dart';
import 'package:appuniparthenope/widget/bottomNavBarProf.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../model/studentService/events_data.dart';
import '../../../provider/exam_provider.dart';
import '../../../widget/circularProgressIndicator.dart';

class EventsTeachersPage extends StatefulWidget {
  const EventsTeachersPage({super.key});

  @override
  State<EventsTeachersPage> createState() => _EventsTeachersPageState();
}

class _EventsTeachersPageState extends State<EventsTeachersPage> {
  @override
  Widget build(BuildContext context) {
    final eventsDataProvider = Provider.of<ExamDataProvider>(context);
    final List<EventsInfo>? events = eventsDataProvider.allEventsList;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
            width: 30,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: events != null && events.isNotEmpty
                ? ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final startTime = DateFormat('HH:mm').format(event.start);
                      final endTime = DateFormat('HH:mm').format(event.end);
                      return EventsCard(
                        title: event.courseName,
                        aula: event.room.name,
                        descrizioneAula: event.room.description,
                        dateI: DateFormat('dd/MM/yyyy').format(event.start),
                        timeI: startTime,
                        dateF: DateFormat('dd/MM/yyyy').format(event.end),
                        timeF: endTime,
                        totalSeats: event.room.capacity.toInt(),
                        occupiedSeats: event.room.availability.toInt(),
                      );
                    },
                  )
                : events != null && events.isEmpty
                    ? const Center(
                        child: Text('Nessun evento disponibile.'),
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
          )
        ],
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }
}
