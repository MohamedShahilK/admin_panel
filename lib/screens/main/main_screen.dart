import 'package:admin_panel/controllers/MenuController.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/checkin_page.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:html' as html;

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
            Builder(
              builder: (context) {
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
              }
            ),
            const Expanded(
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
