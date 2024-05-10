import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/TotalExamStudentCard.dart';
import 'package:appuniparthenope/widget/ServicesWidget/singleExamCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (totalExamStats != null &&
              aritmeticAverageStats != null &&
              weightedAverageStats != null)
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
            )
          else
            // Gestione del caso in cui totalExamStats è null
            const Center(
              child:
                  CircularProgressIndicator(), // Puoi sostituire questo con qualsiasi indicatore di caricamento desiderato
            ),
          const SizedBox(height: 10),
          if (allExamInfo != null)
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
            )
          else
            // Gestione del caso in cui totalExamStats è null
            const Center(
              child:
                  CircularProgressIndicator(), // Puoi sostituire questo con qualsiasi indicatore di caricamento desiderato
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
