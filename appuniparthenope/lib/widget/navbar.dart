import 'package:appuniparthenope/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/main.dart';

import '../screens/loginpage.dart';
import '../screens/pta/homePTA.dart';

class NavbarComponent extends StatelessWidget implements PreferredSizeWidget {
  const NavbarComponent({
    super.key,
    this.role,
    this.showBackButton = true,
  });

  final String title = 'Università degli studi di Napoli Parthenope';
  final String? role;
  final bool showBackButton;

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
          Image.asset('assets/logoWhite.png', width: 30, height: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
      leading: showBackButton
          ? IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Controlla il valore di role e naviga di conseguenza
                if (role == 'PTA') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PTAHomePage(),
                    ),
                  );
                } else if (role == 'Guest') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginForm(),
                    ),
                  );
                } else {
                  // Default: Vai alla HomePage
                  final bottomNavBarProvider =
                      Provider.of<BottomNavBarProvider>(context, listen: false);
                  bottomNavBarProvider.updateIndex(0);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const HomePage(),
                      transitionsBuilder:
                          (context, animation1, animation2, child) {
                        const begin = Offset(-1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation1.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
            )
          : null, // Se showBackButton è false, non mostrare l'IconButton
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
