import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';

class CustomCareerSelectionDialog extends StatelessWidget {
  final List<Map<String, dynamic>> careers;

  const CustomCareerSelectionDialog({super.key, required this.careers});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Aggiungi il logo nella parte superiore
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset(
              'assets/logo.png',
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              AppLocalizations.of(context).translate('select_career'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: careers.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ListTile(
                    title: Text(
                      _toCamelCase(careers[index]['cdsDes']),
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5.0),
                        RichText(
                          text: TextSpan(
                            text:
                                '\t\t${AppLocalizations.of(context).translate('studentid')}: ',
                            style: const TextStyle(color: AppColors.lightGray),
                            children: <TextSpan>[
                              TextSpan(
                                text: careers[index]['matricola'].toString(),
                                style: const TextStyle(
                                  color: AppColors.detailsColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                '\t\t${AppLocalizations.of(context).translate('studentid')}: ',
                            style: const TextStyle(color: AppColors.lightGray),
                            children: <TextSpan>[
                              TextSpan(
                                text: careers[index]['staStuDes'].toString(),
                                style: TextStyle(
                                  color: careers[index]['staStuDes'] == 'Attivo'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pop(careers[index]['cdsId'].toString());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _toCamelCase(String text) {
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).join(' ');
  }
}
