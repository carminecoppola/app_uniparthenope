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
      _showErrorSnapBar('Dati utente non disponibili');
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
        _showErrorSnapBar('Errore nel caricamento dei corsi: $e');
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
      _showErrorSnapBar('Errore nel caricamento degli appelli: $e');
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
        'Errore',
        'Dati utente non disponibili',
      );
      return;
    }

    if (appello.adId == null || appello.appId == null) {
      _showErrorDialog(
        'Errore',
        'Dati dell\'appello non validi',
      );
      return;
    }

    if (courseList == null || courseList.isEmpty) {
      _showErrorDialog(
        'Errore',
        'Lista corsi non disponibile',
      );
      return;
    }

    // Mostra dialog di conferma
    final conferma = await _showConfirmDialog(appello);
    if (conferma != true) return;

    // Mostra loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
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

      // Chiudi dialog loading
      if (mounted) Navigator.of(context).pop();

      if (result.isSuccess) {
        // Ricarica le prenotazioni
        if (mounted) {
          await StudentUtils.allReservationStudent(context, user);
        }

        if (mounted) {
          _showSuccessDialog(
            'Successo',
            'Prenotazione effettuata con successo!',
          );
        }
      } else {
        if (mounted) {
          _showErrorDialog(
            'Errore',
            result.errorMessage ?? 'Impossibile completare la prenotazione',
          );
        }
      }
    } catch (e) {
      // Chiudi dialog loading
      if (mounted) Navigator.of(context).pop();
      _showErrorDialog(
        'Errore',
        'Errore imprevisto: $e',
      );
    }
  }

  /// Mostra dialog di conferma prenotazione
  Future<bool?> _showConfirmDialog(CheckAppello appello) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Conferma Prenotazione',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appello.esame != null) Text('Esame: ${appello.esame}'),
            if (appello.dataEsame != null) Text('Data: ${appello.dataEsame}'),
            if (appello.docenteCompleto != null)
              Text('Docente: ${appello.docenteCompleto}'),
            const SizedBox(height: 12),
            Text(
              'Vuoi prenotare questo appello?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'Conferma',
              style: TextStyle(color: Colors.white),
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
        title: Text(
          title,
          style: const TextStyle(color: AppColors.successColor),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
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
        title: Text(
          title,
          style: const TextStyle(color: AppColors.errorColor),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
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
    final isLoading = checkExamProvider.isLoading;
    final errorMessage = checkExamProvider.errorMessage;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: _buildBody(appelli, isLoading, errorMessage),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  /// Costruisce il body della schermata
  Widget _buildBody(
      List<CheckAppello> appelli, bool isLoading, String? errorMessage) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: appelli.length,
        itemBuilder: (context, index) {
          final appello = appelli[index];
          return _buildAppelloCard(appello);
        },
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome esame
            if (appello.esame != null)
              Text(
                appello.esame!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
              ),
            const SizedBox(height: 12),

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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appello.statoDes!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
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
    );
  }
}
