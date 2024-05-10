import 'package:admin_panel/controllers/MenuController.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/account/account_page.dart';
import 'package:admin_panel/screens/actions/actions_page.dart';
import 'package:admin_panel/screens/actions/checkin/checkin_page.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/screens/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<SideMenuController>(context, listen: false);
    print('11111111111111111');
    return Scaffold(
      key: context.read<CustomMenuController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              final isDesktop = MediaQuery.of(context).size.width >= 1100;
              return Expanded(
                flex: isDesktop ? 1 : 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (Responsive.isDesktop(context)) {
                      return const SideMenu();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            }),
            Expanded(
              // flex: 5,
              flex: 7,
              child: Consumer<SideMenuController>(
                builder: (context, state, _) {
                  return pages(menu);
                },
              ),
              // child: CheckInScreen(),
            )
          ],
        ),
      ),
    );
  }

  Widget pages(SideMenuController menu) {
    if (menu.myMenu == 'Dashboard') {
      return const DashboardScreen();
    } else if (menu.myMenu == 'Check In') {
      return const CheckInScreen();
    } else if (menu.myMenu == 'Search' || menu.myMenu == 'Master Report' || menu.myMenu == 'Inventory Report' || menu.myMenu == 'Ticket' || menu.myMenu == 'Cash Collection') {
      return const SearchPage();
    } else if (menu.myMenu == 'Tickets') {
      return const ActionsPage();
    } else if (menu.myMenu == 'Account') {
      return const AccountPage();
    }
    return Container();
  }
}
