import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsOverlay extends StatelessWidget {
  const StudentsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final students =
        Provider.of<ProfessorDataProvider>(context).allStudentListExam;

    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Prenotati',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              if (students == null) ...[
                const Expanded(
                  child: CustomLoadingIndicator(
                    text: 'Caricamento lista studenti...',
                    myColor: AppColors.detailsColor,
                  ),
                ),
              ] else if (students.isEmpty) ...[
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Non ci sono prenotati per questo esame',
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                Center(
                  child: Text(
                    'Numero di prenotati ${students.length}',
                    style: const TextStyle(
                        color: AppColors.lightGray, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Studente: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.lightGray,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${toCamelCase(student.nomeStudente)} ${toCamelCase(student.cognomeStudente)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Matricola: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.lightGray,
                                ),
                                children: [
                                  TextSpan(
                                    text: student.matricola,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.detailsColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                            const Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Chiudi',
                    style: TextStyle(
                      color: AppColors.primaryColor,
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
