import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/TotalExamStudentCard.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/singleExamCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/CustomLoadingIndicator.dart';

class StudentCarrerPage extends StatefulWidget {
  const StudentCarrerPage({super.key});

  @override
  State<StudentCarrerPage> createState() => _StudentCarrerPageState();
}

class _StudentCarrerPageState extends State<StudentCarrerPage> {
  @override
  Widget build(BuildContext context) {
    final totalExamStats =
        Provider.of<ExamDataProvider>(context).totalExamStudent;
    final aritmeticAverageStats =
        Provider.of<ExamDataProvider>(context).aritmeticAverageStatsStudent;
    final weightedAverageStats =
        Provider.of<ExamDataProvider>(context).weightedAverageStatsStudent;
    final allExamInfo = Provider.of<ExamDataProvider>(context).allExamStudent;

    // Controlla se qualche dato è null
    if (totalExamStats == null ||
        aritmeticAverageStats == null ||
        weightedAverageStats == null ||
        allExamInfo == null) {
      return const Scaffold(
        appBar: NavbarComponent(),
        body: Center(
          child: CustomLoadingIndicator(
            text: 'Caricamento carriera...',
            myColor: AppColors.primaryColor,
          ),
        ),
        bottomNavigationBar: BottomNavBarComponent(),
      );
    }

    // Se tutti i dati sono presenti, ma la lista degli esami è vuota

    if (allExamInfo.isEmpty) {
      return Scaffold(
        appBar: const NavbarComponent(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: TotalExamStudentCard(
                mediaTrentesimi: weightedAverageStats.trenta.toString(),
                mediaCentesimi: weightedAverageStats.centodieci.toString(),
                totTrentesimi: weightedAverageStats.baseTrenta.toString(),
                totCentesimi: weightedAverageStats.baseCentodieci.toString(),
                cfuPar: '${totalExamStats.cfuPar.toInt()}',
                cfuTot: '${totalExamStats.cfuTot.toInt()}',
                examSuperati: totalExamStats.numAdSuperate,
                examTotali: totalExamStats.totAdSuperate,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school,
                        size: 50,
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Non hai nessun esame nella tua carriera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.detailsColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBarComponent(),
      );
    }

    // Se tutti i dati sono presenti, mostra il contenuto
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: TotalExamStudentCard(
              mediaTrentesimi: weightedAverageStats.trenta.toString(),
              mediaCentesimi: weightedAverageStats.centodieci.toString(),
              totTrentesimi: weightedAverageStats.baseTrenta.toString(),
              totCentesimi: weightedAverageStats.baseCentodieci.toString(),
              cfuPar: '${totalExamStats.cfuPar.toInt()}',
              cfuTot: '${totalExamStats.cfuTot.toInt()}',
              examSuperati: totalExamStats.numAdSuperate,
              examTotali: totalExamStats.totAdSuperate,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: allExamInfo.length,
              itemBuilder: (context, index) {
                final singleExam = allExamInfo[index];
                Color colorCard = singleExam.status.esito != "S"
                    ? const Color.fromARGB(255, 159, 158, 158)
                    : AppColors.primaryColor;
                String voteExam = singleExam.status.esito != "S"
                    ? "??"
                    : singleExam.status.voto != null
                        ? singleExam.status.voto!.toInt().toString()
                        : "OK";
                // Determina se mostrare l'icona della coccarda
                bool withHonors = singleExam.status.lode == 1;
                return SingleExamCard(
                  key:
                      UniqueKey(), // Aggiungiamo una chiave univoca per garantire il rebuild corretto
                  index: index + 1,
                  cfuExam: singleExam.cfu!.toInt().toString(),
                  titleExam: singleExam.nome.toString(),
                  dateExam: singleExam.status.data != ""
                      ? '- Superato: ${singleExam.status.data!.toString().split(" ")[0]}'
                      : "",
                  voteExam: voteExam,
                  colorCard: colorCard,
                  withHonors: withHonors,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
