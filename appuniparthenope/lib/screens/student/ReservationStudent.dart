import 'package:appuniparthenope/widget/ServicesWidget/AppointmentsWidget/reservationTabBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import '../../main.dart';
import '../../provider/exam_provider.dart';
import '../../widget/ServicesWidget/AppointmentsWidget/reservationListView.dart';
import '../../widget/ServicesWidget/AppointmentsWidget/searchBarReservation.dart';
import '../../widget/bottomNavBar.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({
    super.key,
  });

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: const NavbarComponent(),
      body: reservations == null
          ? const Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CustomLoadingIndicator(
                  text: 'Caricamento prenotazioni in corso...',
                  myColor: AppColors.primaryColor,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Prenotazioni',
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
                  const SizedBox(height: 30),
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
                          'Trovate ${filteredReservations.length} corrispondenze',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ReservationTabBar(
                    tabController: _tabController,
                  ),
                  const SizedBox(height: 20),
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
