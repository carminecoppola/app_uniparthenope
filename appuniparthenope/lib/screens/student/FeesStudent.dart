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
    return const Scaffold(
      appBar: NavbarComponent(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Pagamenti Universitari',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          Divider(
            color: AppColors.primaryColor,
            thickness: 2.5,
            indent: 70,
            endIndent: 70,
          ),
          SizedBox(height: 10),
          // Elemento visivo per mostrare la situazione dello studente
          BannerWidget(),
          SizedBox(height: 16),
          // Componente FeesStudent
          Expanded(
            child: FeesStudent(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBarComponent(),
    );
  }
}
