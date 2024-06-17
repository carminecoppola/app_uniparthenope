import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PersonalCardUser extends StatelessWidget {
  final VoidCallback onTap;
  final String firstName;
  final String lastName;
  final String? identificativoLabel;
  final String? id;
  final String? profileImage;

  const PersonalCardUser({
    super.key,
    required this.onTap,
    required this.firstName,
    required this.lastName,
    this.identificativoLabel,
    this.id,
    this.profileImage,
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
          width: kIsWeb ? 800 : 350,
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\t\t- $identificativoLabel ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: id ?? '',
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.detailsColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 35,
                backgroundImage: profileImage != null
                    ? Image.asset(profileImage!).image
                    : Image.asset(
                        'assets/user_profile_default.jpg',
                      ).image,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.detailsColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
