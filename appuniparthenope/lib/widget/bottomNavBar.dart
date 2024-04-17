import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class BottomNavBarComponent extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBarComponent({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Funzione per gestire il tocco sui bottoni della barra di navigazione
  void _onNavBarItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Torna alla pagina precedente
        Navigator.of(context).pushNamed('/homeStudent');
        break;
      case 1:
        // Naviga alla pagina '/myCarrer'
        Navigator.of(context).pushNamed('/myCareer');
        break;
       case 2:
        //Apre il menu in overlay
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // Chiamata alla funzione di gestione del tocco
        _onNavBarItemTapped(context, index);
        // Inoltre, chiamare la funzione passata come parametro onTap se necessario
        onTap(index);
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
}
