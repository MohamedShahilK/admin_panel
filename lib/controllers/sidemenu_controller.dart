import 'package:flutter/material.dart';

class SideMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // provider that will help to navigate the pages
  // String _myMenu = HomeDrawerMenuConstant.dashboard;
  String _myMenu = 'Dashboard';

  String get myMenu {
    return _myMenu;
  }

  void setMyMenu(String myMenu) {
    _myMenu = myMenu;
    notifyListeners();
  }

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
