import 'package:admin_panel/controllers/MenuController.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/checkin_page.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
            if (Responsive.isDesktop(context)) const Expanded(child: SideMenu()),
            Expanded(
              // flex: 5,
              flex: 7,
              // child: Consumer<SideMenuController>(
              //   builder: (context, state, _) {
              //     return pages(menu);
              //   },
              // ),
              child: CheckInScreen(),
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
    }
    return Container();
  }
}
