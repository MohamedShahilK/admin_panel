import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) =>  DashboardScreen(),
  '/checkin': (_) =>  DashboardScreen(),
};

Route<dynamic>? generateRoutes(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '');
  switch (uri.path) {
    case '/':
      return MaterialPageRoute(builder: (context) =>  DashboardScreen());
    //   break;
    // default:
  }
  return null;
}
