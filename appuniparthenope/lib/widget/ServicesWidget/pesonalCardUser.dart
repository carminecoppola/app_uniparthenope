import 'dart:io';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class PersonalCardUser extends StatelessWidget {
  final VoidCallback onTap;
  final String firstName;
  final String lastName;
  final String? id;
  final File? profileImage;

  const PersonalCardUser({
    required this.onTap,
    required this.firstName,
    required this.lastName,
    this.id,
    this.profileImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 9, // Aggiunge profondità alla card
        shadowColor: Colors.black.withOpacity(1.0), // Aggiunge un'ombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bordi arrotondati
        ),
        child: Container(
          width: 350, //Dimensioni card
          height: 120,
          //Card Studente
          padding: const EdgeInsets.all(20), // Padding interno
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(30), // Bordi arrotondati
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    // Mostra l'id dell'utente
                    '\t- Matricola: ${id ?? ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 30,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : Image.asset(
                        'assets/user_profile.jpg',
                      ).image,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
