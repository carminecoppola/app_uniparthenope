import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../model/studentService/check_appello_data.dart';
import '../../provider/auth_provider.dart';
import '../../provider/check_exam_provider.dart';
import '../../provider/exam_provider.dart';
import '../../utilityFunctions/studentUtilsFunction.dart';
import '../../widget/navbar.dart';
import '../../widget/bottomNavBar.dart';
import '../../widget/CustomLoadingIndicator.dart';
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    checkExamProvider =
        Provider.of<CheckDateExamProvider>(context, listen: false);

    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;
    final courseList = examProvider.allCourseStudent;

    if (user == null || password == null || selectedCareer == null) {
      _showErrorSnapBar(
          AppLocalizations.of(context).translate('user_data_unavailable'));
      return;
    }

    if (courseList == null || courseList.isEmpty) {
      // Se i corsi non sono caricati, caricali prima
      try {
        await StudentUtils.allCourseStudent(context, user);
        final updatedCourseList = examProvider.allCourseStudent;
        if (updatedCourseList != null && updatedCourseList.isNotEmpty) {
          _loadAppelliWithCourseList(
            user,
            password,
            selectedCareer['cdsId'],
            updatedCourseList,
          );
        }
      } catch (e) {
        _showErrorSnapBar(
            '${AppLocalizations.of(context).translate('error_loading_courses')}: $e');
      }
      return;
    }

    _loadAppelliWithCourseList(
        user, password, selectedCareer['cdsId'], courseList);
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
      _showErrorSnapBar(
          '${AppLocalizations.of(context).translate('error_loading_exam_sessions')}: $e');
    }
  }

  /// Gestisce la prenotazione a un appello
  Future<void> _handlePrenotazione(CheckAppello appello) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);

    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;
    final courseList = examProvider.allCourseStudent;

    if (user == null || password == null || selectedCareer == null) {
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

    if (courseList == null || courseList.isEmpty) {
      _showErrorDialog(
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('course_list_unavailable'),
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
        userId: user.userId!,
        password: password,
        cdsId: selectedCareer['cdsId'],
        adId: appello.adId!,
        appId: appello.appId!,
        dettaglioTratto: selectedCareer['dettaglioTratto'],
        courseList: courseList,
      );

      if (result.isSuccess) {
        // Ricarica le prenotazioni
        if (mounted) {
          await StudentUtils.allReservationStudent(context, user);
        }

        // Chiudi il loading solo dopo il refresh, per non mostrare la lista
        // mentre si aggiorna sotto al dialog.
        if (mounted) Navigator.of(context).pop();

        if (mounted) {
          _showSuccessDialog(
            AppLocalizations.of(context).translate('success'),
            AppLocalizations.of(context).translate('booking_exam_success'),
          );
        }
      } else {
        if (mounted) Navigator.of(context).pop();

        if (mounted) {
          _showErrorDialog(
            AppLocalizations.of(context).translate('error'),
            result.errorMessage ??
                AppLocalizations.of(context).translate('booking_exam_error'),
          );
        }
      }
    } catch (e) {
      // Chiudi dialog loading
      if (mounted) Navigator.of(context).pop();
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          AppLocalizations.of(context).translate('booking_exam_confirm_title'),
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appello.esame != null)
              Text(
                  '${AppLocalizations.of(context).translate('exam_label')}: ${appello.esame}'),
            if (appello.dataEsame != null)
              Text(
                  '${AppLocalizations.of(context).translate('date')}: ${appello.dataEsame}'),
            if (appello.docenteCompleto != null)
              Text(
                  '${AppLocalizations.of(context).translate('teacher_label')}: ${appello.docenteCompleto}'),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)
                  .translate('booking_exam_confirm_message'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(
              AppLocalizations.of(context).translate('confirm'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog di successo
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.successColor),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).translate('ok')),
          ),
        ],
      ),
    );
  }

  /// Mostra dialog di errore
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.errorColor),
        ),
        content: _ScrollableDialogMessage(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).translate('ok')),
          ),
        ],
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
              child: const Text(
                'Riprova',
                style: TextStyle(color: Colors.white),
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
              'Nessun appello disponibile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Non ci sono appelli prenotabili al momento',
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
        padding: const EdgeInsets.symmetric(vertical: 8),
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.primaryColor.withOpacity(0.08),
          highlightColor: AppColors.primaryColor.withOpacity(0.04),
        ),
        child: ExpansionTile(
          key: PageStorageKey<String>('appelli-$examName'),
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.only(bottom: 8),
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
              Text(
                examName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${appelliEsame.length} appelli',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAppelloDetails(appello),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data esame
              if (appello.dataEsame != null)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appello.dataEsame!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              // Docente
              if (appello.docenteCompleto != null &&
                  appello.docenteCompleto!.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appello.docenteCompleto!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              // Stato
              if (appello.statoDes != null && appello.statoDes!.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          appello.statoDes!,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Note
              if (appello.note != null && appello.note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note:',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appello.note!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

              // Bottone Prenota
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handlePrenotazione(appello),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Prenota Appello'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                Text(
                  appello.esame ?? 'Dettaglio appello',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Data esame',
                  value: appello.dataEsame,
                ),
                _buildDetailRow(
                  icon: Icons.play_circle_outline,
                  label: 'Apertura prenotazioni',
                  value: appello.dataInizio,
                ),
                _buildDetailRow(
                  icon: Icons.stop_circle_outlined,
                  label: 'Chiusura prenotazioni',
                  value: appello.dataFine,
                ),
                _buildDetailRow(
                  icon: Icons.groups_outlined,
                  label: 'Iscritti',
                  value: appello.numIscritti?.toString(),
                ),
                _buildDetailRow(
                  icon: Icons.description_outlined,
                  label: 'Descrizione',
                  value: appello.descrizione,
                ),
                _buildDetailRow(
                  icon: Icons.notes_outlined,
                  label: 'Note',
                  value: appello.note,
                ),
              ],
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
    final displayValue =
        value == null || value.trim().isEmpty ? 'Non disponibile' : value;

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
