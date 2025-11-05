import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  int _currentNavIndex = 0;

  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }
}
