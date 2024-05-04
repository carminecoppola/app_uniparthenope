import 'package:appuniparthenope/controller/auth_controller.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/exam_controller.dart';
import '../model/user_data_login.dart';
import '../provider/auth_provider.dart';
import '../provider/exam_provider.dart';

class BottomNavBarComponent extends StatelessWidget {
  BottomNavBarComponent({super.key});

  final ExamController _totalExamController = ExamController();
  final AuthController _anagrafeController = AuthController();

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
            _averageStats(context, authenticatedUser.user);
            _allExamStudent(context, authenticatedUser.user);
            final bottomNavBarProvider =
                Provider.of<BottomNavBarProvider>(context, listen: false);
            bottomNavBarProvider.updateIndex(1);
            Navigator.pushNamed(context, '/carrerStudent');
            break;
          case 2:
            // Mostra il menu quando viene premuto l'elemento 2 del BottomNavigationBar
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.fromDirection(5.0),
                    ancestor: overlay),
                button.localToGlobal(button.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );
            showMenu(
              context: context,
              position: position,
              items: [
                PopupMenuItem(
                  child: const Text('Student Card'),
                  onTap: () {
                    _anagrafeStudent(context, authenticatedUser!.user);
                  },
                ),
                PopupMenuItem(
                  child: const Text('Carriera'),
                  onTap: () {
                    _totalExamStats(context, authenticatedUser!.user);
                    _averageStats(context, authenticatedUser.user);
                    _allExamStudent(context, authenticatedUser.user);
                    Navigator.pushNamed(context, '/carrerStudent');
                  },
                ),
              ],
            );
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

  void _anagrafeStudent(BuildContext context, User authenticatedUser) async {
    try {
      final anagrafeUser =
          await _anagrafeController.setAnagrafe(context, authenticatedUser);

      // Utilizza il provider per impostare l'anagrafica dell'utente
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAnagrafeUser(anagrafeUser);

      print(anagrafeUser);
      // Penso di settare in un altro provider i dati dell'utente in maniera globale
    } catch (e) {
      print('Error during _setAnagrafe: $e');
    }
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

  void _averageStats(BuildContext context, User? authenticatedUser) async {
    try {
      final aritmeticAverageStudent = await _totalExamController.averageStudent(
          context, authenticatedUser!, "A");

      final weightedAverageStudent = await _totalExamController.averageStudent(
          context, authenticatedUser, "P");

      // Utilizza il provider per impostare la media dello studente
      final examDataProvider =
          Provider.of<ExamDataProvider>(context, listen: false);
      examDataProvider.setTotalAverageExamStudent(
          aritmeticAverageStudent, weightedAverageStudent);
    } catch (e) {
      print('Errore during _averageStats() $e');
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
