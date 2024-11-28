import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/LibraryWidget/libraryCard.dart';
import 'package:flutter/material.dart';
import '../../widget/navbar.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(role: 'PTA'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/logo.png',
                      height: 80,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).translate('library'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LibraryCard(
                imagePath: 'assets/addUser.jpg',
                title: AppLocalizations.of(context)
                    .translate('library_registration_title'),
                subtitle: AppLocalizations.of(context)
                    .translate('library_registration_subtitle'),
                imageSize: 100,
                onTap: () {
                  Navigator.pushNamed(context, '/registrationLibrary');
                },
              ),
              const SizedBox(height: 16),
              LibraryCard(
                imagePath: 'assets/scanCode.jpg',
                title: AppLocalizations.of(context)
                    .translate('library_daily_entries_title'),
                subtitle: AppLocalizations.of(context)
                    .translate('library_daily_entries_subtitle'),
                imageSize: 200,
                onTap: () {
                  Navigator.pushNamed(context, '/viewAllAccessLibrary');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
