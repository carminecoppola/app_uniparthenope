import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class DownloadCard extends StatelessWidget {
  const DownloadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String url = _getDownloadLink(context);
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: SizedBox(
        width: 350,
        height: 100,
        child: Card(
          color: AppColors.primaryColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/meteoUniLogo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).translate('download_weather'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDownloadLink(BuildContext context) {
    // Determina la piattaforma e restituisce il link corretto
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return 'https://apps.apple.com/it/app/meteo-uniparthenope/id1518001997';
    } else {
      return 'https://play.google.com/store/apps/details?id=it.uniparthenope.meteo&hl=it';
    }
  }
}
