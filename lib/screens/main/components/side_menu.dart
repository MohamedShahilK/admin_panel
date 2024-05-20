import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<SideMenuController>(context, listen: false);
    return SizedBox(
      // width: 100,
      child: Drawer(
        backgroundColor: sideMenuColor,
        child: SingleChildScrollView(
          // it enables scrolling
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                // child: Image.asset("assets/images/new_logo-removebg-preview.png", width: 250),
                child: Image.asset(
                  "assets/images/new_logo-removebg-preview.png",
                  width: 200,
                  height: 50,
                  // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  //   if (!wasSynchronouslyLoaded) {
                  //     return child;
                  //   }
                  //   return CircularProgressIndicator();
                  // },
                ),
              ),
              DrawerListTile(
                title: "Dashboard",
                svgSrc: "assets/icons/dashboard_new2.svg",
                svgHeight: 17,
                press: () {
                  menu.setMyMenu('Dashboard');
                  _handlePageNavigation(context, '/');
                },
              ),
              // DrawerListTile(
              //   title: "Check In",
              //   svgSrc: "assets/icons/checkin.svg",
              //   press: () {
              //     menu.setMyMenu('Check In');
              //     // _handlePageNavigation(context, '/checkin');
              //   },
              // ),
              // DrawerListTile(
              //   title: "Check Out",
              //   svgSrc: "assets/icons/checkout.svg",
              //   press: () {
              //     menu.setMyMenu('Check Out');
              //     // _handlePageNavigation(context, '/');
              //   },
              // ),
              // DrawerListTile(
              //   title: "Master",
              //   svgSrc: "assets/icons/master.svg",
              //   press: () {
              //     menu.setMyMenu('Master');
              //   },
              // ),
              // DrawerListTile(
              //   title: "Report",
              //   svgSrc: "assets/icons/report.svg",
              //   press: () {
              //     menu.setMyMenu('Report');
              //   },
              // ),
              // DrawerListTile(
              //   title: "Reset Password",
              //   svgSrc: "assets/icons/reset_password.svg",
              //   press: () {
              //     menu.setMyMenu('Reset Password');
              //   },
              // ),
              // DrawerListTile(
              //   title: "LogOut",
              //   svgSrc: "assets/icons/logout.svg",
              //   press: () {
              //     menu.setMyMenu('LogOut');
              //   },
              // ),

              ///////////////////////////////////////////
              DrawerListTile(
                title: "Tickets",
                svgSrc: "assets/icons/tickets.svg",
                // svgHeight: 16,
                // icon: FontAwesomeIcons.car,
                press: () {
                  menu.setMyMenu('Tickets');
                  _handlePageNavigation(context, '/tickets');
                },
              ),
              // ExpansionDrawerListTile(
              //   title: "Tickets",
              //   svgSrc: "assets/icons/checkin.svg",
              //   svgHeight: 16,
              //   press: () {
              //     menu.setMyMenu('Tickets');
              //     // _handlePageNavigation(context, '/');
              //   },
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 30),
              //       child: Column(
              //         children: [
              //           DrawerListTile(
              //             title: "Check In",
              //             svgSrc: 'assets/icons/key_exchange.svg',
              //             svgHeight: 13,
              //             press: () {
              //               menu.setMyMenu('Check In');
              //               // _handlePageNavigation(context, '/');
              //             },
              //           ),
              //           DrawerListTile(
              //             title: "Check Out",
              //             // svgSrc: "assets/icons/report_graph.svg",
              //             icon: FontAwesomeIcons.caravan,
              //             svgHeight: 13,
              //             press: () {
              //               menu.setMyMenu('Check Out');
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              DrawerListTile(
                title: "Search",
                svgSrc: "assets/icons/search2.svg",
                svgHeight: 18,
                press: () {
                  menu.setMyMenu('Search');
                  _handlePageNavigation(context, '/search');
                },
              ),
              ExpansionDrawerListTile(
                title: "Report",
                svgSrc: "assets/icons/report-file.svg",
                svgHeight: 16,
                press: () {
                  menu.setMyMenu('Report');
                  // _handlePageNavigation(context, '/');
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        DrawerListTile(
                          title: "Master Report",
                          svgSrc: "assets/icons/report_graph.svg",
                          svgHeight: 13,
                          press: () {
                            menu.setMyMenu('Master Report');
                            _handlePageNavigation(context, '/masterreport');
                          },
                        ),
                        DrawerListTile(
                          title: "Inventory Report",
                          svgSrc: "assets/icons/report_graph.svg",
                          svgHeight: 13,
                          press: () {
                            menu.setMyMenu('Inventory Report');
                            _handlePageNavigation(context, '/inventoryreport');
                          },
                        ),
                        DrawerListTile(
                          title: "Ticket",
                          svgSrc: "assets/icons/report_graph.svg",
                          svgHeight: 13,
                          press: () {
                            menu.setMyMenu('Ticket');
                            _handlePageNavigation(context, '/ticketreport');
                          },
                        ),
                        DrawerListTile(
                          title: "Cash Collection",
                          svgSrc: "assets/icons/report_graph.svg",
                          svgHeight: 13,
                          press: () {
                            menu.setMyMenu('Cash Collection');
                            _handlePageNavigation(context, '/cashcollection');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DrawerListTile(
                title: "Account",
                svgSrc: "assets/icons/account.svg",
                svgHeight: 15,
                press: () {
                  menu.setMyMenu('Account');
                  _handlePageNavigation(context, '/account');
                },
              ),
              DrawerListTile(
                title: "LogOut",
                svgHeight: 17,
                svgSrc: "assets/icons/logout2.svg",
                press: () {
                  menu.setMyMenu('LogOut');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePageNavigation(BuildContext context, String route) async {
    await Navigator.of(context).pushNamed(route);
    // await Navigator.of(context).push(
    //   PageRouteBuilder(
    //     settings: RouteSettings(name: '/'),
    //     pageBuilder: (context, animation, _) => DashboardScreen(),
    //     transitionsBuilder: (context, animation, _, child) {
    //       const begin = Offset(0.0, 1.0);
    //       const end = Offset.zero;
    //       const curve = Curves.ease;

    //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    //       return SlideTransition(
    //         position: animation.drive(tween),
    //         child: child,
    //       );
    //     },
    //   ),
    // );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final String? svgSrc;
  final IconData? icon;
  final double? svgHeight;
  final VoidCallback press;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.press,
    this.svgSrc,
    this.icon,
    this.svgHeight,
  });

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<SideMenuController>(context);
    final isSelected = menu.myMenu == title;
    return ColoredBox(
      // color: isSelected ? Colors.white54 : Colors.transparent,
      color: isSelected ? secondaryColor2 : Colors.transparent,
      child: ListTile(
        hoverColor: Colors.purple[100],
        onTap: press,
        horizontalTitleGap: 12.0,
        leading: icon == null
            ? SvgPicture.asset(
                svgSrc!,
                // color: Colors.white54,
                colorFilter: ColorFilter.mode(
                  // isSelected ? primaryColor : Colors.black87,
                  isSelected ? Colors.white : Colors.black87,
                  BlendMode.srcIn,
                ),
                height: svgHeight ?? 20,
              )
            : Icon(icon, size: svgHeight ?? 13, color: isSelected ? Colors.white : Colors.black87),
        title: Text(
          title,
          style: TextStyle(
            // color: isSelected ? primaryColor : Colors.black87,
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class ExpansionDrawerListTile extends StatelessWidget {
  final String title, svgSrc;
  final double? svgHeight;
  final VoidCallback press;
  final List<Widget> children;
  const ExpansionDrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.children,
    this.svgHeight,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    final menu = Provider.of<SideMenuController>(context);
    final isSelected = menu.myMenu == title;
    return ColoredBox(
      color: isSelected ? Colors.white54 : Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          // iconTheme: IconThemeData(color: Colors.red)
        ),
        child: ExpansionTile(
          trailing: const SizedBox.shrink(),
          // onTap: press,
          // horizontalTitleGap: 12.0,
          leading: SvgPicture.asset(
            svgSrc,
            // color: Colors.white54,
            colorFilter: ColorFilter.mode(isSelected ? primaryColor : Colors.black87, BlendMode.srcIn),
            height: svgHeight ?? 20,
          ),
          title: Text(
            title,
            style: TextStyle(color: isSelected ? primaryColor : Colors.black87, fontSize: 13),
          ),
          children: children,
        ),
      ),
    );
  }
}
