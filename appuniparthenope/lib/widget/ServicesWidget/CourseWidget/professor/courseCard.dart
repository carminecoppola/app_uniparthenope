import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

import 'courseInfoText.dart';

class CourseCard extends StatelessWidget {
  final String adDes;
  final String cdsDes;
  final String inizio;
  final String fine;
  final String ultMod;
  final String sede;

  const CourseCard({
    super.key,
    required this.adDes,
    required this.cdsDes,
    required this.inizio,
    required this.fine,
    required this.ultMod,
    required this.sede,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showOverlay(context);
      },
      child: Container(
        margin: const EdgeInsets.all(15.0),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Card(
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toCamelCase(adDes),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        toCamelCase(cdsDes),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 181, 181, 181),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    toCamelCase(adDes),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.detailsColor, // Colore del testo bianco
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LabelValueText(
                  label: 'Corso di studi:',
                  value: toCamelCase(cdsDes),
                ),
                Row(
                  children: [
                    Expanded(
                      child: LabelValueText(
                        label: 'Inizio:',
                        value: inizio,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LabelValueText(
                        label: 'Fine:',
                        value: fine,
                      ),
                    ),
                  ],
                ),
                LabelValueText(
                  label: 'Sede:',
                  value: toCamelCase(sede),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Chiudi',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
