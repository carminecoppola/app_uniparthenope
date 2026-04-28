import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/widget/ServicesWidget/AppointmentsWidget/reservation_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/widget/custom_loading_indicator.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import '../../main.dart';
import '../../provider/exam_provider.dart';
import '../../provider/bottom_nav_bar_provider.dart';
import '../../widget/ServicesWidget/AppointmentsWidget/reservation_list_view.dart';
import '../../widget/ServicesWidget/AppointmentsWidget/search_bar_reservation.dart';
import '../../widget/bottom_nav_bar.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({
    super.key,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage>
    with SingleTickerProviderStateMixin {
  static const bool _useModernReservationUi = true;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nessun selettore attivo - pagina esterna alle 3 principali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<BottomNavBarProvider>(context, listen: false)
            .updateIndex(3); // Indice 3 = nessun selettore
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservations =
        Provider.of<ExamDataProvider>(context).allReservationInfo;

    final filteredReservations = reservations?.where((reservation) {
      final searchTextLower = searchQuery.toLowerCase();
      final courseNameLower = reservation.nomeAppello!.toLowerCase();
      return courseNameLower.contains(searchTextLower);
    }).toList();

    return Scaffold(
      extendBody: true,
      appBar: const NavbarComponent(),
      body: reservations == null
          ? Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CustomLoadingIndicator(
                  text: AppLocalizations.of(context)
                      .translate('loading_reservation'),
                  myColor: AppColors.primaryColor,
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_useModernReservationUi)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_note_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate('reservation'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 14),
                  SearchBarReservationWidget(
                    controller: searchController,
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (searchQuery.isNotEmpty && filteredReservations != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filteredReservations.length} ${AppLocalizations.of(context).translate('reservation_search_results')}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  ReservationTabBar(
                    tabController: _tabController,
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ReservationListWidget(
                          searchQuery: searchQuery,
                          filterType: FilterType.past,
                        ),
                        ReservationListWidget(
                          searchQuery: searchQuery,
                          filterType: FilterType.upcoming,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
