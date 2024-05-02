import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/exam_controller.dart';
import '../model/user_data_login.dart';
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';

class BottomNavBarComponent extends StatelessWidget {
  BottomNavBarComponent({super.key});

  final ExamController _totalExamController = ExamController();

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavBarProvider>(context);
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentIndex,
      onTap: (index) {
        navigationProvider.updateIndex(index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/homeStudent');
            break;
          case 1:
            _totalExamStats(context, authenticatedUser!.user);
            _allExamStudent(context, authenticatedUser.user);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(1);
            Navigator.pushNamed(context, '/carrerStudent');
            break;
          case 2:
            break;
        }
      },
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.lightGray,
      selectedLabelStyle: const TextStyle(color: Colors.white),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Carriera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }

  void _totalExamStats(BuildContext context, User? authenticatedUser) async {
    try {
      final totalExamStudent = await _totalExamController.totalExamStatsStudent(
          authenticatedUser!, context);

      // Utilizza il provider per impostare l'anagrafica dell'utente
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalStatsExamStudent(totalExamStudent);
    } catch (e) {
      print('Errore during _totalExamStats() $e');
    }
  }

  void _allExamStudent(BuildContext context, User? authenticatedUser) async {
    try {
      final allExamStudent = await _totalExamController.fetchAllExamStudent(
          authenticatedUser!, context);

      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setAllExamStudent(allExamStudent);
    } catch (e) {
      print('Errore during _allExamStudent() $e');
    }
  }
}
