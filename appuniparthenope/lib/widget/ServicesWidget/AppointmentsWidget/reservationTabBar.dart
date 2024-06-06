import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class ReservationTabBar extends StatelessWidget {
  final TabController tabController;

  const ReservationTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(
            text: 'Scadute',
            icon: Icon(Icons.history),
          ),
          Tab(
            text: 'Prossimamente',
            icon: Icon(Icons.upcoming),
          ),
        ],
      ),
    );
  }
}
