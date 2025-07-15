import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../provider/check_exam_provider.dart';
import '../../widget/ServicesWidget/CheckExamWidget/appello_card_list.dart';
import '../../widget/bottomNavBar.dart';
import '../../model/studentService/check_appello_data.dart';

class CheckAppelloPage extends StatelessWidget {
  const CheckAppelloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appelli =
        Provider.of<CheckDateExamProvider>(context).allAppelliStudent;
    print('CheckAppelloPage: ${appelli.length} reservations found.');

    final groupedAppelli = groupAppelliByNome(appelli);

    return Scaffold(
      appBar: const NavbarComponent(),
      body: appelli.isEmpty
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
                  child: AppelloGroupList(groupedAppelli: groupedAppelli),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavBarComponent(),
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
