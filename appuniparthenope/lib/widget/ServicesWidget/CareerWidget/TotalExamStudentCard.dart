import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/loadingExamsCircle.dart';

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
    final Color textColor = examSuperati == examTotali
        ? AppColors.successColor
        : AppColors.detailsColor;

    // Controlla se ci sono esami
    if (examTotali == 0) {
      return const SizedBox(
        height: 50,
      );
    }

    // Usa la funzione di utilità per ottenere il valore formattato di cfuTot
    final formattedCfuTot = formatCfuValue(cfuPar, cfuTot);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: kIsWeb ? 700 : 350,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Colonna media pesata, centrale!
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('avg_weight'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mediaTrentesimi,
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '/$totTrentesimi',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mediaCentesimi,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '/$totCentesimi',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Cerchio centrale
            Expanded(
              flex: 3,
              child: Center(
                child: ProgressCircleCounter(
                  totalCount: examTotali,
                  completedExams: examSuperati,
                  textColor: textColor,
                ),
              ),
            ),
            // Colonna CFU, centrale!
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'CFU',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$cfuPar/',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        Text(
                          formattedCfuTot,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textColor,
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
