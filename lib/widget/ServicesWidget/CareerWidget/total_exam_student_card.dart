import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/loading_exams_circle.dart';

class TotalExamStudentCard extends StatelessWidget {
  final String cfuPar, cfuTot;
  final int examSuperati, examTotali;
  final String mediaTrentesimi, mediaCentesimi;
  final String totTrentesimi, totCentesimi;

  const TotalExamStudentCard({
    super.key,
    required this.mediaTrentesimi,
    required this.mediaCentesimi,
    required this.cfuPar,
    required this.cfuTot,
    required this.examSuperati,
    required this.examTotali,
    required this.totTrentesimi,
    required this.totCentesimi,
  });

  @override
  Widget build(BuildContext context) {
    // Controlla se ci sono esami
    if (examTotali == 0) {
      return const SizedBox(
        height: 50,
      );
    }

    // Usa la funzione di utilità per ottenere il valore formattato di cfuTot
    final formattedCfuTot = formatCfuValue(cfuPar, cfuTot);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: kIsWeb ? 700 : double.infinity,
        height: 108,
        decoration: BoxDecoration(
          gradient: AppColors.blueGradient,
          borderRadius: const BorderRadius.all(Radius.circular(22.0)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDarkColor.withValues(alpha: 0.20),
              spreadRadius: 1,
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              spreadRadius: -2,
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_graph_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context).translate('avg_weight'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          mediaTrentesimi,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '/$totTrentesimi',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          mediaCentesimi,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/$totCentesimi',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressCircleCounter(
                      totalCount: examTotali,
                      completedExams: examSuperati,
                      textColor: Colors.white,
                      secondaryTextColor: Colors.white70,
                      backgroundColor: Colors.white24,
                      size: 74,
                      strokeWidth: 8,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 12, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.workspace_premium_outlined,
                          size: 14,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'CFU',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$cfuPar/',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          formattedCfuTot,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Funzione per errore CFU che serve a comparare
// e formattare il valore totale di CFU
String formatCfuValue(String cfuPar, String cfuTot) {
  // Converti i valori in double
  double cfuParValue = double.tryParse(cfuPar) ?? 0.0;
  double cfuTotValue = double.tryParse(cfuTot) ?? 0.0;

  // Se cfuPar è maggiore di cfuTot, imposta cfuTot uguale a cfuPar
  if (cfuParValue > cfuTotValue) {
    cfuTotValue = cfuParValue;
  }

  // Converti a intero se il numero non ha decimali significativi
  return cfuTotValue % 1 == 0
      ? cfuTotValue.toInt().toString()
      : cfuTotValue.toString();
}
