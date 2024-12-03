import 'package:flutter/material.dart';

class BottomNavBarProvider with ChangeNotifier {
  int _currentIndex = 1;
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;
  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
