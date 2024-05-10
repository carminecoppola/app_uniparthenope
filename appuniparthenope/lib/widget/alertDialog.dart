import 'package:flutter/material.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Color color;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            buttonText,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
