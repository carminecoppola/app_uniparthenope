import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarWidget.dart';
import 'package:appuniparthenope/screens/student/ReservationStudent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final reservation =
        Provider.of<ExamDataProvider>(context).allReservationInfo ??
            []; // Fornisci una lista vuota se la lista di prenotazioni è null
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const CalendarWidget(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReservationPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.book,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const Text(
            'Visualizza lista prenotazioni',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
