import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/auth_provider.dart';
import '../widget/bottomNavBar.dart';
import '../widget/qrCode_widget.dart';

class QRCodePage extends StatelessWidget {
  final String? profileImage;

  const QRCodePage({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final user = authenticatedUser?.user.trattiCarriera[0];
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

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
                      'Personal Card',
                      style: TextStyle(
                          fontSize: 25,
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    const Center(child: QRCodeWidget()),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profileImage != null
                              ? Image.asset(profileImage!).image
                              : Image.asset(
                                  'assets/user_profile_default.jpg',
                                ).image,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.detailsColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${toCamelCase(authenticatedUser!.user.firstName)} ${toCamelCase(authenticatedUser.user.lastName)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.detailsColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text.rich(
                                TextSpan(
                                  text: 'Matricola: ',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: user!.matricola,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.detailsColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Cds: ',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: toCamelCase(user.cdsDes.toString()),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.detailsColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
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
