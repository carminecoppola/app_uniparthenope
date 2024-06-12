import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../provider/professor_provider.dart';
import '../../widget/ServicesWidget/CourseWidget/professor/courseListView.dart';
import '../../widget/bottomNavBarProf.dart';
import '../../widget/navbar.dart';

class CoursesTeachersPage extends StatefulWidget {
  const CoursesTeachersPage({super.key});

  @override
  State<CoursesTeachersPage> createState() => _CoursesTeachersPageState();
}

class _CoursesTeachersPageState extends State<CoursesTeachersPage> {
  @override
  Widget build(BuildContext context) {
    final session =
        Provider.of<ProfessorDataProvider>(context, listen: false).profSession;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Corsi Assegnati',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Divider(
                color: AppColors.primaryColor,
                height: 10,
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
            ),
            const SizedBox(height: 10),
            if (session != null) ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      session.semDes.toString(),
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      session.aaCurr.toString(),
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Expanded(
              child: CourseListProfessorWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }
}
