import 'package:flutter/material.dart';

import '../../../main.dart';
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
        child: const Center(
            child: Text(
          'Sei nella pagina dei corsi',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.primaryColor,
          ),
        )),
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }
}
