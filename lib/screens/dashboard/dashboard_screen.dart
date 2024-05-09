// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:admin_panel/data/checkin_model.dart';
import 'package:admin_panel/models/user.dart';
import 'package:admin_panel/screens/widgets/scrollable_widget.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'components/header.dart';

final usersNotifier = ValueNotifier<List<CheckInModel>>([]);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // var isLoading = true;

  // @override
  // void didChangeDependencies() {
  //   customLoader(context);
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Future.delayed(
  //       const Duration(milliseconds: 300),
  //       () => setState(() {
  //         isLoading = false;
  //         Loader.hide();
  //       }),
  //     );
  //   });
  //   super.didChangeDependencies();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          // padding: EdgeInsets.all(defaultPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
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
                        count: '1584',
                        color: Colors.brown[900]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allUsers;
                            usersNotifier.notifyListeners();
                          },
                        );
                      }),
                      _DashTopCard(
                        title: 'Check In',
                        svgIcon: 'assets/icons/key_exchange.svg',
                        count: '22',
                        color: Colors.green[600]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allCheckedInUsers;
                            usersNotifier.notifyListeners();
                          },
                        );
                      }),
                      _DashTopCard(
                        title: 'Parked',
                        // svgIcon: 'assets/icons/checkout.svg',
                        icon: Icons.local_parking_rounded,
                        count: '15',
                        color: Colors.yellow[800]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allParkedInUsers;
                            usersNotifier.notifyListeners();
                          },
                        );
                      }),
                      _DashTopCard(
                        title: 'Requested',
                        // svgIcon: 'assets/icons/inventory.svg',
                        icon: FontAwesomeIcons.registered,
                        count: '1584',
                        color: Colors.blue[600]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allRequestedInUsers;
                            usersNotifier.notifyListeners();
                          },
                        );
                      }),
                      _DashTopCard(
                        title: 'On The Way',
                        // svgIcon: 'assets/icons/checkin.svg',
                        icon: FontAwesomeIcons.route,
                        count: '22',
                        color: Colors.purple[600]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allOnthewayUsers;
                            usersNotifier.notifyListeners();
                          },
                        );
                      }),
                      _DashTopCard(
                        title: 'Collect Now',
                        svgIcon: 'assets/icons/checkin.svg',
                        count: '15',
                        color: Colors.orange[900]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allVehicleArrivedUsers;
                            usersNotifier.notifyListeners();
                          },
                        );
                      }),
                      _DashTopCard(
                        title: 'Check Out',
                        // svgIcon: 'assets/icons/checkout.svg',
                        icon: FontAwesomeIcons.caravan,
                        count: '15',
                        color: Colors.red[900]!,
                      ).ripple(context, overlayColor: Colors.transparent, () {
                        usersNotifier.value = [];
                        usersNotifier.notifyListeners();
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            usersNotifier.value = allCheckedOutUsers;
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
            ),
          ),
        );
      }),
    );
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
                          allCheckedInUsers.length.toString(),
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

  @override
  void initState() {
    super.initState();
    print('12222222222222222222222222222222222');
    if (mounted) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          usersNotifier.value = allCheckedInUsers;
          usersNotifier.notifyListeners();
        },
      );
    }
  }

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

  List<DataRow> getRows(List<CheckInModel> users) {
    if (users.isEmpty) {
      return List.generate(1, (index) => DataRow(cells: getCells(['', '', '', '', '', '', '', '', '', '', ''])));
    }
    return users.map((CheckInModel user) {
      final cells = [
        user.ticketNo,
        user.checkinTime,
        user.checkinUpdationTime,
        user.requestTime,
        user.onTheWayTime,
        user.carBrand,
        user.carColour,
        user.cvaIn,
        user.emirates,
        user.plateNo,
        user.status,
      ];

      return DataRow(cells: getCells(cells));
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) {
    if (usersNotifier.value.isEmpty) {
      return List.generate(
          11,
          (index) => DataCell(Skeletonizer(
                effect: const ShimmerEffect(),
                enabled: usersNotifier.value.isEmpty,
                containersColor: Colors.grey[100],
                child: const Text(
                  'data',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
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
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.ticketNo, user2.ticketNo));
    } else if (columnIndex == 1) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.checkinTime, user2.checkinTime));
    } else if (columnIndex == 2) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.checkinUpdationTime, user2.checkinUpdationTime));
    } else if (columnIndex == 3) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.requestTime, user2.requestTime));
    } else if (columnIndex == 4) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.onTheWayTime, user2.onTheWayTime));
    } else if (columnIndex == 5) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.carBrand, user2.carBrand));
    } else if (columnIndex == 6) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.carColour, user2.carColour));
    } else if (columnIndex == 7) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.cvaIn, user2.cvaIn));
    } else if (columnIndex == 8) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.emirates, user2.emirates));
    } else if (columnIndex == 9) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.plateNo, user2.plateNo));
    } else if (columnIndex == 10) {
      usersNotifier.value.sort((user1, user2) => compareString(ascending, user1.status, user2.status));
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
