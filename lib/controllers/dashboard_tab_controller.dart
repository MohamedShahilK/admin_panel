
import 'package:flutter/material.dart';

class DashBoardTabController extends ChangeNotifier {
  String _menuName = 'Current Inventory';
  String get menuName => _menuName;

  void setMenuName(String menuName) {
    _menuName = menuName;
    notifyListeners();
    //print(_menuName);
  }
}
