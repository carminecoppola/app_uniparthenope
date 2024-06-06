import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../model/studentService/reservation_data.dart';
import '../../../provider/exam_provider.dart';
import 'reservationListView.dart';
import 'searchBarReservation.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({
    super.key,
  });

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final reservations =
        Provider.of<ExamDataProvider>(context).allReservationInfo;

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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Aggiungi padding qui
                child: Column(
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
                    ReservationListWidget(
                      searchQuery: searchQuery,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
