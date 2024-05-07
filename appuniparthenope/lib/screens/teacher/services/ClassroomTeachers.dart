import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../widget/bottomNavBarProf.dart';
import '../../../widget/navbar.dart';

class ClassroomTeacherPage extends StatefulWidget {
  const ClassroomTeacherPage({super.key});

  @override
  State<ClassroomTeacherPage> createState() => _ClassroomTeacherPageState();
}

class _ClassroomTeacherPageState extends State<ClassroomTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: const Center(
            child: Text(
          'Sei nella pagina delle classi',
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
