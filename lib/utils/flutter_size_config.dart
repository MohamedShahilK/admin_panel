// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

// SizeConfig help us to make our UI responsive
/// Make sure you need to call [SizeConfig.init(context)] on your starting screen
class SizeConfig {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
    orientation = mediaQueryData!.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(BuildContext context, double inputHeight) {
  // double? screenHeight = SizeConfig.screenHeight;
  final screenHeight = MediaQuery.of(context).size.height;
  // Our designer use iPhone 11, that's why we use 896.0 (viewport height)
  // return (inputHeight / 896.0) * screenHeight!;
  return (inputHeight / 890.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(BuildContext context, double inputWidth) {
  final screenWidth = MediaQuery.of(context).size.width;
  // 414 (viewport width) is the layout width that designer use or you can say iPhone 11  width
  // return (inputWidth / 640.0) * screenWidth!;
  return (inputWidth / 414.0) * screenWidth;
}

// // For add free space vertically
// class VerticalSpacing extends StatelessWidget {
//   const VerticalSpacing({
//     Key? key,
//     this.of = 20,
//   }) : super(key: key);

//   final double of;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: getProportionateScreenWidth(of),
//     );
//   }
// }

// // For add free space horizontally
// class HorizontalSpacing extends StatelessWidget {
//   const HorizontalSpacing({
//     Key? key,
//     this.of = 20,
//   }) : super(key: key);

//   final double of;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: getProportionateScreenWidth(of),
//     );
//   }
// }
