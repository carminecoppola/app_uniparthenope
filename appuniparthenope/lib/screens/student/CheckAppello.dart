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
import '../../widget/ServicesWidget/CheckExamWidget/appello_search_bar.dart';
import '../../widget/bottomNavBar.dart';
import '../../widget/CustomLoadingIndicator.dart';
import '../../widget/compact_loading_dialog.dart';
import '../../model/studentService/check_appello_data.dart';

class CheckAppelloPage extends StatefulWidget {
  const CheckAppelloPage({super.key});

  @override
  State<CheckAppelloPage> createState() => _CheckAppelloPageState();
}

class _CheckAppelloPageState extends State<CheckAppelloPage> {
  String searchQuery = '';
  bool showOnlyOpen = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CheckAppello> _filterAppelli(List<CheckAppello> appelli) {
    var filtered = appelli;

    if (showOnlyOpen) {
      filtered = filtered.where((appello) => appello.stato == 'P').toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((appello) =>
              appello.esame!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Map<String, List<CheckAppello>> _getGroupedAndFiltered(
      List<CheckAppello> appelli) {
    final filteredAppelli = _filterAppelli(appelli);
    final grouped = groupAppelliByNome(filteredAppelli);
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
    return Map.fromEntries(sortedEntries);
  }

  @override
  Widget build(BuildContext context) {
    final checkExamProvider = Provider.of<CheckDateExamProvider>(context);
    final appelli = checkExamProvider.allAppelliStudent;
    final groupedAppelli = _getGroupedAndFiltered(appelli);

    return Scaffold(
      appBar: const NavbarComponent(),
      body: checkExamProvider.isLoading
          ? CustomLoadingIndicator(
              text: AppLocalizations.of(context).translate('loading_exams'),
              myColor: AppColors.primaryColor,
            )
          : appelli.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nessun appello disponibile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ritorna più tardi per controllare gli appelli disponibili.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : _buildEsameList(groupedAppelli),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  Widget _buildEsameList(Map<String, List<CheckAppello>> groupedAppelli) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Center(
          child: Text(
            "Lista Appelli",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppelloSearchBar(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          onClear: () {
            _searchController.clear();
            setState(() {
              searchQuery = '';
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mostra solo aperti',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              Switch(
                value: showOnlyOpen,
                onChanged: (value) {
                  setState(() {
                    showOnlyOpen = value;
                  });
                },
                activeThumbColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (groupedAppelli.isEmpty && searchQuery.isNotEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nessun esame trovato per "$searchQuery"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else if (groupedAppelli.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 48,
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    showOnlyOpen
                        ? 'Nessun appello aperto disponibile'
                        : 'Nessun appello disponibile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: AppelloGroupList(
              groupedAppelli: groupedAppelli,
              onPrenota: (appello) => _handlePrenotazione(context, appello),
            ),
          ),
      ],
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
        AppLocalizations.of(context).translate('user_data_unavailable'),
      );
      return;
    }

    if (appello.adId == null || appello.appId == null) {
      _showErrorDialog(
        context,
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('invalid_exam_data'),
      );
      return;
    }

    if (courseList == null || courseList.isEmpty) {
      _showErrorDialog(
        context,
        AppLocalizations.of(context).translate('error'),
        AppLocalizations.of(context).translate('course_list_unavailable'),
      );
      return;
    }

    // Mostra dialog di conferma
    final conferma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('booking_exam_confirm_title'),
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        content: Text(
          '${AppLocalizations.of(context).translate('booking_exam_confirm_details')}\n\n'
          '${appello.esame}\n'
          '${AppLocalizations.of(context).translate('date')}: ${appello.dataEsame}',
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

    if (conferma != true) return;
    if (!context.mounted) return;

    // Mostra loading
    showCompactLoadingDialog(
      context,
      message: AppLocalizations.of(context).translate('booking_exam_loading'),
    );

    // Usa direttamente il provider invece del controller
    final result = await checkExamProvider.bookExamAppello(
      userId: user.userId!,
      password: password,
      cdsId: selectedCareer['cdsId'],
      adId: appello.adId!,
      appId: appello.appId!,
      dettaglioTratto: selectedCareer[
          'dettaglioTratto'], // Passa tutti i dati della carriera
      courseList: courseList,
    );

    if (result.isSuccess) {
      // Ricarica le prenotazioni
      if (context.mounted) {
        await StudentUtils.allReservationStudent(context, user);
      }

      // Chiudi il loading solo dopo il refresh, per non mostrare la lista
      // mentre si aggiorna sotto al dialog.
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        _showSuccessDialog(
          context,
          AppLocalizations.of(context).translate('success'),
          AppLocalizations.of(context).translate('booking_exam_success'),
        );
      }
    } else {
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        _showErrorDialog(
          context,
          AppLocalizations.of(context).translate('error'),
          result.errorMessage ??
              AppLocalizations.of(context).translate('booking_exam_error'),
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(color: AppColors.errorColor)),
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

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title:
            Text(title, style: const TextStyle(color: AppColors.successColor)),
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

// Utility fuori dalla classe
Map<String, List<CheckAppello>> groupAppelliByNome(List<CheckAppello> appelli) {
  final Map<String, List<CheckAppello>> grouped = {};
  for (final appello in appelli) {
    final nome = (appello.esame ?? 'Esame').trim();
    if (!grouped.containsKey(nome)) {
      grouped[nome] = [];
    }
    grouped[nome]!.add(appello);
  }
  return grouped;
}
