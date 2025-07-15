import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../model/studentService/check_appello_data.dart';
import 'appello_card.dart';

class AppelloCardList extends StatelessWidget {
  final List<CheckAppello> appelli;

  const AppelloCardList({super.key, required this.appelli});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appelli.map((a) => AppelloCard(appello: a)).toList(),
    );
  }
}

class AppelloGroupList extends StatelessWidget {
  final Map<String, List<CheckAppello>> groupedAppelli;

  const AppelloGroupList({super.key, required this.groupedAppelli});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: groupedAppelli.entries.expand((entry) {
        final nomeEsame = entry.key;
        final appelliEsame = entry.value;
        return [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
            child: Text(
              nomeEsame,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          AppelloCardList(appelli: appelliEsame),
        ];
      }).toList(),
    );
  }
}
