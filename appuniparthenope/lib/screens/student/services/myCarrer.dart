import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/provider/exam_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/TotalExamStudentCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentCarrerPage extends StatefulWidget {
  const StudentCarrerPage({super.key});

  @override
  State<StudentCarrerPage> createState() => _StudentCarrerPageState();
}

class _StudentCarrerPageState extends State<StudentCarrerPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<BottomNavBarProvider>(context);
    final totalExamInfo =
        Provider.of<ExamDataProvider>(context).totalExamStudent;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (totalExamInfo != null)
            Center(
              child: TotalExamStudentCard(
                cfuPar: '${totalExamInfo.cfuPar}',
                cfuTot: '${totalExamInfo.cfuTot}',
              ),
            )
          else
            // Gestione del caso in cui totalExamInfo è null
            const Center(
              child:
                  CircularProgressIndicator(), // Puoi sostituire questo con qualsiasi indicatore di caricamento desiderato
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarComponent(),
    );
  }
}
