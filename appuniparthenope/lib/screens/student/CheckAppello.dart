import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../main.dart';
import '../../provider/auth_provider.dart';
import '../../provider/check_exam_provider.dart';
import '../../provider/exam_provider.dart';
import '../../utilityFunctions/studentUtilsFunction.dart';
import '../../widget/ServicesWidget/CheckExamWidget/appello_card_list.dart';
import '../../widget/bottomNavBar.dart';
import '../../model/studentService/check_appello_data.dart';

class CheckAppelloPage extends StatelessWidget {
  const CheckAppelloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkExamProvider = Provider.of<CheckDateExamProvider>(context);
    final appelli = checkExamProvider.allAppelliStudent;

    final groupedAppelli = groupAppelliByNome(appelli);

    return Scaffold(
      appBar: const NavbarComponent(),
      body: checkExamProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : appelli.isEmpty
              ? const Center(child: Text('Nessun appello disponibile.'))
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Appelli disponibili",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const Divider(
                      color: AppColors.primaryColor,
                      indent: 100,
                      endIndent: 100,
                      thickness: 2,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: AppelloGroupList(
                        groupedAppelli: groupedAppelli,
                        onPrenota: (appello) =>
                            _handlePrenotazione(context, appello),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  Future<void> _handlePrenotazione(
      BuildContext context, CheckAppello appello) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final examProvider = Provider.of<ExamDataProvider>(context, listen: false);
    final checkExamProvider =
        Provider.of<CheckDateExamProvider>(context, listen: false);

    final user = authProvider.authenticatedUser?.user;
    final password = authProvider.password;
    final selectedCareer = authProvider.selectedCareer;
    final courseList = examProvider.allCourseStudent;

    if (user == null || password == null || selectedCareer == null) {
      _showErrorDialog(
        context,
        AppLocalizations.of(context).translate('error'),
        'Dati utente non disponibili',
      );
      return;
    }

    if (appello.adId == null || appello.appId == null) {
      _showErrorDialog(
        context,
        AppLocalizations.of(context).translate('error'),
        'Dati dell\'appello non validi',
      );
      return;
    }

    if (courseList == null || courseList.isEmpty) {
      _showErrorDialog(
        context,
        AppLocalizations.of(context).translate('error'),
        'Lista corsi non disponibile',
      );
      return;
    }

    // Mostra dialog di conferma
    final conferma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Conferma Prenotazione',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: Text(
          'Vuoi prenotare l\'appello per:\n\n${appello.esame}\nData: ${appello.dataEsame}',
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

    if (conferma != true) return;

    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Usa direttamente il provider invece del controller
    final result = await checkExamProvider.bookExamAppello(
      userId: user.userId!,
      password: password,
      cdsId: selectedCareer['cdsId'],
      adId: appello.adId!,
      appId: appello.appId!,
      courseList: courseList,
    );

    // Chiudi loading
    if (context.mounted) Navigator.of(context).pop();

    if (result.isSuccess) {
      // Ricarica le prenotazioni
      if (context.mounted) {
        await StudentUtils.allReservationStudent(context, user);
      }

      if (context.mounted) {
        _showSuccessDialog(
          context,
          AppLocalizations.of(context).translate('success'),
          'Prenotazione effettuata con successo!',
        );
      }
    } else {
      if (context.mounted) {
        _showErrorDialog(
          context,
          AppLocalizations.of(context).translate('error'),
          result.errorMessage ?? 'Impossibile completare la prenotazione',
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: AppColors.errorColor)),
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

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(title, style: const TextStyle(color: AppColors.successColor)),
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
}

// Utility fuori dalla classe
Map<String, List<CheckAppello>> groupAppelliByNome(List<CheckAppello> appelli) {
  final Map<String, List<CheckAppello>> grouped = {};
  for (final appello in appelli) {
    final nome = (appello.esame ?? 'ESAME').toUpperCase();
    if (!grouped.containsKey(nome)) {
      grouped[nome] = [];
    }
    grouped[nome]!.add(appello);
  }
  return grouped;
}
