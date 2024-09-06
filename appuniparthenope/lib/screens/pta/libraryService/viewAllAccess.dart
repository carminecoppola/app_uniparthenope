import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

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
            const Text(
              'Accessi alla Biblioteca',
              style: TextStyle(
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
                  MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
              columns: const [
                DataColumn(
                    label: Text(
                  'Nome',
                  style: TextStyle(color: AppColors.primaryColor),
                )),
                DataColumn(
                    label: Text(
                  'Orario di Entrata',
                  style: TextStyle(color: AppColors.primaryColor),
                )),
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
