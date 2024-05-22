import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class SingleCourseCard extends StatelessWidget {
  final int index;
  final String cfuExam;
  final String titleExam;
  final String status;
  final String codiceCorso;
  final String annoAccademico;

  const SingleCourseCard({
    super.key,
    required this.index,
    required this.cfuExam,
    required this.titleExam,
    required this.status,
    required this.codiceCorso,
    required this.annoAccademico,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = getStatusColor(status);

    return Card(
      color: AppColors.primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$cfuExam\nCFU',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleExam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '- Codice: $codiceCorso',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '- Anno Accademico: $annoAccademico',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Stato',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Superata':
        return AppColors.successColor;
      case 'Pianificata':
        return AppColors.detailsColor;
      default:
        return AppColors.lightGray;
    }
  }
}
