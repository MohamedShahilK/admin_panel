import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  // static bool isMobile(BoxConstraints con) => con.maxWidth < 850;

  // static bool isTablet(BoxConstraints con) => con.maxWidth >= 850 && con.maxWidth < 1100;

  // static bool isDesktop(BoxConstraints con) => con.maxWidth >= 1100;

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // // If our width is more than 1100 then we consider it a desktop
    // if (size.width >= 1100) {
    //   return desktop;
    // }
    // // If width it less then 1100 and more then 850 we consider it as tablet
    // else if (size.width >= 850) {
    //   return tablet;
    // }
    // // Or less then that we called it mobile
    // else {
    //   return mobile;
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          // If the screen width is 1200 or larger, display largeScreen
          return desktop;
        } else if (constraints.maxWidth >= 850) {
          // If the screen width is between 600 and 1199, display mediumScreen
          return tablet;
        } else {
          // If the screen width is less than 600, display smallScreen
          return mobile;
        }
      },
    );
  }
}
