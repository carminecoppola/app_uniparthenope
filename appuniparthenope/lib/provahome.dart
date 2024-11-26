import 'package:flutter/material.dart';
import 'app_localizations.dart';

class ProvaHome extends StatelessWidget {
  const ProvaHome({super.key});

  @override
  Widget build(BuildContext context) {
    const prova = "ciao ciao";
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)
            .translate('greeting')
            .replaceAll('{name}', 'Carmine $prova')),
      ),
    );
  }
}
