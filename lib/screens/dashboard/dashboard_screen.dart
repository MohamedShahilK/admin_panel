// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:admin_panel/controllers/dashboard_tab_controller.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:admin_panel/data/checkin_model.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/models/new/all_checkin/all_checkin_response_model.dart';
import 'package:admin_panel/models/new/all_checkout/all_checkout_response_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/dashboard/dashboard_resp_model.dart';
import 'package:admin_panel/models/old/user.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:admin_panel/screens/widgets/scrollable_widget.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'components/header.dart';

// final usersNotifier = ValueNotifier<List<CheckInModel>>([]);
// final usersNotifier = ValueNotifier<List<ActiveTickets>>([]);

ValueNotifier<int> currentPageForDashBoardPage = ValueNotifier(1);
ValueNotifier<int> currentPageForDashBoardPageCheckIns = ValueNotifier(1);
ValueNotifier<int> currentPageForDashBoardPageCheckOut = ValueNotifier(1);
ValueNotifier<int> currentPageForDashBoardPageParked = ValueNotifier(1);
ValueNotifier<int> currentPageForDashBoardPageRequested = ValueNotifier(1);
ValueNotifier<int> currentPageForDashBoardPageOntheway = ValueNotifier(1);
ValueNotifier<int> currentPageForDashBoardPageCollectNow = ValueNotifier(1);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
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
            const Expanded(
              flex: 7,
              child: _Body(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    final dashBloc = Provider.of<DashboardBloc>(context, listen: false);
    final dashTabController = Provider.of<DashBoardTabController>(context, listen: false);
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        controller: _scrollController,
        // padding: EdgeInsets.all(defaultPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
            child: StreamBuilder(
                stream: dashBloc.state.getDashRespStream,
                builder: (context, getDashRespStreamSnapshot) {
                  List<ActiveTickets>? ticketsList = [];
                  var totalCountForAdmin = 0;
                  var totalCounCheckIn = 0;
                  var totalCountParked = 0;
                  var totalCountRequested = 0;
                  var totalCountOntheway = 0;
                  var totalCountCollectnow = 0;
                  var totalCountCheckout = 0;
                  if (getDashRespStreamSnapshot.hasData) {
                    final allTicketsModel = getDashRespStreamSnapshot.data;
                    ticketsList = allTicketsModel!.data!.activeTickets ?? <ActiveTickets>[];
                    // usersNotifier.value = ticketsList;
                    // usersNotifier.notifyListeners();
                    print('11111111111111111111111 $allTicketsModel');
                    totalCountForAdmin = (allTicketsModel!.data!.checkinCount!.count ?? 0) +
                        (allTicketsModel.data!.requestedCount!.count ?? 0) +
                        (allTicketsModel.data!.onthewayCount!.count ?? 0) +
                        (allTicketsModel.data!.collectnowCount!.count ?? 0);

                    totalCounCheckIn = ((allTicketsModel.data!.checkinCount!.count ?? 0) - (allTicketsModel.data!.parkedCount!.count ?? 0));
                    totalCountParked = allTicketsModel.data!.parkedCount!.count ?? 0;
                    totalCountRequested = allTicketsModel.data!.requestedCount!.count ?? 0;
                    totalCountOntheway = allTicketsModel.data!.onthewayCount!.count ?? 0;
                    totalCountCollectnow = allTicketsModel.data!.collectnowCount!.count ?? 0;
                    totalCountCheckout = allTicketsModel.data!.checkoutCount!.count ?? 0;
                  }
                  return Skeletonizer(
                    enabled: !getDashRespStreamSnapshot.hasData,
                    effect: const ShimmerEffect(),
                    containersColor: Colors.grey[100],
                    child: Column(
                      children: [
                        const Header(),
                        // const SizedBox(height: defaultPadding * 3),

                        const SizedBox(height: 30),

                        //
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // alignment: WrapAlignment.center,
                          runSpacing: 15,
                          children: [
                            _DashTopCard(
                              title: 'Current Inventory',
                              svgIcon: 'assets/icons/inventory.svg',
                              count: totalCountForAdmin.toString(),
                              color: Colors.brown[900]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () {
                                  dashTabController.setMenuName('Current Inventory');
                                  // usersNotifier.value = allUsers;
                                  // usersNotifier.value = ticketsList ?? [];
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Check In',
                              svgIcon: 'assets/icons/key_exchange.svg',
                              count: totalCounCheckIn.toString(),
                              color: Colors.green[600]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () async {
                                  await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: 1);
                                  dashTabController.setMenuName('Check In');
                                  // usersNotifier.value = allCheckedInUsers;
                                  // usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Parked',
                              // svgIcon: 'assets/icons/checkout.svg',
                              icon: Icons.local_parking_rounded,
                              count: totalCountParked.toString(),
                              color: Colors.yellow[800]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () async {
                                  await dashBloc.getParkedTickets(orderBy: 'id', pageNo: 1);
                                  dashTabController.setMenuName('Parked');
                                  // usersNotifier.value = allParkedInUsers;
                                  // usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'P').toList();
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Requested',
                              // svgIcon: 'assets/icons/inventory.svg',
                              icon: FontAwesomeIcons.registered,
                              count: totalCountRequested.toString(),
                              color: Colors.blue[600]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () async {
                                  await dashBloc.getRequestedTickets(orderBy: 'id', pageNo: 1);
                                  dashTabController.setMenuName('Requested');
                                  // usersNotifier.value = allRequestedInUsers;
                                  // usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'On The Way',
                              // svgIcon: 'assets/icons/checkin.svg',
                              icon: FontAwesomeIcons.route,
                              count: totalCountOntheway.toString(),
                              color: Colors.purple[600]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () async {
                                  await dashBloc.getOntheWayTickets(orderBy: 'id', pageNo: 1);
                                  dashTabController.setMenuName('On The Way');
                                  // usersNotifier.value = allOnthewayUsers;
                                  // usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Collect Now',
                              svgIcon: 'assets/icons/checkin.svg',
                              count: totalCountCollectnow.toString(),
                              color: Colors.orange[900]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () async {
                                  await dashBloc.getCollectNowTickets(orderBy: 'id', pageNo: 1);
                                  dashTabController.setMenuName('Collect Now');
                                  // usersNotifier.value = allVehicleArrivedUsers;
                                  // usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Check Out',
                              // svgIcon: 'assets/icons/checkout.svg',
                              icon: FontAwesomeIcons.caravan,
                              count: totalCountCheckout.toString(),
                              color: Colors.red[900]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              // usersNotifier.value = [];
                              // usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 0),
                                () async {
                                  await dashBloc.getCheckOutTickets(orderBy: 'id', pageNo: 1);
                                  dashTabController.setMenuName('Check Out');
                                  // usersNotifier.value = allCheckedOutUsers;
                                  // usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  // usersNotifier.notifyListeners();
                                },
                              );
                            }),
                          ],
                        ),

                        // Butt

                        // Table
                        Consumer<DashBoardTabController>(
                          builder: (context, c, _) {
                            if (dashTabController.menuName == 'Current Inventory') {
                              return _Table(
                                item: ticketsList?.where((e) => e.checkoutStatus == 'N').toList(),
                              );
                            } else if (dashTabController.menuName == 'Check In') {
                              return StreamBuilder(
                                  stream: dashBloc.getAllCheckInTickets,
                                  builder: (context, getAllCheckInTicketsSnapshot) {
                                    if (getAllCheckInTicketsSnapshot.hasData) {
                                      final model = getAllCheckInTicketsSnapshot.data;
                                      final checkInList = model?.data?.checkinList;
                                      checkInList?.removeWhere((element) => element.dataCheckinTime != null);
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            _Table(item3: checkInList),
                                            if (model?.data?.totalPages != null && (model?.data?.totalPages)! > 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ...List.generate(20, (index) {
                                                      ...List.generate(model?.data?.totalPages ?? 0, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                                          child: ValueListenableBuilder(
                                                            valueListenable: currentPageForDashBoardPageCheckIns,
                                                            builder: (context, ix, _) {
                                                              return Container(
                                                                height: 22,
                                                                width: 22,
                                                                decoration: BoxDecoration(
                                                                  color: index + 1 != currentPageForDashBoardPageCheckIns.value ? Colors.grey : Colors.purple[400],
                                                                  borderRadius: BorderRadius.circular(50),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    //print('object');
                                                                    // await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                    // dashBloc.getAllCheckInTickets.add(null);
                                                                    // Future.delayed(const Duration(milliseconds: 500), () async {
                                                                    //   await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1);
                                                                    // });

                                                                    // customLoader(context);
                                                                    Loader.show(
                                                                      context,
                                                                      progressIndicator: LoadingAnimationWidget.fallingDot(
                                                                        color: secondaryColor,
                                                                        size: 40,
                                                                      ),
                                                                    );
                                                                    final isLoading = await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1, isNewPageLoading: true);
                                                                    if (isLoading) {
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () {
                                                                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                          currentPageForDashBoardPageCheckIns.value = index + 1;
                                                                          currentPageForDashBoardPageCheckIns.notifyListeners();
                                                                          Loader.hide();
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // ignore: unawaited_futures
                                                                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                      currentPageForDashBoardPageCheckIns.value = index + 1;
                                                                      currentPageForDashBoardPageCheckIns.notifyListeners();
                                                                      Loader.hide();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                      (index + 1).toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else if (getAllCheckInTicketsSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const SizedBox.shrink();
                                      return SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 120),
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget.twoRotatingArc(color: secondaryColor, size: 30),
                                              const Text(
                                                'Loading',
                                                style: TextStyle(fontSize: 27),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  });
                            } else if (dashTabController.menuName == 'Requested') {
                              return StreamBuilder(
                                  stream: dashBloc.getAllRequestedTickets,
                                  builder: (context, getAllRequestedTicketsSnapshot) {
                                    if (getAllRequestedTicketsSnapshot.hasData) {
                                      final model = getAllRequestedTicketsSnapshot.data;
                                      final requestedList = model?.data?.checkOutList;
                                      // print('111111111111111111111111 ${requestedList?.length}');
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            _Table(item4: requestedList),
                                            if (model?.data?.totalPages != null && (model?.data?.totalPages)! > 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ...List.generate(20, (index) {
                                                      ...List.generate(model?.data?.totalPages ?? 0, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                                          child: ValueListenableBuilder(
                                                            valueListenable: currentPageForDashBoardPageRequested,
                                                            builder: (context, ix, _) {
                                                              return Container(
                                                                height: 22,
                                                                width: 22,
                                                                decoration: BoxDecoration(
                                                                  color: index + 1 != currentPageForDashBoardPageRequested.value ? Colors.grey : Colors.purple[400],
                                                                  borderRadius: BorderRadius.circular(50),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    //print('object');
                                                                    // await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                    // dashBloc.getAllCheckInTickets.add(null);
                                                                    // Future.delayed(const Duration(milliseconds: 500), () async {
                                                                    //   await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1);
                                                                    // });

                                                                    // customLoader(context);
                                                                    Loader.show(
                                                                      context,
                                                                      progressIndicator: LoadingAnimationWidget.fallingDot(
                                                                        color: secondaryColor,
                                                                        size: 40,
                                                                      ),
                                                                    );
                                                                    final isLoading = await dashBloc.getRequestedTickets(orderBy: 'id', pageNo: index + 1, isNewPageLoading: true);
                                                                    if (isLoading) {
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () {
                                                                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                          currentPageForDashBoardPageRequested.value = index + 1;
                                                                          currentPageForDashBoardPageRequested.notifyListeners();
                                                                          Loader.hide();
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // ignore: unawaited_futures
                                                                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                      currentPageForDashBoardPageRequested.value = index + 1;
                                                                      currentPageForDashBoardPageRequested.notifyListeners();
                                                                      Loader.hide();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                      (index + 1).toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else if (getAllRequestedTicketsSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const SizedBox.shrink();
                                      return SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 120),
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget.twoRotatingArc(color: secondaryColor, size: 30),
                                              const Text(
                                                'Loading',
                                                style: TextStyle(fontSize: 27),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  });
                            } else if (dashTabController.menuName == 'On The Way') {
                              return StreamBuilder(
                                  stream: dashBloc.getAllOntheWayTickets,
                                  builder: (context, getAllOntheWayTicketsSnapshot) {
                                    if (getAllOntheWayTicketsSnapshot.hasData) {
                                      final model = getAllOntheWayTicketsSnapshot.data;
                                      final onthewayList = model?.data?.checkOutList;
                                      // print('111111111111111111111111 ${onthewayList?.length}');
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            _Table(item4: onthewayList),
                                            if (model?.data?.totalPages != null && (model?.data?.totalPages)! > 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ...List.generate(20, (index) {
                                                      ...List.generate(model?.data?.totalPages ?? 0, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                                          child: ValueListenableBuilder(
                                                            valueListenable: currentPageForDashBoardPageOntheway,
                                                            builder: (context, ix, _) {
                                                              return Container(
                                                                height: 22,
                                                                width: 22,
                                                                decoration: BoxDecoration(
                                                                  color: index + 1 != currentPageForDashBoardPageOntheway.value ? Colors.grey : Colors.purple[400],
                                                                  borderRadius: BorderRadius.circular(50),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    //print('object');
                                                                    // await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                    // dashBloc.getAllCheckInTickets.add(null);
                                                                    // Future.delayed(const Duration(milliseconds: 500), () async {
                                                                    //   await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1);
                                                                    // });

                                                                    // customLoader(context);
                                                                    Loader.show(
                                                                      context,
                                                                      progressIndicator: LoadingAnimationWidget.fallingDot(
                                                                        color: secondaryColor,
                                                                        size: 40,
                                                                      ),
                                                                    );
                                                                    final isLoading = await dashBloc.getOntheWayTickets(orderBy: 'id', pageNo: index + 1, isNewPageLoading: true);
                                                                    if (isLoading) {
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () {
                                                                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                          currentPageForDashBoardPageOntheway.value = index + 1;
                                                                          currentPageForDashBoardPageOntheway.notifyListeners();
                                                                          Loader.hide();
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // ignore: unawaited_futures
                                                                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                      currentPageForDashBoardPageOntheway.value = index + 1;
                                                                      currentPageForDashBoardPageOntheway.notifyListeners();
                                                                      Loader.hide();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                      (index + 1).toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else if (getAllOntheWayTicketsSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const SizedBox.shrink();
                                      return SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 120),
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget.twoRotatingArc(color: secondaryColor, size: 30),
                                              const Text(
                                                'Loading',
                                                style: TextStyle(fontSize: 27),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  });
                            } else if (dashTabController.menuName == 'Collect Now') {
                              return StreamBuilder(
                                  stream: dashBloc.getAllCollectNowTickets,
                                  builder: (context, getAllCollectNowTicketsSnapshot) {
                                    if (getAllCollectNowTicketsSnapshot.hasData) {
                                      final model = getAllCollectNowTicketsSnapshot.data;
                                      final collectnowList = model?.data?.checkOutList;
                                      // print('111111111111111111111111 ${collectnowList?.length}');
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            _Table(item4: collectnowList),
                                            if (model?.data?.totalPages != null && (model?.data?.totalPages)! > 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ...List.generate(20, (index) {
                                                      ...List.generate(model?.data?.totalPages ?? 0, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                                          child: ValueListenableBuilder(
                                                            valueListenable: currentPageForDashBoardPageCollectNow,
                                                            builder: (context, ix, _) {
                                                              return Container(
                                                                height: 22,
                                                                width: 22,
                                                                decoration: BoxDecoration(
                                                                  color: index + 1 != currentPageForDashBoardPageCollectNow.value ? Colors.grey : Colors.purple[400],
                                                                  borderRadius: BorderRadius.circular(50),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    //print('object');
                                                                    // await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                    // dashBloc.getAllCheckInTickets.add(null);
                                                                    // Future.delayed(const Duration(milliseconds: 500), () async {
                                                                    //   await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1);
                                                                    // });

                                                                    // customLoader(context);
                                                                    Loader.show(
                                                                      context,
                                                                      progressIndicator: LoadingAnimationWidget.fallingDot(
                                                                        color: secondaryColor,
                                                                        size: 40,
                                                                      ),
                                                                    );
                                                                    final isLoading = await dashBloc.getCollectNowTickets(orderBy: 'id', pageNo: index + 1, isNewPageLoading: true);
                                                                    if (isLoading) {
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () {
                                                                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                          currentPageForDashBoardPageCollectNow.value = index + 1;
                                                                          currentPageForDashBoardPageCollectNow.notifyListeners();
                                                                          Loader.hide();
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // ignore: unawaited_futures
                                                                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                      currentPageForDashBoardPageCollectNow.value = index + 1;
                                                                      currentPageForDashBoardPageCollectNow.notifyListeners();
                                                                      Loader.hide();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                      (index + 1).toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else if (getAllCollectNowTicketsSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const SizedBox.shrink();
                                      return SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 120),
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget.twoRotatingArc(color: secondaryColor, size: 30),
                                              const Text(
                                                'Loading',
                                                style: TextStyle(fontSize: 27),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  });
                            } else if (dashTabController.menuName == 'Check Out') {
                              return StreamBuilder(
                                  stream: dashBloc.getAllCheckOutTickets,
                                  builder: (context, getAllCheckOutTicketsSnapshot) {
                                    if (getAllCheckOutTicketsSnapshot.hasData) {
                                      final model = getAllCheckOutTicketsSnapshot.data;
                                      final checkoutList = model?.data?.checkOutList;
                                      // print('111111111111111111111111 ${checkoutList?.length}');
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            _Table(item4: checkoutList),
                                            if (model?.data?.totalPages != null && (model?.data?.totalPages)! > 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ...List.generate(20, (index) {
                                                      ...List.generate(model?.data?.totalPages ?? 0, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                                          child: ValueListenableBuilder(
                                                            valueListenable: currentPageForDashBoardPageCheckOut,
                                                            builder: (context, ix, _) {
                                                              return Container(
                                                                height: 22,
                                                                width: 22,
                                                                decoration: BoxDecoration(
                                                                  color: index + 1 != currentPageForDashBoardPageCheckOut.value ? Colors.grey : Colors.purple[400],
                                                                  borderRadius: BorderRadius.circular(50),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    //print('object');
                                                                    // await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                    // dashBloc.getAllCheckInTickets.add(null);
                                                                    // Future.delayed(const Duration(milliseconds: 500), () async {
                                                                    //   await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1);
                                                                    // });

                                                                    // customLoader(context);
                                                                    Loader.show(
                                                                      context,
                                                                      progressIndicator: LoadingAnimationWidget.fallingDot(
                                                                        color: secondaryColor,
                                                                        size: 40,
                                                                      ),
                                                                    );
                                                                    final isLoading = await dashBloc.getCheckOutTickets(orderBy: 'id', pageNo: index + 1, isNewPageLoading: true);
                                                                    if (isLoading) {
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () {
                                                                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                          currentPageForDashBoardPageCheckOut.value = index + 1;
                                                                          currentPageForDashBoardPageCheckOut.notifyListeners();
                                                                          Loader.hide();
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // ignore: unawaited_futures
                                                                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                      currentPageForDashBoardPageCheckOut.value = index + 1;
                                                                      currentPageForDashBoardPageCheckOut.notifyListeners();
                                                                      Loader.hide();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                      (index + 1).toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else if (getAllCheckOutTicketsSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const SizedBox.shrink();
                                      return SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 120),
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget.twoRotatingArc(color: secondaryColor, size: 30),
                                              const Text(
                                                'Loading',
                                                style: TextStyle(fontSize: 27),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  });
                            } else if (dashTabController.menuName == 'Parked') {
                              return StreamBuilder(
                                  stream: dashBloc.getAllParkedTickets,
                                  builder: (context, getAllParkedTicketsSnapshot) {
                                    if (getAllParkedTicketsSnapshot.hasData) {
                                      final model = getAllParkedTicketsSnapshot.data;
                                      final parkedList = model?.data?.checkOutList;
                                      // print('111111111111111111111111 ${parkedList?.length}');
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            _Table(item4: parkedList),
                                            if (model?.data?.totalPages != null && (model?.data?.totalPages)! > 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // ...List.generate(20, (index) {
                                                      ...List.generate(model?.data?.totalPages ?? 0, (index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 3),
                                                          child: ValueListenableBuilder(
                                                            valueListenable: currentPageForDashBoardPageParked,
                                                            builder: (context, ix, _) {
                                                              return Container(
                                                                height: 22,
                                                                width: 22,
                                                                decoration: BoxDecoration(
                                                                  color: index + 1 != currentPageForDashBoardPageParked.value ? Colors.grey : Colors.purple[400],
                                                                  borderRadius: BorderRadius.circular(50),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    //print('object');
                                                                    // await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                    // dashBloc.getAllCheckInTickets.add(null);
                                                                    // Future.delayed(const Duration(milliseconds: 500), () async {
                                                                    //   await dashBloc.getCheckInTickets(orderBy: 'id', pageNo: index + 1);
                                                                    // });

                                                                    // customLoader(context);
                                                                    Loader.show(
                                                                      context,
                                                                      progressIndicator: LoadingAnimationWidget.fallingDot(
                                                                        color: secondaryColor,
                                                                        size: 40,
                                                                      ),
                                                                    );
                                                                    final isLoading = await dashBloc.getParkedTickets(orderBy: 'id', pageNo: index + 1, isNewPageLoading: true);
                                                                    if (isLoading) {
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () {
                                                                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                          currentPageForDashBoardPageParked.value = index + 1;
                                                                          currentPageForDashBoardPageParked.notifyListeners();
                                                                          Loader.hide();
                                                                        },
                                                                      );
                                                                    } else {
                                                                      // ignore: unawaited_futures
                                                                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                      currentPageForDashBoardPageParked.value = index + 1;
                                                                      currentPageForDashBoardPageParked.notifyListeners();
                                                                      Loader.hide();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                      (index + 1).toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else if (getAllParkedTicketsSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const SizedBox.shrink();
                                      return SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 120),
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget.twoRotatingArc(color: secondaryColor, size: 30),
                                              const Text(
                                                'Loading',
                                                style: TextStyle(fontSize: 27),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  });
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      );
    });
  }
}

class _Table extends StatelessWidget {
  const _Table({
    this.item,
    this.item2,
    this.item3,
    this.item4,
    super.key,
  });

  final List<ActiveTickets>? item;
  final List<TicketsList>? item2;
  final List<CheckinList>? item3;
  final List<CheckOutList>? item4;

  @override
  Widget build(BuildContext context) {
    final length = item == null
        ? item2 == null
            ? item3 == null
                ? item4 == null
                    ? 0
                    : item4!.length
                : item3!.length
            : item2!.length
        : item!.length;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: secondaryColor)),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       const Icon(Icons.download_for_offline_outlined, color: secondaryColor),
                  //       const SizedBox(width: 10),
                  //       Text(
                  //         'Download'.toUpperCase(),
                  //         // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                  //         style: GoogleFonts.poppins().copyWith(color: secondaryColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Tickets:'.toUpperCase(),
                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                          style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          // '50',
                          // allCheckedInUsers.length.toString(),
                          // usersNotifier.value.length.toString(),
                          length.toString(),
                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                          style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: Container(
                // padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                // margin: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200]!),
                  // borderRadius: BorderRadius.circular(30),
                ),
                child: SortablePage(item: item, item2: item2, item3: item3, item4: item4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortablePage extends StatefulWidget {
  const SortablePage({this.item, this.item2, this.item3, this.item4, super.key});

  final List<ActiveTickets>? item;
  final List<TicketsList>? item2;
  final List<CheckinList>? item3;
  final List<CheckOutList>? item4;

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  // List<CheckInModel> users = [];
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) => ScrollableWidget(child: buildDataTable());

  Widget buildDataTable() {
    final columns = ['Ticket No.', 'Checkin Time', 'Checkin Updation Time', 'Request Time', 'On the way Time', 'Car Brand', 'Car Colour', 'CVA-In', 'Emirates', 'Plate No.', 'Status'];

    return DataTable(
      headingRowColor: MaterialStateProperty.all(secondaryColor),
      // headingRowColor: MaterialStateProperty.all(Color(0xFFFBFCFC)),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      dividerThickness: .1,
      dataRowMaxHeight: 50,
      onSelectAll: (value) {},
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      // rows: getRows(usersNotifier.value),
      rows: getRows(),
      // decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[400]!)),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              // textAlign: TextAlign.center,
            ),
            onSort: onSort,
          ))
      .toList();

  // List<DataRow> getRows(List<ActiveTickets> users) {
  List<DataRow> getRows() {
    // if (users.isEmpty) {
    //   return List.generate(1, (index) => DataRow(cells: getCells(['', '', '', '', '', '', '', '', '', '', ''])));
    // }

    if (widget.item != null) {
      return widget.item!.map((ActiveTickets user) {
        final cells = [
          user.barcode ?? '',
          user.initialCheckinTime ?? '',
          user.dataCheckinTime ?? '',
          user.requestedTime ?? '',
          user.onthewayTime ?? '',
          user.carModelName ?? '',
          user.carColorName ?? '',
          user.cvaInName ?? '',
          user.emiratesName ?? '',
          user.vehicleNumber ?? '',
          user.checkoutStatus ?? 'N',
        ];

        return DataRow(cells: getCells(cells));
      }).toList();
    } else if (widget.item2 != null) {
      return widget.item2!.map((TicketsList user) {
        final cells = [
          user.barcode ?? '',
          user.initialCheckinTime ?? '',
          user.dataCheckinTime ?? '',
          user.requestedTime ?? '',
          user.onthewayTime ?? '',
          user.carModelName ?? '',
          user.carColorName ?? '',
          user.cvaInName ?? '',
          user.emiratesName ?? '',
          user.vehicleNumber ?? '',
          user.checkoutStatus ?? 'N',
        ];

        return DataRow(cells: getCells(cells));
      }).toList();
    } else if (widget.item3 != null) {
      return widget.item3!.map((CheckinList user) {
        final cells = [
          user.barcode ?? '',
          user.initialCheckinTime ?? '',
          user.dataCheckinTime ?? '',
          user.requestedTime ?? '',
          user.onthewayTime ?? '',
          user.carModelName ?? '',
          user.carColorName ?? '',
          user.cvaInName ?? '',
          user.emiratesName ?? '',
          user.vehicleNumber ?? '',
          user.checkoutStatus ?? 'N',
        ];

        return DataRow(cells: getCells(cells));
      }).toList();
    } else {
      return widget.item4!.map((CheckOutList user) {
        final cells = [
          user.barcode ?? '',
          user.initialCheckinTime ?? '',
          user.dataCheckinTime ?? '',
          user.requestedTime ?? '',
          user.onthewayTime ?? '',
          user.carModelName ?? '',
          user.carColorName ?? '',
          user.cvaInName ?? '',
          user.emiratesName ?? '',
          user.vehicleNumber ?? '',
          user.checkoutStatus ?? 'N',
        ];

        return DataRow(cells: getCells(cells));
      }).toList();
    }
  }

  List<DataCell> getCells(List<dynamic> cells) {
    // if (usersNotifier.value.isEmpty) {
    //   return List.generate(
    //     11,
    //     (index) => const DataCell(
    //       // usersNotifier.value.isEmpty
    //       //     ? LoadingAnimationWidget.hexagonDots(color: secondaryColor, size: 13)
    //       //     :
    //       Text(
    //         '',
    //         style: TextStyle(color: Colors.black, fontSize: 12),
    //       ),
    //     ),
    //   );
    // }
    return cells.map((data) {
      if (data == cells.last) {
        return DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: _statusColor(cells.last, cells[2]), borderRadius: BorderRadius.circular(15)),
            child: Text(
              // '$data',
              _status(cells.last, cells[2]),
              style: const TextStyle(color: Colors.white, fontSize: 10),
              // textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return DataCell(
        Text(
          '$data',
          style: const TextStyle(color: Colors.black, fontSize: 12),
          // textAlign: TextAlign.center,
        ),
      );
    }).toList();
  }

  Color? _statusColor(status, dataCheckInTime) {
    if (status == 'N' && dataCheckInTime != null && dataCheckInTime == '') {
      return Colors.green[600];
    } else if (status == 'N' && dataCheckInTime != null && dataCheckInTime != '') {
      return Colors.yellow[800];
    } else if (status == 'R') {
      return Colors.blue[600];
    } else if (status == 'O') {
      return Colors.purple[600];
    } else if (status == 'C') {
      return Colors.orange[900];
    } else {
      return Colors.red[600];
    }
  }


  String _status(status, dataCheckInTime) {
    if (status == 'N' && dataCheckInTime != null && dataCheckInTime == '') {
      return 'Check In';
    } else if (status == 'N' && dataCheckInTime != null && dataCheckInTime != '') {
      return 'Parked';
    } else if (status == 'R') {
      return 'Requested';
    } else if (status == 'O') {
      return 'On The Way';
    } else if (status == 'C') {
      return 'Collect Now';
    } else {
      return 'Check Out';
    }
  }

  void onSort(int columnIndex, bool ascending) {
    if (widget.item != null) {
      if (columnIndex == 0) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.barcode ?? '', user2.barcode ?? ''));
      } else if (columnIndex == 1) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.initialCheckinTime ?? '', user2.initialCheckinTime ?? ''));
      } else if (columnIndex == 2) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.dataCheckinTime ?? '', user2.dataCheckinTime ?? ''));
      } else if (columnIndex == 3) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.requestedTime ?? '', user2.requestedTime ?? ''));
      } else if (columnIndex == 4) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.onthewayTime ?? '', user2.onthewayTime ?? ''));
      } else if (columnIndex == 5) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.carModelName ?? '', user2.carModelName ?? ''));
      } else if (columnIndex == 6) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.carColorName ?? '', user2.carColorName ?? ''));
      } else if (columnIndex == 7) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.cvaInName ?? '', user2.cvaInName ?? ''));
      } else if (columnIndex == 8) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.emiratesName ?? '', user2.emiratesName ?? ''));
      } else if (columnIndex == 9) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.vehicleNumber ?? '', user2.vehicleNumber ?? ''));
      } else if (columnIndex == 10) {
        widget.item?.sort((user1, user2) => compareString(ascending, user1.checkoutStatus ?? 'N', user2.checkoutStatus ?? 'N'));
      }
    } else if (widget.item2 != null) {
      if (columnIndex == 0) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.barcode ?? '', user2.barcode ?? ''));
      } else if (columnIndex == 1) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.initialCheckinTime ?? '', user2.initialCheckinTime ?? ''));
      } else if (columnIndex == 2) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.dataCheckinTime ?? '', user2.dataCheckinTime ?? ''));
      } else if (columnIndex == 3) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.requestedTime ?? '', user2.requestedTime ?? ''));
      } else if (columnIndex == 4) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.onthewayTime ?? '', user2.onthewayTime ?? ''));
      } else if (columnIndex == 5) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.carModelName ?? '', user2.carModelName ?? ''));
      } else if (columnIndex == 6) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.carColorName ?? '', user2.carColorName ?? ''));
      } else if (columnIndex == 7) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.cvaInName ?? '', user2.cvaInName ?? ''));
      } else if (columnIndex == 8) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.emiratesName ?? '', user2.emiratesName ?? ''));
      } else if (columnIndex == 9) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.vehicleNumber ?? '', user2.vehicleNumber ?? ''));
      } else if (columnIndex == 10) {
        widget.item2?.sort((user1, user2) => compareString(ascending, user1.checkoutStatus ?? 'N', user2.checkoutStatus ?? 'N'));
      }
    } else if (widget.item3 != null) {
      if (columnIndex == 0) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.barcode ?? '', user2.barcode ?? ''));
      } else if (columnIndex == 1) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.initialCheckinTime ?? '', user2.initialCheckinTime ?? ''));
      } else if (columnIndex == 2) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.dataCheckinTime ?? '', user2.dataCheckinTime ?? ''));
      } else if (columnIndex == 3) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.requestedTime ?? '', user2.requestedTime ?? ''));
      } else if (columnIndex == 4) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.onthewayTime ?? '', user2.onthewayTime ?? ''));
      } else if (columnIndex == 5) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.carModelName ?? '', user2.carModelName ?? ''));
      } else if (columnIndex == 6) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.carColorName ?? '', user2.carColorName ?? ''));
      } else if (columnIndex == 7) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.cvaInName ?? '', user2.cvaInName ?? ''));
      } else if (columnIndex == 8) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.emiratesName ?? '', user2.emiratesName ?? ''));
      } else if (columnIndex == 9) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.vehicleNumber ?? '', user2.vehicleNumber ?? ''));
      } else if (columnIndex == 10) {
        widget.item3?.sort((user1, user2) => compareString(ascending, user1.checkoutStatus ?? 'N', user2.checkoutStatus ?? 'N'));
      }
    } else {
      if (columnIndex == 0) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.barcode ?? '', user2.barcode ?? ''));
      } else if (columnIndex == 1) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.initialCheckinTime ?? '', user2.initialCheckinTime ?? ''));
      } else if (columnIndex == 2) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.dataCheckinTime ?? '', user2.dataCheckinTime ?? ''));
      } else if (columnIndex == 3) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.requestedTime ?? '', user2.requestedTime ?? ''));
      } else if (columnIndex == 4) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.onthewayTime ?? '', user2.onthewayTime ?? ''));
      } else if (columnIndex == 5) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.carModelName ?? '', user2.carModelName ?? ''));
      } else if (columnIndex == 6) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.carColorName ?? '', user2.carColorName ?? ''));
      } else if (columnIndex == 7) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.cvaInName ?? '', user2.cvaInName ?? ''));
      } else if (columnIndex == 8) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.emiratesName ?? '', user2.emiratesName ?? ''));
      } else if (columnIndex == 9) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.vehicleNumber ?? '', user2.vehicleNumber ?? ''));
      } else if (columnIndex == 10) {
        widget.item4?.sort((user1, user2) => compareString(ascending, user1.checkoutStatus ?? 'N', user2.checkoutStatus ?? 'N'));
      }
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) => ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class _DashTopCard extends StatelessWidget {
  const _DashTopCard({
    required this.title,
    required this.count,
    required this.color,
    this.svgIcon,
    this.icon,
  });

  final String title;
  final String? svgIcon;
  final IconData? icon;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width / 5,
      width: 250,
      height: 150,
      margin: const EdgeInsets.only(right: 45),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey[300]!, offset: const Offset(1, 1), spreadRadius: .5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: icon == null
                    ? SvgPicture.asset(
                        svgIcon!,
                        // color: Colors.white54,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        height: 30,
                      )
                    : Icon(icon, size: 24, color: color),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            count,
            style: const TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }
}
