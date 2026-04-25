import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../model/studentService/check_appello_data.dart';
import '../../provider/check_exam_provider.dart';
import '../../utilityFunctions/exam_utils_function.dart';
import '../../utilityFunctions/student_utils_function.dart';
import '../../widget/navbar.dart';
import '../../widget/bottom_nav_bar.dart';
import '../../widget/custom_loading_indicator.dart';
import '../../widget/compact_loading_dialog.dart';

/// 📋 Schermata Semplificata per Visualizzare gli Appelli Disponibili
///
/// Questa schermata mostra:
/// - Lista di appelli disponibili per lo studente
/// - Possibilità di prenotarsi a un appello
/// - Loading states e error handling
/// - Pull-to-refresh per aggiornare la lista
class ListaAppelliPage extends StatefulWidget {
  const ListaAppelliPage({super.key});

  @override
  State<ListaAppelliPage> createState() => _ListaAppelliPageState();
}

class _ListaAppelliPageState extends State<ListaAppelliPage> {
  late CheckDateExamProvider checkExamProvider;
  bool _isInitialized = false;
  final Set<String> _expandedExams = {};

  @override
  void initState() {
    super.initState();
    // Carica gli appelli al primo avvio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppelli();
    });
  }

  /// Carica gli appelli dall'API
  ///
  /// Recupera dati da AuthProvider e ExamProvider, quindi chiama il provider
  Future<void> _loadAppelli() async {
    if (_isInitialized) return;

    checkExamProvider =
        Provider.of<CheckDateExamProvider>(context, listen: false);

    final examSessionContext =
        await CheckExamUtils.resolveStudentExamSessionContext(context);
    if (!mounted) return;

    if (examSessionContext == null) {
      _showErrorSnapBar(
          AppLocalizations.of(context).translate('user_data_unavailable'));
      return;
    }

    await _loadAppelliWithCourseList(
      examSessionContext.user,
      examSessionContext.password,
      examSessionContext.cdsId,
      examSessionContext.courseList,
    );
  }

  /// Carica gli appelli con lista corsi disponibile
  Future<void> _loadAppelliWithCourseList(
    dynamic user,
    String password,
    int cdsId,
    dynamic courseList,
  ) async {
    try {
      await checkExamProvider.fetchAllAppelliStudent(
        userId: user.userId!,
        password: password,
        cdsId: cdsId,
        courseList: courseList,
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnapBar(
          '${AppLocalizations.of(context).translate('error_loading_exam_sessions')}: $e');
    }
  }

  /// Gestisce la prenotazione a un appello
  Future<void> _handlePrenotazione(CheckAppello appello) async {
    final examSessionContext =
        await CheckExamUtils.resolveStudentExamSessionContext(context);
    if (!mounted) return;

    if (examSessionContext == null) {
      _showErrorDialog(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('user_data_unavailable'),
      );
      return;
    }

    if (appello.adId == null || appello.appId == null) {
      _showErrorDialog(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('invalid_exam_data'),
      );
      return;
    }

    // Mostra dialog di conferma
    final conferma = await _showConfirmDialog(appello);
    if (conferma != true) return;

    // Mostra loading
    if (mounted) {
      showCompactLoadingDialog(
        context,
        message: AppLocalizations.of(context).translate('booking_exam_loading'),
      );
    }

    try {
      // Esegui la prenotazione
      final result = await checkExamProvider.bookExamAppello(
        userId: examSessionContext.user.userId!,
        password: examSessionContext.password,
        cdsId: examSessionContext.cdsId,
        adId: appello.adId!,
        appId: appello.appId!,
        dettaglioTratto: examSessionContext.dettaglioTratto,
        courseList: examSessionContext.courseList,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        // Ricarica le prenotazioni
        await StudentUtils.allReservationStudent(
            context, examSessionContext.user);
        if (!mounted) return;

        // Chiudi il loading solo dopo il refresh, per non mostrare la lista
        // mentre si aggiorna sotto al dialog.
        Navigator.of(context).pop();

        _showSuccessDialog(
          AppLocalizations.of(context).translate('success'),
          AppLocalizations.of(context).translate('booking_exam_success'),
        );
      } else {
        Navigator.of(context).pop();
        _showErrorDialog(
          AppLocalizations.of(context).translate('error'),
          result.errorMessage ??
              AppLocalizations.of(context).translate('booking_exam_error'),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Chiudi dialog loading
      Navigator.of(context).pop();
      _showErrorDialog(
        AppLocalizations.of(context).translate('error'),
        '${AppLocalizations.of(context).translate('unexpected_error')}: $e',
      );
    }
  }

  /// Mostra dialog di conferma prenotazione
  Future<bool?> _showConfirmDialog(CheckAppello appello) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.event_available_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('booking_exam_confirm_title'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (appello.esame != null)
                _ExamDetailChip(
                    icon: Icons.menu_book_rounded, text: appello.esame!),
              if (appello.dataEsame != null) ...[
                const SizedBox(height: 8),
                _ExamDetailChip(
                    icon: Icons.calendar_today_outlined,
                    text: appello.dataEsame!),
              ],
              if (appello.docenteCompleto != null) ...[
                const SizedBox(height: 8),
                _ExamDetailChip(
                    icon: Icons.person_outline_rounded,
                    text: appello.docenteCompleto!),
              ],
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)
                    .translate('booking_exam_confirm_message'),
                style: const TextStyle(
                  color: AppColors.primaryDarkColor,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDarkColor,
                        side: BorderSide(
                          color: AppColors.primaryColor.withValues(alpha: 0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      label: Text(
                        AppLocalizations.of(context).translate('confirm'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra dialog di successo
  void _showSuccessDialog(String title, String message) {
    _showFeedbackDialog(
      title: title,
      message: message,
      accentColor: AppColors.successColor,
      icon: Icons.check_circle_rounded,
    );
  }

  /// Mostra dialog di errore
  void _showErrorDialog(String title, String message) {
    _showFeedbackDialog(
      title: title,
      message: message,
      accentColor: AppColors.errorColor,
      icon: Icons.error_outline_rounded,
      scrollable: true,
    );
  }

  void _showFeedbackDialog({
    required String title,
    required String message,
    required Color accentColor,
    required IconData icon,
    bool scrollable = false,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkColor.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              scrollable
                  ? _ScrollableDialogMessage(message)
                  : Text(
                      message,
                      style: const TextStyle(
                        color: AppColors.primaryDarkColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(AppLocalizations.of(context).translate('ok')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra SnackBar di errore
  void _showErrorSnapBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkExamProvider = Provider.of<CheckDateExamProvider>(context);
    final appelli = checkExamProvider.allAppelliStudent;
    final groupedAppelli = checkExamProvider.groupedAppelliByExam;
    final isLoading = checkExamProvider.isLoading;
    final errorMessage = checkExamProvider.errorMessage;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: _buildBody(appelli, groupedAppelli, isLoading, errorMessage),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  /// Costruisce il body della schermata
  Widget _buildBody(
    List<CheckAppello> appelli,
    Map<String, List<CheckAppello>> groupedAppelli,
    bool isLoading,
    String? errorMessage,
  ) {
    final localizations = AppLocalizations.of(context);

    if (isLoading) {
      return Center(
        child: CustomLoadingIndicator(
          text: localizations.translate('loading_exams'),
          myColor: AppColors.primaryColor,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Errore: $errorMessage',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isInitialized = false;
                });
                _loadAppelli();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(
                AppLocalizations.of(context).translate('retry'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (appelli.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primaryColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.translate('no_exam_sessions_available'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.translate('no_exam_sessions_available_hint'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          _isInitialized = false;
        });
        return _loadAppelli();
      },
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          0,
          8,
          0,
          MediaQuery.paddingOf(context).bottom + 96,
        ),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Text(
              localizations.translate('exam_sessions_title'),
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              localizations.translate('exam_sessions_expand_hint'),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          ...groupedAppelli.entries
              .map((entry) => _buildExamSection(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildExamSection(String examName, List<CheckAppello> appelliEsame) {
    final isExpanded = _expandedExams.contains(examName);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isExpanded
              ? AppColors.primaryColor.withValues(alpha: 0.18)
              : AppColors.primaryColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkColor.withValues(
              alpha: isExpanded ? 0.12 : 0.06,
            ),
            blurRadius: isExpanded ? 18 : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.primaryColor.withValues(alpha: 0.08),
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.04),
        ),
        child: ExpansionTile(
          key: PageStorageKey<String>('appelli-$examName'),
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          iconColor: AppColors.primaryColor,
          collapsedIconColor: AppColors.primaryColor,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedExams.add(examName);
              } else {
                _expandedExams.remove(examName);
              }
            });
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: isExpanded ? AppColors.blueGradient : null,
                      color: isExpanded
                          ? null
                          : AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.menu_book_rounded,
                      color: isExpanded ? Colors.white : AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          examName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDarkColor,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${appelliEsame.length} ${AppLocalizations.of(context).translate('exam_session_count')}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: appelliEsame.map(_buildAppelloCard).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Costruisce la card di un singolo appello
  Widget _buildAppelloCard(CheckAppello appello) {
    final localizations = AppLocalizations.of(context);
    final statusText = (appello.statoDes ?? '').trim();
    final teacherText = (appello.docenteCompleto ?? '').trim();
    final noteText = (appello.note ?? '').trim();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showAppelloDetails(appello),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.blueGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.event_available_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appello.dataEsame ??
                              localizations.translate('not_available'),
                          style: const TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        if (teacherText.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            teacherText,
                            style: const TextStyle(
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              if (statusText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (noteText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('notes_label'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        noteText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handlePrenotazione(appello),
                  icon: const Icon(Icons.check_circle),
                  label: Text(
                    AppLocalizations.of(context).translate('book_exam_action'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  void _showAppelloDetails(CheckAppello appello) {
    final localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: AppColors.blueGradient,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appello.esame ??
                              localizations.translate('exam_sessions_title'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if ((appello.statoDes ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              appello.statoDes!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: localizations.translate('date'),
                    value: appello.dataEsame,
                  ),
                  _buildDetailRow(
                    icon: Icons.play_circle_outline,
                    label: localizations.translate('booking_window_start'),
                    value: appello.dataInizio,
                  ),
                  _buildDetailRow(
                    icon: Icons.stop_circle_outlined,
                    label: localizations.translate('booking_window_end'),
                    value: appello.dataFine,
                  ),
                  _buildDetailRow(
                    icon: Icons.groups_outlined,
                    label: localizations.translate('enrolled_count'),
                    value: appello.numIscritti?.toString(),
                  ),
                  _buildDetailRow(
                    icon: Icons.description_outlined,
                    label: localizations.translate('description_label'),
                    value: appello.descrizione,
                  ),
                  _buildDetailRow(
                    icon: Icons.notes_outlined,
                    label: localizations.translate('notes_label'),
                    value: appello.note,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _handlePrenotazione(appello);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                        localizations.translate('book_exam_action'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    String? value,
  }) {
    final displayValue = value == null || value.trim().isEmpty
        ? AppLocalizations.of(context).translate('not_available')
        : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayValue,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamDetailChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ExamDetailChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollableDialogMessage extends StatelessWidget {
  final String message;

  const _ScrollableDialogMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: SingleChildScrollView(
        child: Text(message),
      ),
    );
  }
}
