import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class CustomTaxTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTaxTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(22),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        dividerColor: Colors.transparent,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.78),
        tabs: [
          Tab(
            text: AppLocalizations.of(context).translate('not_paid'),
            icon: const Icon(Icons.payment),
          ),
          Tab(
            text: AppLocalizations.of(context).translate('paid'),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
