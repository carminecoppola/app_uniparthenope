import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class UniversityCardWidget extends StatelessWidget {
  final String nome;
  final String immagine;

  const UniversityCardWidget({
    super.key,
    required this.nome,
    required this.immagine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(immagine),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            nome,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              backgroundColor: Color.fromARGB(255, 226, 226, 226),
            ),
          ),
        ),
      ),
    );
  }
}
