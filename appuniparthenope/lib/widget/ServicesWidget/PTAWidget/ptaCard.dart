import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import '../../../model/user_data_login.dart';

class PtaCard extends StatelessWidget {
  final User user;
  final String fotoUrl;

  const PtaCard({
    super.key,
    required this.user,
    required this.fotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.primaryColor, // Colore oro
          width: 4.0, // Spessore del bordo
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto dell'utente in un contenitore di dimensione fissa
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(fotoUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${toCamelCase(user.lastName)} ${toCamelCase(user.firstName)}',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                // Codice Fiscale allineato al centro
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.codFis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.lightGray,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4.0),
                // Ruolo con testo in grassetto e diverso colore
                RichText(
                  text: TextSpan(
                    text: 'Ruolo: ',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.lightGray,
                    ),
                    children: [
                      TextSpan(
                        text: user.grpDes == 'PTA'
                            ? 'Personale Tecnico'
                            : user.grpDes,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.detailsColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
