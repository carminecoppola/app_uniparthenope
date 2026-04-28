import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/total_exam_student_card.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CareerWidget/single_exam_card.dart';
import 'package:appuniparthenope/widget/bottom_nav_bar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/bottom_nav_bar_provider.dart';
import '../../widget/custom_loading_indicator.dart';

class StudentCarrerPage extends StatefulWidget {
  const StudentCarrerPage({super.key});

  @override
  State<StudentCarrerPage> createState() => _StudentCarrerPageState();
}

class _StudentCarrerPageState extends State<StudentCarrerPage> {
  static const bool _useModernCareerExperience = true;
  static const double _careerListBottomSpacing = 20;

  @override
  void initState() {
    super.initState();
    // Aggiorna l'indice della bottom nav bar dopo il build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<BottomNavBarProvider>(context, listen: false)
            .updateIndex(0);
      }
    });
  }

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
        return Scaffold(
          appBar: const NavbarComponent(),
          body: _useModernCareerExperience
              ? _buildModernCareer(
                  context,
                  totalExamStats: totalExamStats!,
                  weightedAverageStats: weightedAverageStats!,
                  allExamInfo: allExamInfo!,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: TotalExamStudentCard(
                        mediaTrentesimi: (weightedAverageStats!.trenta
                              ..toStringAsFixed(1))
                            .toString(),
                        mediaCentesimi:
                            weightedAverageStats.centodieci.toString(),
                        totTrentesimi:
                            weightedAverageStats.baseTrenta.toString(),
                        totCentesimi:
                            weightedAverageStats.baseCentodieci.toString(),
                        cfuPar: '${totalExamStats!.cfuPar.toInt()}',
                        cfuTot: '${totalExamStats.cfuTot.toInt()}',
                        examSuperati: totalExamStats.numAdSuperate,
                        examTotali: totalExamStats.totAdSuperate,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          kBottomNavigationBarHeight +
                              MediaQuery.viewPaddingOf(context).bottom +
                              _careerListBottomSpacing,
                        ),
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
    }
  }

  Widget _buildModernCareer(
    BuildContext context, {
    required dynamic totalExamStats,
    required dynamic weightedAverageStats,
    required List<dynamic> allExamInfo,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
          child: TotalExamStudentCard(
            mediaTrentesimi: weightedAverageStats.trenta.toStringAsFixed(1),
            mediaCentesimi: weightedAverageStats.centodieci.toStringAsFixed(1),
            totTrentesimi: weightedAverageStats.baseTrenta.toString(),
            totCentesimi: weightedAverageStats.baseCentodieci.toString(),
            cfuPar: '${(totalExamStats.cfuPar as num).toInt()}',
            cfuTot: '${(totalExamStats.cfuTot as num).toInt()}',
            examSuperati: totalExamStats.numAdSuperate,
            examTotali: totalExamStats.totAdSuperate,
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              kBottomNavigationBarHeight +
                  MediaQuery.viewPaddingOf(context).bottom +
                  _careerListBottomSpacing,
            ),
            itemCount: allExamInfo.length,
            itemBuilder: (context, index) {
              final singleExam = allExamInfo[index];
              final isPassed = singleExam.status.esito == "S";
              final withHonors = singleExam.status.lode == 1;
              final voteExam = !isPassed
                  ? "??"
                  : singleExam.status.voto != null
                      ? singleExam.status.voto!.toInt().toString()
                      : "OK";
              final completedDate = singleExam.status.data != ""
                  ? singleExam.status.data!.toString().split(" ")[0]
                  : null;

              return _ModernCareerExamCard(
                titleExam: singleExam.nome.toString(),
                cfuExam: singleExam.cfu!.toInt().toString(),
                voteExam: voteExam,
                isPassed: isPassed,
                withHonors: withHonors,
                completedDate: completedDate,
              );
            },
          ),
        ),
      ],
    );
  }
}

enum CareerState { loading, empty, populated }

CareerState checkCareerState({
  required totalExamStats,
  required aritmeticAverageStats,
  required weightedAverageStats,
  required allExamInfo,
}) {
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

class _ModernCareerExamCard extends StatelessWidget {
  final String titleExam;
  final String cfuExam;
  final String voteExam;
  final bool isPassed;
  final bool withHonors;
  final String? completedDate;

  const _ModernCareerExamCard({
    required this.titleExam,
    required this.cfuExam,
    required this.voteExam,
    required this.isPassed,
    required this.withHonors,
    required this.completedDate,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isPassed ? AppColors.primaryColor : AppColors.lightGray;
    final accentColor = !isPassed
        ? AppColors.lightGray
        : withHonors
            ? AppColors.successColor
            : AppColors.detailsColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkColor.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      withHonors ? '30L' : voteExam,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleExam.split(' CFU').first,
                        style: const TextStyle(
                          color: AppColors.primaryDarkColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _CareerMetaChip(
                            icon: Icons.workspace_premium_outlined,
                            text: '$cfuExam CFU',
                          ),
                          _CareerMetaChip(
                            icon: isPassed
                                ? Icons.check_circle_outline_rounded
                                : Icons.hourglass_bottom_rounded,
                            text: !isPassed
                                ? AppLocalizations.of(context)
                                    .translate('exam_pending_state')
                                : withHonors
                                    ? AppLocalizations.of(context)
                                        .translate('exam_honors_state')
                                    : AppLocalizations.of(context)
                                        .translate('exam_passed_state'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (completedDate != null && completedDate!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: (isPassed
                          ? AppColors.successColor
                          : AppColors.primaryColor)
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${AppLocalizations.of(context).translate('completed')}: $completedDate',
                  style: TextStyle(
                    color:
                        isPassed ? AppColors.successColor : AppColors.primaryDarkColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CareerMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CareerMetaChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryDarkColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
