import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/auth_provider.dart';
import '../widget/bottomNavBar.dart';
import '../widget/qrCode_widget.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final matricola = authenticatedUser?.user.trattiCarriera[0].matricola;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 350,
            height: 400,
            child: Card(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 15.0,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'QR-Code',
                      style: TextStyle(
                          fontSize: 25,
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    const Center(child: QRCodeWidget()),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        '${toCamelCase(authenticatedUser!.user.firstName)} ${toCamelCase(authenticatedUser.user.lastName)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Matricola: ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          children: [
                            TextSpan(
                              text: matricola,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.detailsColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }

  static String toCamelCase(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return '';
    }).join(' ');
  }
}
