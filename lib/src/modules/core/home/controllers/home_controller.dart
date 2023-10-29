import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateTabIndex(int index) {
    _currentIndex = index;
    notifyListeners(); 
  }
}
