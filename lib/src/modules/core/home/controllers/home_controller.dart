import 'package:flutter/material.dart';

class HomeController extends ValueNotifier<int> {
  HomeController() : super(0);

  void updateTabIndex(int index) {
    value = index; 
  }
}

