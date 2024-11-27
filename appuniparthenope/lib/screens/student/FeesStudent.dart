import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import '../../widget/ServicesWidget/TaxWidget/bannerWidget.dart';
import '../../widget/ServicesWidget/TaxWidget/studentFeesList.dart';

class FeesUniStudentPage extends StatefulWidget {
  const FeesUniStudentPage({super.key});

  @override
  State<FeesUniStudentPage> createState() => _FeesUniStudentState();
}

class _FeesUniStudentState extends State<FeesUniStudentPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            toCamelCase(AppLocalizations.of(context).translate('fees_label')),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(
            color: AppColors.primaryColor,
            thickness: 2.5,
            indent: 70,
            endIndent: 70,
          ),
          const SizedBox(height: 10),
          // Elemento visivo per mostrare la situazione dello studente
          const BannerWidget(),
          const SizedBox(height: 16),
          // Componente FeesStudent
          const Expanded(
            child: FeesStudent(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
