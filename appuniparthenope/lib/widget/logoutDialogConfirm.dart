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
      iconColor: AppColors.detailsColor,
      content: const Text('Sei sicuro di voler effettuare il logout?'),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.lightGray),
          ),
          child: const Text(
            'No',
            style: TextStyle(color: AppColors.lightGray),
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
            side: const BorderSide(color: AppColors.detailsColor),
          ),
          child: const Text(
            'Si',
            style: TextStyle(
                color: AppColors.detailsColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
