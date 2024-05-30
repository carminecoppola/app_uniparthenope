import 'package:flutter/material.dart';
import '../../main.dart';
import '../../widget/ServicesWidget/CourseWidget/professor/courseListView.dart';
import '../../widget/bottomNavBarProf.dart';
import '../../widget/navbar.dart';

class CoursesTeachersPage extends StatefulWidget {
  const CoursesTeachersPage({super.key});

  @override
  State<CoursesTeachersPage> createState() => _CoursesTeachersPageState();
}

class _CoursesTeachersPageState extends State<CoursesTeachersPage> {
  String selectedYear = '2023-2024';
  final List<String> academicYears = [
    '2023-2024',
    '2022-2023',
    '2021-2022',
    '2020-2021',
    '2019-2020',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 25),
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
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Anno Accademico',
                  labelStyle: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: selectedYear,
                icon: const Icon(Icons.arrow_downward,
                    color: AppColors.primaryColor),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: AppColors.primaryColor),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                },
                items:
                    academicYears.map<DropdownMenuItem<String>>((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: CourseListWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }
}
