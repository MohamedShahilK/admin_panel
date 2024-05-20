import 'package:flutter/material.dart';

class SideMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // provider that will help to navigate the pages
  // String _myMenu = HomeDrawerMenuConstant.dashboard;
  String _myMenu = 'Dashboard';

  String _myMenuExpand = '';

  String get myMenu {
    return _myMenu;
  }

  String get myMenuExpand {
    return _myMenuExpand;
  }

  void setMyMenu(String myMenu) {
    _myMenu = myMenu;
    notifyListeners();
  }

  void setmyMenuExpand(String myMenu) {
    _myMenuExpand = myMenu;
    notifyListeners();
  }

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
