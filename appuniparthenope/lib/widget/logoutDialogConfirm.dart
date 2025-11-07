import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../main.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.logout,
        size: 40,
      ),
      iconColor: Colors.red, // Icona rossa
      content: Text(AppLocalizations.of(context).translate('logout_message')),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.lightGray),
          ),
          child: Text(
            AppLocalizations.of(context).translate('no'),
            style: const TextStyle(color: AppColors.lightGray),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.logout(context);
            Navigator.pushNamed(
              context,
              '/loginPage',
              arguments: {
                'transition': true,
              },
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red), // Bordo rosso
          ),
          child: Text(
            AppLocalizations.of(context).translate('yes'),
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold), // Testo rosso
          ),
        ),
      ],
    );
  }
}
