import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class CustomTaxTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTaxTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryColor, // Indicator color
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        indicatorSize: TabBarIndicatorSize.tab, // Indicator size
        indicatorWeight: 3.0, // Indicator thickness
        labelColor: Colors.white, // Selected text color
        unselectedLabelColor: Colors.grey, // Unselected text color
        tabs: const [
          Tab(
            text: 'Da pagare',
            icon: Icon(Icons.payment), // Dollar sign icon
          ),
          Tab(
            text: 'Pagate',
            icon: Icon(Icons.check), // Checkmark icon
          ),
        ],
      ),
    );
  }
}
