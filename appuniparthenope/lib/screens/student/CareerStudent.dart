import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/TotalExamStudentCard.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/singleExamCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/bottomNavBar_provider.dart';
import '../../widget/CustomLoadingIndicator.dart';

class StudentCarrerPage extends StatefulWidget {
  const StudentCarrerPage({super.key});

  @override
  State<StudentCarrerPage> createState() => _StudentCarrerPageState();
}

class _StudentCarrerPageState extends State<StudentCarrerPage> {
  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;
    final totalExamStats =
        Provider.of<ExamDataProvider>(context).totalExamStudent;
    final aritmeticAverageStats =
        Provider.of<ExamDataProvider>(context).aritmeticAverageStatsStudent;
    final weightedAverageStats =
        Provider.of<ExamDataProvider>(context).weightedAverageStatsStudent;
    final allExamInfo = Provider.of<ExamDataProvider>(context).allExamStudent;

    final bottomNavBarProvider =
        Provider.of<BottomNavBarProvider>(context, listen: false);
    bottomNavBarProvider.updateIndex(0);

    // Verifica lo stato della carriera
    CareerState careerState = checkCareerState(
      totalExamStats: totalExamStats,
      aritmeticAverageStats: aritmeticAverageStats,
      weightedAverageStats: weightedAverageStats,
      allExamInfo: allExamInfo,
    );

    // In base allo stato, mostra il contenuto corretto
    switch (careerState) {
      case CareerState.loading:
        return Scaffold(
          appBar:
              NavbarComponent(role: authenticatedUser!.user.grpDes.toString()),
          body: Center(
            child: CustomLoadingIndicator(
              text: AppLocalizations.of(context).translate('loading_career'),
              myColor: AppColors.primaryColor,
            ),
          ),
          bottomNavigationBar: const BottomNavBarComponent(),
        );
      case CareerState.empty:
        return Scaffold(
          appBar: const NavbarComponent(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.school,
                          size: 50,
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context).translate('empty_exam'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
      case CareerState.populated:
        final bottomNavBarProvider =
            Provider.of<BottomNavBarProvider>(context, listen: false);
        bottomNavBarProvider.updateIndex(0);
        return Scaffold(
          appBar: const NavbarComponent(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: TotalExamStudentCard(
                  mediaTrentesimi: (weightedAverageStats!.trenta
                        ..toStringAsFixed(1))
                      .toString(),
                  mediaCentesimi: weightedAverageStats.centodieci.toString(),
                  totTrentesimi: weightedAverageStats.baseTrenta.toString(),
                  totCentesimi: weightedAverageStats.baseCentodieci.toString(),
                  cfuPar: '${totalExamStats!.cfuPar.toInt()}',
                  cfuTot: '${totalExamStats.cfuTot.toInt()}',
                  examSuperati: totalExamStats.numAdSuperate,
                  examTotali: totalExamStats.totAdSuperate,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: allExamInfo!.length,
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
                    bool withHonors = singleExam.status.lode == 1;
                    return SingleExamCard(
                      key: UniqueKey(),
                      index: index + 1,
                      cfuExam: singleExam.cfu!.toInt().toString(),
                      titleExam: singleExam.nome.toString(),
                      dateExam: singleExam.status.data != ""
                          ? '- ${AppLocalizations.of(context).translate('completed')}: ${singleExam.status.data!.toString().split(" ")[0]}'
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
      default:
        return const SizedBox.shrink();
    }
  }
}

enum CareerState { loading, empty, populated }

CareerState checkCareerState({
  required totalExamStats,
  required aritmeticAverageStats,
  required weightedAverageStats,
  required allExamInfo,
}) {
  print('Dati checkCareerState():\n\ntotalExamStats: $totalExamStats');
  print('aritmeticAverageStats: $aritmeticAverageStats');
  print('weightedAverageStats: $weightedAverageStats');
  print('allExamInfo: $totalExamStats');

  // Se i dati non sono ancora caricati
  if (totalExamStats == null || allExamInfo == null) {
    return CareerState.loading;
  }

  // Se la lista degli esami è vuota oppure se le medie sono nulle o pari a 0
  if (allExamInfo.isEmpty ||
      (aritmeticAverageStats == null && weightedAverageStats == null) ||
      (aritmeticAverageStats != null &&
          aritmeticAverageStats.trenta == 0 &&
          weightedAverageStats != null &&
          weightedAverageStats.trenta == 0)) {
    return CareerState.empty;
  }

  // Se ci sono esami nella lista e medie valide
  return CareerState.populated;
}
