import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String text;
  final Color myColor;

  const CustomLoadingIndicator({
    super.key,
    required this.text,
    required this.myColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myColor),
                strokeWidth: 5.0,
              ),
            ),
            // Replace this with your own logo asset
            Image.asset(
              'assets/logo.png',
              width: 60,
              height: 60,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: myColor,
          ),
        ),
      ],
    );
  }
}
