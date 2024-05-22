import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarWidget.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CalendarWidget(),
    );
  }
}
