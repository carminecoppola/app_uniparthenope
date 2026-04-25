import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../model/studentService/check_appello_data.dart';
import 'appello_card.dart';

class AppelloCardList extends StatelessWidget {
  final List<CheckAppello> appelli;
  final Function(CheckAppello)? onPrenota;

  const AppelloCardList({
    super.key,
    required this.appelli,
    this.onPrenota,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: appelli
          .map((a) => AppelloCard(
                appello: a,
                onPrenota: onPrenota != null ? () => onPrenota!(a) : null,
              ))
          .toList(),
    );
  }
}

class AppelloGroupList extends StatelessWidget {
  final Map<String, List<CheckAppello>> groupedAppelli;
  final Function(CheckAppello)? onPrenota;

  const AppelloGroupList({
    super.key,
    required this.groupedAppelli,
    this.onPrenota,
  });

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
          AppelloCardList(
            appelli: appelliEsame,
            onPrenota: onPrenota,
          ),
        ];
      }).toList(),
    );
  }
}
