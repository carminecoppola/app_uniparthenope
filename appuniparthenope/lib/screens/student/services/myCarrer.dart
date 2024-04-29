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
    final allExamInfo = Provider.of<ExamDataProvider>(context).allExamStudent;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (totalExamStats != null)
            Center(
              child: TotalExamStudentCard(
                cfuPar: '${totalExamStats.cfuPar}',
                cfuTot: '${totalExamStats.cfuTot}',
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
                  return SingleExamCard(
                    index: index + 1,
                    cfuExam: singleExam.adId.toString(),
                    titleExam: singleExam.nome.toString(),
                    voteExam: singleExam.codice.toString(),
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
