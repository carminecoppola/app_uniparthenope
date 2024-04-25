import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 380,
        height: 180,
        alignment: Alignment.center,
      ),
    );
  }
}
