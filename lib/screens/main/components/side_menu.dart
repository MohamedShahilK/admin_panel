import 'package:admin_panel/constants.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<SideMenuController>(context);
    return Drawer(
      backgroundColor: sideMenuColor,
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/new_logo-removebg-preview.png", width: 250),
            ),
            DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/dashboard_new.svg",
              press: () {
                menu.setMyMenu('Dashboard');
              },
            ),
            DrawerListTile(
              title: "Check In",
              svgSrc: "assets/icons/checkin.svg",
              press: () {
                menu.setMyMenu('Check In');
              },
            ),
            DrawerListTile(
              title: "Check Out",
              svgSrc: "assets/icons/checkout.svg",
              press: () {
                menu.setMyMenu('Check Out');
              },
            ),
            DrawerListTile(
              title: "Master",
              svgSrc: "assets/icons/master.svg",
              press: () {
                menu.setMyMenu('Master');
              },
            ),
            DrawerListTile(
              title: "Report",
              svgSrc: "assets/icons/report.svg",
              press: () {
                menu.setMyMenu('Report');
              },
            ),
            DrawerListTile(
              title: "Reset Password",
              svgSrc: "assets/icons/reset_password.svg",
              press: () {
                menu.setMyMenu('Reset Password');
              },
            ),
            DrawerListTile(
              title: "LogOut",
              svgSrc: "assets/icons/logout.svg",
              press: () {
                menu.setMyMenu('LogOut');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePageNavigation(BuildContext context, String route) async {
    await Navigator.of(context).pushNamed(route);
  }
}

class DrawerListTile extends StatelessWidget {
  final String title, svgSrc;
  final VoidCallback press;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<SideMenuController>(context);
    final isSelected = menu.myMenu == title;
    return ColoredBox(
      color: isSelected ? Colors.white54 : Colors.transparent,
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 12.0,
        leading: SvgPicture.asset(
          svgSrc,
          // color: Colors.white54,
          colorFilter: ColorFilter.mode(isSelected ? primaryColor : Colors.black87, BlendMode.srcIn),
          height: 20,
        ),
        title: Text(
          title,
          style: TextStyle(color: isSelected ? primaryColor : Colors.black87, fontSize: 13),
        ),
      ),
    );
  }
}
