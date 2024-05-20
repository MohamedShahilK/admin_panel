import 'package:admin_panel/screens/account/account_page.dart';
import 'package:admin_panel/screens/actions/actions_page.dart';
import 'package:admin_panel/screens/actions/checkin/checkin_page.dart';
import 'package:admin_panel/screens/actions/checkout/checkout_page.dart';
import 'package:admin_panel/screens/actions/payment/payment_page.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/screens/report/cash_collection_report.dart';
import 'package:admin_panel/screens/report/inventory_report.dart';
import 'package:admin_panel/screens/report/master_report.dart';
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
      // return MaterialPageRoute(builder: (_) => const DashboardScreen());
      return _customPageAnimation(page: const CashCollectionReport());
    //   break;
    // default:

    case '/tickets':
      return _customPageAnimation(page: const ActionsPage());

    case '/parked':
      // return MaterialPageRoute(builder: (_) => const CheckInScreen());
      return _customPageAnimation(page: const CheckInScreen());

    case '/checkout':
      // return MaterialPageRoute(builder: (_) => const CheckOutPage());
      return _customPageAnimation(page: const CheckOutPage());

    case '/payment':
      // return MaterialPageRoute(builder: (_) => const PaymentPage());
      return _customPageAnimation(page: const PaymentPage());

    case '/search':
      // return MaterialPageRoute(builder: (_) => const SearchPage());
      return _customPageAnimation(page: const SearchPage());

    case '/masterreport':
      // return MaterialPageRoute(builder: (_) => const SearchPage());
      return _customPageAnimation(page: const MasterReportPage());

    case '/inventoryreport':
      // return MaterialPageRoute(builder: (_) => const SearchPage());
      return _customPageAnimation(page: const InventoryReport());

    case '/ticketreport':
      // return MaterialPageRoute(builder: (_) => const SearchPage());
      return _customPageAnimation(page: const SearchPage());

    case '/cashcollection':
      // return MaterialPageRoute(builder: (_) => const SearchPage());
      return _customPageAnimation(page: const CashCollectionReport());

    case '/account':
      // return MaterialPageRoute(builder: (_) => const AccountPage());
      return _customPageAnimation(page: const AccountPage());
  }
  return null;
}

PageRouteBuilder<dynamic> _customPageAnimation({required Widget page}) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
