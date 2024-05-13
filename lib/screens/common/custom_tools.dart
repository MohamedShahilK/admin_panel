
// Future<void> successMotionToastInfo(
//   BuildContext context, {
//   required String msg,
//   // AnimationType animationType = AnimationType.fromLeft,
//   Duration animationDuration = const Duration(milliseconds: 1300),
//   double? width,
//   double? height,
// }) async {
//   DelightToastBar(
//     autoDismiss: true,
//     builder: (context) => ToastCard(
//       color: Colors.green[100],
//       leading: Icon(Icons.check_circle_outline_rounded, size: 25, color: Colors.green[800]),
//       title: Text(
//         msg,
//         style: TextStyle(
//           fontWeight: FontWeight.w700,
//           color: Colors.green[800],
//           fontSize: 13,
//         ),
//       ),
//     ),
//   ).show(context);
// }


// Future<void> erroMotionToastInfo(
//   BuildContext context, {
//   required String msg,
//   // AnimationType animationType = AnimationType.fromLeft,
//   Duration animationDuration = const Duration(milliseconds: 1300),
//   double? width,
//   double? height,
// }) async {
//   DelightToastBar(
//     autoDismiss: true,
//     builder: (context) => ToastCard(
//       color: Colors.red[100],
//       leading: Icon(Icons.error_outline_sharp, size: 25, color: Colors.red[800]),
//       title: Text(
//         msg,
//         style: TextStyle(
//           fontWeight: FontWeight.w700,
//           color: Colors.red[800],
//           fontSize: 13,
//         ),
//       ),
//     ),
//   ).show(context);
// }



// Future<void> warningMotionToastInfo(
//   BuildContext context, {
//   required String msg,
//   // AnimationType animationType = AnimationType.fromLeft,
//   Duration animationDuration = const Duration(milliseconds: 1300),
//   double? width,
//   double? height,
// }) async {
//   DelightToastBar(
//     autoDismiss: true,
//     builder: (context) => ToastCard(
//       color: Colors.yellow[100],
//       leading: Icon(Icons.warning_amber, size: 25, color: Colors.yellow[800]),
//       title: Text(
//         msg,
//         style: TextStyle(
//           fontWeight: FontWeight.w700,
//           color: Colors.yellow[800],
//           fontSize: 13,
//         ),
//       ),
//     ),
//   ).show(context);
// }

// void customLoader(BuildContext context) {
//   return Loader.show(
//     context,
//     progressIndicator: LoadingAnimationWidget.discreteCircle(
//       color: AppColors.mainColor!,
//       secondRingColor: Colors.grey[700]!,
//       thirdRingColor: Colors.grey,
//       size: 40.sp,
//     ),
//   );
// }

// void customLoaderForPages(BuildContext context) {
//   return Loader.show(
//     context,
//     progressIndicator: SafeArea(
//       child: Stack(
//         children: [
//           // Column(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: [
//           //     Row(
//           //       mainAxisAlignment: MainAxisAlignment.center,
//           //       children: [
//           //         LoadingAnimationWidget.beat(
//           //           color: Colors.purple,
//           //           size: 8.sp,
//           //         ),
//           //         SizedBox(width: 10.w),
//           //         Text(
//           //           'Generating Pdf...',
//           //           style: TextStyle(
//           //             fontWeight: FontWeight.w700,
//           //             color: Colors.purple,
//           //             fontSize: 10.w,
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ],
//           // ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: MediaQuery.of(context).size.width / 2.5),
//               padding: EdgeInsets.symmetric(vertical: 4.h),
//               decoration: BoxDecoration(
//                 color: Colors.black45,
//                 borderRadius: BorderRadius.circular(5.r),
//               ),
//               child: Row(
//                 // mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   DefaultTextStyle(
//                     style: TextStyle(color: Colors.white, fontSize: 13.w),
//                     child: const Text('Loading ...'),
//                   ),

//                   // SizedBox(width: 10.w),

//                   // LoadingAnimationWidget.stretchedDots(color: Colors.black, size: 16.w),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// void customLoaderForPdf(BuildContext context) {
//   return Loader.show(
//     context,
//     progressIndicator: SafeArea(
//       child: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   LoadingAnimationWidget.beat(
//                     color: Colors.purple,
//                     size: 8.sp,
//                   ),
//                   SizedBox(width: 10.w),
//                   Text(
//                     'Generating Pdf...',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       color: Colors.purple,
//                       fontSize: 10.w,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             top: 20.h,
//             right: 20.w,
//             child: Container(
//               padding: EdgeInsets.all(6.w),
//               decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple[300]),
//               child: Icon(Icons.close, size: 15.w, color: Colors.white),
//             ).ripple(context, Loader.hide),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// void customLoaderForPrintReceipt(BuildContext context) {
//   return Loader.show(
//     context,
//     progressIndicator: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         LoadingAnimationWidget.beat(
//           color: Colors.purple,
//           size: 8.sp,
//         ),
//         SizedBox(width: 10.w),
//         Text(
//           'Generating Print Receipt...',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             color: Colors.purple,
//             fontSize: 10.w,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void customLoaderForExcel(BuildContext context) {
//   return Loader.show(
//     context,
//     progressIndicator: SafeArea(
//       child: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   LoadingAnimationWidget.beat(
//                     color: Colors.purple,
//                     size: 8.sp,
//                   ),
//                   SizedBox(width: 10.w),
//                   Text(
//                     'Generating Excel Sheet...',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       color: Colors.purple,
//                       fontSize: 10.w,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             top: 20.h,
//             right: 20.w,
//             child: Container(
//               padding: EdgeInsets.all(6.w),
//               decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple[300]),
//               child: Icon(Icons.close, size: 15.w, color: Colors.white),
//             ).ripple(context, Loader.hide),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// void customLoader1(BuildContext context, {required Widget child}) {
//   // For Ipad
//   final screenWidth = MediaQuery.of(context).size.width;
//   final screenHeight = MediaQuery.of(context).size.height;
//   final largeDev = (screenHeight > 1100) && (screenWidth > 800);
//   // For Ipad
//   final userType = StorageServices.to.getString('userType');
//   return Loader.show(
//     context,
//     overlayColor: Colors.white38,
//     // progressIndicator: LoadingAnimationWidget.stretchedDots(
//     //   color: AppColors.mainColor!,
//     //   size: 40.sp,
//     // ),
//     progressIndicator: SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: SalomonBottomBar(
//           currentIndex: navigationItemIndex.value,
//           items: [
//             SalomonBottomBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/home1.svg',
//                 // color: index != 2 ? Colors.white24 : Colors.white70,
//                 // ignore: deprecated_member_use
//                 color: navigationItemIndex.value == 0 ? Colors.purple : Colors.black45,
//                 width: largeDev ? 20.w : 18.w,
//                 fit: BoxFit.fill,
//               ),
//               title: Text('Home', style: TextStyle(fontSize: largeDev ? 7.w : 12.w)),
//               selectedColor: Colors.purple,
//             ),
//             if (userType != 'ADMIN' && userType != 'A' && userType != 'R')
//               SalomonBottomBarItem(
//                 icon: Icon(
//                   FontAwesomeIcons.car,
//                   size: 18.w,
//                   color: navigationItemIndex.value == 1 ? Colors.purple : Colors.black45,
//                 ),
//                 title: Text('Actions', style: TextStyle(fontSize: largeDev ? 7.w : 12.w)),
//                 // selectedColor: Colors.green,
//                 selectedColor: Colors.purple,
//               ),
//             if (userType != 'ADMIN' && userType != 'A' && userType != 'R')
//               SalomonBottomBarItem(
//                 icon: Badge(
//                   largeSize: largeDev ? 36 : null,
//                   backgroundColor: Colors.purple,
//                   label: Text(
//                     '..',
//                     style: TextStyle(fontSize: largeDev ? 7.w : 10.w, fontWeight: FontWeight.w500, color: Colors.white),
//                   ),
//                   child: SvgPicture.asset(
//                     'assets/images/notifications.svg',
//                     color: navigationItemIndex.value == 2 ? Colors.purple : Colors.black45,
//                     width: largeDev ? 20.w : 18.w,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 title: Text('Notifications', style: TextStyle(fontSize: largeDev ? 7.w : 12.w)),
//                 selectedColor: Colors.purple,
//               ),
//             SalomonBottomBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/search.svg',
//                 color: navigationItemIndex.value == 3 ? Colors.purple : Colors.black45,
//                 width: largeDev ? 20.w : 18.w,
//                 fit: BoxFit.fill,
//               ),
//               title: Text('Search', style: TextStyle(fontSize: largeDev ? 7.w : 12.w)),
//               selectedColor: Colors.purple,
//             ),
//             if (['ADMIN', 'A', 'R', 'LA'].contains(userType))
//               SalomonBottomBarItem(
//                 icon: SvgPicture.asset(
//                   'assets/images/report_icon.svg',
//                   // color: index != 2 ? Colors.white24 : Colors.white70,
//                   // color: navigationItemIndex.value == 3
//                   //     ? Colors.orange
//                   //     : Colors.black45,
//                   color: navigationItemIndex.value == 3 ? Colors.purple : Colors.black45,
//                   width: largeDev ? 20.w : 18.w,
//                   fit: BoxFit.fill,
//                 ),
//                 title: Text('Reports', style: TextStyle(fontSize: largeDev ? 7.w : 12.w)),
//                 // selectedColor: Colors.orange,
//                 selectedColor: Colors.purple,
//               ),
//             SalomonBottomBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/account.svg',
//                 color: navigationItemIndex.value == 4 ? Colors.purple : Colors.black45,
//                 width: largeDev ? 20.w : 18.w,
//                 fit: BoxFit.fill,
//               ),
//               title: Text('Account', style: TextStyle(fontSize: largeDev ? 7.w : 12.w)),
//               selectedColor: Colors.purple,
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             const CustomHeader(heading: 'heading'),
//             child,
//           ],
//         ),
//       ),
//     ),
//   );
// }

// void customInternetLoader(BuildContext context) {
//   return Loader.show(
//     context,
//     progressIndicator: LoadingAnimationWidget.beat(
//       color: AppColors.mainColor!,
//       size: 40.sp,
//     ),
//   );
// }
