import 'package:flutter/material.dart';
import '../../../widget/ServicesWidget/CourseWidget/professor/courseListView.dart';
import '../../../widget/bottomNavBarProf.dart';
import '../../../widget/navbar.dart';

class CoursesTeachersPage extends StatefulWidget {
  const CoursesTeachersPage({super.key});

  @override
  State<CoursesTeachersPage> createState() => _CoursesTeachersPageState();
}

class _CoursesTeachersPageState extends State<CoursesTeachersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: const Column(
          children: [
            Expanded(
              child: CourseListWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }
}
