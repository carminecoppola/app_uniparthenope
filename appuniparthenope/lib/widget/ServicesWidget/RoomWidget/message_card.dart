import 'package:flutter/material.dart';

class CustomMessageCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const CustomMessageCard({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          elevation: 7.0,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 198, 198, 198),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: color,
                ),
                const SizedBox(height: 16.0),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
