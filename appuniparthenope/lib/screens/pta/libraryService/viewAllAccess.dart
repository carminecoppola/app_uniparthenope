import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

import '../../../app_localizations.dart';

class AccessLogsTable extends StatelessWidget {
  const AccessLogsTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulazione di dati di accesso
    List<Map<String, dynamic>> accessLogs = [
      {'name': 'Mario Rossi', 'entryTime': '10:00'},
      {'name': 'Luigi Verdi', 'entryTime': '09:30'},
    ];

    return Scaffold(
      appBar: const NavbarComponent(
        role: 'PTA',
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context).translate('access_logs_title'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            DataTable(
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              dataRowColor:
                  WidgetStateColor.resolveWith((states) => Colors.grey[200]!),
              columns: [
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate('name_column'),
                    style: const TextStyle(color: AppColors.primaryColor),
                  ),
                ),
                DataColumn(
                  label: Text(
                    AppLocalizations.of(context).translate('entry_time_column'),
                    style: const TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
              rows: accessLogs
                  .map(
                    (log) => DataRow(
                      cells: [
                        DataCell(
                          Center(child: Text(log['name'])),
                        ),
                        DataCell(
                          Center(child: Text(log['entryTime'])),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
