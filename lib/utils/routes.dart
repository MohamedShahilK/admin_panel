import 'package:admin_panel/screens/account/account_page.dart';
import 'package:admin_panel/screens/actions/actions_page.dart';
import 'package:admin_panel/screens/actions/checkin/checkin_page.dart';
import 'package:admin_panel/screens/actions/checkout/checkout_page.dart';
import 'package:admin_panel/screens/actions/payment/payment_page.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/screens/search/search_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext context)> routes = {
  // '/': (_) => DashboardScreen(),
  // '/checkin': (_) => DashboardScreen(),
};

Route<dynamic>? generateRoutes(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '');
  switch (uri.path) {
    case '/':
      return MaterialPageRoute(builder: (_) => const DashboardScreen());
    //   break;
    // default:

    case '/tickets':
      return MaterialPageRoute(builder: (_) => const ActionsPage());

    case '/parked':
      return MaterialPageRoute(builder: (_) => const CheckInScreen());

    case '/checkout':
      return MaterialPageRoute(builder: (_) => const CheckOutPage());

    case '/payment':
      return MaterialPageRoute(builder: (_) => const PaymentPage());

    case '/search':
      return MaterialPageRoute(builder: (_) => const SearchPage());

    case '/masterreport':
      return MaterialPageRoute(builder: (_) => const SearchPage());

    case '/inventoryreport':
      return MaterialPageRoute(builder: (_) => const SearchPage());

    case '/ticketreport':
      return MaterialPageRoute(builder: (_) => const SearchPage());

    case '/cashcollection':
      return MaterialPageRoute(builder: (_) => const SearchPage());

    case '/account':
      return MaterialPageRoute(builder: (_) => const AccountPage());
  }
  return null;
}
