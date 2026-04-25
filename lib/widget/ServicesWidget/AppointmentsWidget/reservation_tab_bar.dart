import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class ReservationTabBar extends StatelessWidget {
  final TabController tabController;

  const ReservationTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
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
          gradient: AppColors.blueGradient,
          borderRadius: BorderRadius.circular(18),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 0,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primaryDarkColor,
        tabs: [
          Tab(
            text: AppLocalizations.of(context).translate('overdue'),
            icon: const Icon(Icons.history),
          ),
          Tab(
            text: AppLocalizations.of(context).translate('upcoming'),
            icon: const Icon(Icons.upcoming),
          ),
        ],
      ),
    );
  }
}
