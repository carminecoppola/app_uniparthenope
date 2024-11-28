import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import '../../widget/GuestWidget/contactWidget.dart';
import '../../widget/GuestWidget/universitySliderWidget.dart';

class HomeGuestPage extends StatefulWidget {
  const HomeGuestPage({super.key});

  @override
  _HomeGuestPageState createState() => _HomeGuestPageState();
}

class _HomeGuestPageState extends State<HomeGuestPage> {
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(role: 'Guest'),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showDescription = !showDescription;
                        });
                      },
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (showDescription)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('our_history_label'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (showDescription)
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: AppLocalizations.of(context)
                              .translate('our_history'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.lightGray,
                          ),
                        ),
                      ),
                    if (!showDescription)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDescription = !showDescription;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('who_are'),
                          style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              color: AppColors.primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('our_uni_label'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context).translate('our_uni'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGray,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const UniversitySliderWidget(),
                  ],
                ),
              ),
              const ContactSection(),
            ],
          ),
        ),
      ),
    );
  }
}
