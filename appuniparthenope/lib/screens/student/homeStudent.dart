import 'package:appuniparthenope/screens/student/userInfoCard.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

class HomeStudentPage extends StatefulWidget {
  const HomeStudentPage({Key? key}) : super(key: key);

  @override
  _HomeStudentPageState createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends State<HomeStudentPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: UserInfoCard(
            name: 'John',
            surname: 'Doe',
            id: '0124002379',
            userImage: 'assets/user_profile.jpg',
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarComponent(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
