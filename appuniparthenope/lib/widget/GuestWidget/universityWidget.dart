import 'package:appuniparthenope/widget/GuestWidget/uniDetailsWidget.dart';
import 'package:flutter/material.dart';

class UniversityInfo {
  final String nome;
  final String descrizione;
  final String indirizzo;
  final List<String> immagini;

  UniversityInfo({
    required this.nome,
    required this.descrizione,
    required this.indirizzo,
    required this.immagini,
  });
}

class UniversityCardWidget extends StatelessWidget {
  final UniversityInfo universityInfo;

  const UniversityCardWidget({
    super.key,
    required this.universityInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUniversityDetail(context, universityInfo),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                image: AssetImage(universityInfo.immagini[0]),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            universityInfo.nome,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showUniversityDetail(
      BuildContext context, UniversityInfo universityInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: const Color.fromARGB(255, 15, 81, 118),
      builder: (context) {
        return UniversityDetailWidget(universityInfo: universityInfo);
      },
    );
  }
}
