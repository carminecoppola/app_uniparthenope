import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import '../../../model/studentService/check_appello_data.dart';

class AppelloCard extends StatelessWidget {
  final CheckAppello appello;
  final VoidCallback? onPrenota;

  const AppelloCard({super.key, required this.appello, this.onPrenota});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appello.dataEsame != null && appello.dataEsame!.isNotEmpty)
              Text('Data: ${appello.dataEsame}'),
            if (appello.docenteCompleto != null &&
                appello.docenteCompleto!.isNotEmpty)
              Text('Docente: ${appello.docenteCompleto}'),
            const SizedBox(height: 6),
            Row(
              children: [
                if (appello.statoDes != null && appello.statoDes!.isNotEmpty)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appello.dataEsame!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onPrenota ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Prenota',
                    style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (appello.note != null && appello.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'Note: ${appello.note}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
