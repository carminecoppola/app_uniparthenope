import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class NavbarComponent extends StatelessWidget implements PreferredSizeWidget {
  const NavbarComponent({super.key});

  final String title = 'Università degli studi di Napoli Parthenope';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', width: 30, height: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
      leading: IconButton(
        color: Colors.white,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
