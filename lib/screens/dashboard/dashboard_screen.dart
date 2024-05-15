// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:admin_panel/data/checkin_model.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/models/new/dashboard/dashboard_resp_model.dart';
import 'package:admin_panel/models/old/user.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:admin_panel/screens/widgets/scrollable_widget.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'components/header.dart';

// final usersNotifier = ValueNotifier<List<CheckInModel>>([]);
final usersNotifier = ValueNotifier<List<ActiveTickets>>([]);

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
      drawer: SideMenu(),
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
    final dashBloc = Provider.of<DashboardBloc>(context, listen: false);
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
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
                    usersNotifier.value = ticketsList;
                    usersNotifier.notifyListeners();
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
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allUsers;
                                  usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Check In',
                              svgIcon: 'assets/icons/key_exchange.svg',
                              count: totalCounCheckIn.toString(),
                              color: Colors.green[600]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allCheckedInUsers;
                                   usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
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
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allParkedInUsers;
                                   usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
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
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allRequestedInUsers;
                                   usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
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
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allOnthewayUsers;
                                   usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
                                },
                              );
                            }),
                            _DashTopCard(
                              title: 'Collect Now',
                              svgIcon: 'assets/icons/checkin.svg',
                              count: totalCountCollectnow.toString(),
                              color: Colors.orange[900]!,
                            ).ripple(context, overlayColor: Colors.transparent, () {
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allVehicleArrivedUsers;
                                   usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
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
                              usersNotifier.value = [];
                              usersNotifier.notifyListeners();
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  // usersNotifier.value = allCheckedOutUsers;
                                   usersNotifier.value = ticketsList!.where((e) => e.checkoutStatus == 'N').toList();
                                  usersNotifier.notifyListeners();
                                },
                              );
                            }),
                          ],
                        ),

                        // Butt

                        // Table
                        const _Table(),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  ValueListenableBuilder(
                    valueListenable: usersNotifier,
                    builder: (context, list,_) {
                      return Container(
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
                              usersNotifier.value.length.toString(),
                              // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                              style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      );
                    }
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
                child: const SortablePage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortablePage extends StatefulWidget {
  const SortablePage({super.key});
  

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  // List<CheckInModel> users = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late var timer;

  // @override
  // void initState() {
  //   super.initState();
  //   print('12222222222222222222222222222222222');
  //   if (mounted) {
  //     Future.delayed(
  //       const Duration(seconds: 2),
  //       () {
  //         // usersNotifier.value = allCheckedInUsers;
  //         usersNotifier.notifyListeners();
  //       },
  //     );
  //   }
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     // if (mounted) {
  //     //   timer = Timer.periodic(
  //     //     const Duration(seconds: 2),
  //     //     (Timer t) {
  //     //       usersNotifier.value = allCheckedInUsers;
  //     //       usersNotifier.notifyListeners();
  //     //     },
  //     //   );
  //     // }
  //   // });
  // }

  // @override
  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => ScrollableWidget(child: buildDataTable());

  Widget buildDataTable() {
    final columns = ['Ticket No.', 'Checkin Time', 'Checkin Updation Time', 'Request Time', 'On the way Time', 'Car Brand', 'Car Colour', 'CVA-In', 'Emirates', 'Plate No.', 'Status'];

    return ValueListenableBuilder(
        valueListenable: usersNotifier,
        builder: (context, list, _) {
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
            rows: getRows(usersNotifier.value),
            // decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[400]!)),
          );
        });
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

  List<DataRow> getRows(List<ActiveTickets> users) {
    if (users.isEmpty) {
      return List.generate(1, (index) => DataRow(cells: getCells(['', '', '', '', '', '', '', '', '', '', ''])));
    }
    return users.map((ActiveTickets user) {
      final cells = [
        user.barcode ?? '',
        user.initialCheckinTime ?? '',
        user.dataCheckinTime ?? '',
        user.requestedTime ?? '',
        user.onthewayTime ?? '',
        user.carModelName ?? '',
        user.carColorName ??'',
        user.cvaInName ?? '',
        user.emiratesName ?? '',
        user.vehicleNumber ?? '',
        user.checkoutStatus ?? 'N',
      ];

      return DataRow(cells: getCells(cells));
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) {
    if (usersNotifier.value.isEmpty) {
      return List.generate(
          11,
          (index) => DataCell(usersNotifier.value.isEmpty ? LoadingAnimationWidget.hexagonDots(color: secondaryColor, size: 13) : const Text(
                'data',
                style: TextStyle(color: Colors.black, fontSize: 12),
              )));
    }
    return cells.map((data) {
      if (data == cells.last) {
        return DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: _statusColor(data), borderRadius: BorderRadius.circular(15)),
            child: Text(
              '$data',
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

  Color? _statusColor(data) {
    if (data == 'Checked In') {
      return Colors.green[600];
    } else if (data == 'Parked') {
      return Colors.yellow[700];
    } else if (data == 'Requested') {
      return Colors.blue[600];
    } else if (data == 'On The Way') {
      return Colors.purple[600];
    } else if (data == 'Vehicle Arrived') {
      return Colors.orange[900];
    } else {
      return Colors.red[600];
    }
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.barcode ?? '',user1.barcode ?? ''));
    } else if (columnIndex == 1) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.initialCheckinTime ?? '', user1.initialCheckinTime ?? ''));
    } else if (columnIndex == 2) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending,user1.dataCheckinTime ?? '', user1.dataCheckinTime ?? ''));
    } else if (columnIndex == 3) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.requestedTime ?? '', user2.requestedTime ?? ''));
    } else if (columnIndex == 4) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.onthewayTime ?? '', user2.onthewayTime ?? ''));
    } else if (columnIndex == 5) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.carModelName ?? '', user2.carModelName ?? ''));
    } else if (columnIndex == 6) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.carColorName ?? '', user2.carColorName ?? ''));
    } else if (columnIndex == 7) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.cvaInName ?? '', user2.cvaInName ?? ''));
    } else if (columnIndex == 8) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.emiratesName ?? '', user2.emiratesName ?? ''));
    } else if (columnIndex == 9) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.vehicleNumber ?? '', user2.vehicleNumber ?? ''));
    } else if (columnIndex == 10) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.checkoutStatus ?? 'N', user2.checkoutStatus ?? 'N'));
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
