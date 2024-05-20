import 'dart:async';

import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/logic/report/navigation_report_bloc.dart';
// import 'package:admin_panel/logic/report/master_report_bloc.dart';
// import 'package:admin_panel/logic/search/search_bloc.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/old/user.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:admin_panel/screens/report/filter_field.dart';
import 'package:admin_panel/screens/widgets/custom_dropdown.dart';
import 'package:admin_panel/screens/widgets/scrollable_widget.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:admin_panel/utils/debouncer.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

final searchListNotifier = BehaviorSubject<List<TicketsList>>.seeded([]);
final searchListRespmodelNotifier = BehaviorSubject<GetAllTicketsResponse?>();
final isSearchListNotifierAlongWithSearchKey = BehaviorSubject<bool>.seeded(false);
final filterValue = BehaviorSubject<String>.seeded('');

final _filterController = TextEditingController();
final _controller = TextEditingController();

final selectedStartDate = ValueNotifier<DateTime?>(null);
final selectedEndDate = ValueNotifier<DateTime?>(null);

ValueNotifier<int> currentPageForInventoryReport = ValueNotifier(1);

class InventoryReport extends StatefulWidget {
  const InventoryReport({
    super.key,
  });

  @override
  State<InventoryReport> createState() => _InventoryReportState();
}

class _InventoryReportState extends State<InventoryReport> with WidgetsBindingObserver {
  NavigationReportBloc? bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    context.read<NavigationReportBloc>().mainSearchStream.listen((value) {
      if (value.isEmpty) {
        _controller.clear();
      } else if (_controller.text != value) {
        _controller.text = value;
        filterValue.add(value);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in the background (paused)
      print('App is paused');
      Loader.hide();
    } else if (state == AppLifecycleState.resumed) {
      // App is in the foreground (resumed)
      print('App is resumed');
      Loader.hide();
    } else if (state == AppLifecycleState.inactive) {
      // App is inactive (probably transitioning between states)
      print('App is inactive');
    } else if (state == AppLifecycleState.detached) {
      // App is detached (could be closing)
      print('App is detached');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc ??= Provider.of<NavigationReportBloc>(context);
    bloc?.clearSreams();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await bloc!.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: 1);
      await bloc!.getAllCheckInItems();
    });
  }

  final ScrollController _scrollController = ScrollController();
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
            Expanded(
              flex: 7,
              child: _Body(scrollController: _scrollController),
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
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _AllTicketsSection(scrollController: scrollController),
        // _NewCheckInForm(),

        // Header
        const Header(),
      ],
    );
  }
}

class _PlateTextField extends StatefulWidget {
  const _PlateTextField({
    // required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.width = 0,
    this.textAlign,
    this.contentPadding,
    this.hintStyle,
  });

  // final BehaviorSubject<String> textStream;
  final void Function(String) onTextChanged;
  final String hintText;
  final TextInputType keyboardType;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final double width;

  @override
  State<_PlateTextField> createState() => _PlateTextFieldState();
}

class _PlateTextFieldState extends State<_PlateTextField> {
  // final _controller = TextEditingController();
  // @override
  // void initState() {
  //   widget.textStream.listen((value) {
  //     if (value.isEmpty) {
  //       _controller.clear();
  //     } else if (_controller.text != value) {
  //       _controller.text = value;
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15 * 6, // Adjust the value as needed
        ),
        // controller: _controller,
        onChanged: widget.onTextChanged,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        textAlign: widget.textAlign ?? TextAlign.left,
        decoration: InputDecoration(
          hintText: widget.hintText,
          // hintStyle: TextStyle(fontSize: 12),
          hintStyle: widget.hintStyle ??
              GoogleFonts.openSans().copyWith(
                color: Colors.grey[700],
                fontSize: 10.5,
              ),
          // contentPadding: EdgeInsets.only(left: 15),
          contentPadding: widget.contentPadding ?? const EdgeInsets.only(top: 5),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(146, 146, 69, 197),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              // color: Color.fromARGB(255, 80, 19, 121),
              color: Color.fromARGB(146, 146, 69, 197),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllTicketsSection extends StatelessWidget {
  const _AllTicketsSection({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          controller: scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter
                  // const _CustomExpansionTile(),

                  // Table
                  _Table(scrollController: scrollController)
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
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final searchBloc = Provider.of<NavigationReportBloc>(context);
    final dashBloc = Provider.of<DashboardBloc>(context);

    // For Ipad
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final largeDev = (screenHeight > 1100) && (screenWidth > 800);
    return StreamBuilder(
        stream: dashBloc.getSettingsStream,
        builder: (context, settingsSnapshot) {
          final settings = settingsSnapshot.data;
          final commonScrollMessage = settings?.data?.commonScrollMessage;
          final scrollMessage = settings?.data?.scrollMessage;
          final appMaintenanceMode = settings?.data?.appMaintenanceMode;
          final maintenanceMode = settings?.data?.maintenanceMode;
          // final appEndDate = settings?.data.appEndDate;
          final appEndDate = DateTime.parse(StorageServices.to.getString('appEndDate'));
          // final isExpired = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())).isAfter(appEndDate);
          final difference = appEndDate.difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())));
          final daysRemaining = difference.inDays;
          final endDateMsg = 'Your subscription will end on ${StorageServices.to.getString('appEndDate')} ($daysRemaining days). Kindly Renew it.';
          // print('2222222222222222222222222222 ${daysRemaining}');
          if (settingsSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 32),
                  const Text(
                    'Loading ...',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }
          if (appMaintenanceMode == 'ON' || maintenanceMode == 'ON') {
            return Column(
              mainAxisAlignment:
                  (commonScrollMessage != null && commonScrollMessage.isNotEmpty) || (scrollMessage != null && scrollMessage.isNotEmpty) ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                // const Spacer(),
                if ((commonScrollMessage != null && commonScrollMessage.isNotEmpty) || (scrollMessage != null && scrollMessage.isNotEmpty)) const SizedBox(height: 70),
                Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(right: 15),
                  child: Image.asset('assets/images/under_maintenance.png', width: 200),
                ),
                const SizedBox(height: 10),
                Text(
                  // 'Ooops!',
                  'App is under maintenance',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans().copyWith(color: Colors.purple, fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                // Text(
                //   'App is under maintenance',
                //   textAlign: TextAlign.center,
                //   style: GoogleFonts.openSans().copyWith(color: Colors.black, fontSize: 20 fontWeight: FontWeight.w800),
                // ),
                const SizedBox(height: 10),
                Text(
                  'WE WILL COMING BACK SOON',
                  style: GoogleFonts.openSans().copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),
                ),
                // SizedBox(height: 25),
                // const Spacer(),
                const SizedBox(height: 50),
                if (daysRemaining <= 15)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[100]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Marquee(
                      text: endDateMsg,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      scrollAxis: Axis.horizontal,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: endDateMsg.length.toDouble(),
                      velocity: 30,
                      //pauseAfterRound: const Duration(milliseconds: 500),
                      startPadding: 10,
                      accelerationDuration: const Duration(milliseconds: 500),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                if (commonScrollMessage != null && commonScrollMessage.isNotEmpty)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[100]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Marquee(
                      text: commonScrollMessage,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      scrollAxis: Axis.horizontal,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: commonScrollMessage.length.toDouble(),
                      velocity: 30,
                      //pauseAfterRound: const Duration(milliseconds: 500),
                      startPadding: 10,
                      accelerationDuration: const Duration(milliseconds: 500),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                if (commonScrollMessage != null && commonScrollMessage.isEmpty && scrollMessage != null && scrollMessage.isNotEmpty)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[100]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Marquee(
                      text: scrollMessage,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      scrollAxis: Axis.horizontal,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: scrollMessage.length.toDouble(),
                      velocity: 30,
                      //pauseAfterRound: const Duration(milliseconds: 500),
                      startPadding: 10,
                      accelerationDuration: const Duration(milliseconds: 500),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
              ],
            );
          }
          return StreamBuilder(
              stream: searchBloc.getAllTicketsRespStream,
              builder: (context, snapshot) {
                // //print('4444444444444444444 ${snapshot.hasData}');
                //print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 32),
                        const Text('Tickets Fetching From Server', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final allTickets = snapshot.data;
                  final list = allTickets?.data?.ticketsList?.where((e) {
                    if (e.checkoutStatus == 'Y') {
                      return false;
                    }
                    return true;
                  }).toList();
                  final sampleList = ValueNotifier<List<TicketsList>>(list ?? []);
                  return Expanded(
                    child: Column(
                      children: [
                        _CustomExpansionTile(allTickets),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40, top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: secondaryColor2)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.download_for_offline_outlined, color: secondaryColor2),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Download'.toUpperCase(),
                                              // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                                              style: GoogleFonts.poppins().copyWith(color: secondaryColor2, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(color: secondaryColor2, borderRadius: BorderRadius.circular(10)),
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
                                            StreamBuilder(
                                                stream: searchListNotifier,
                                                builder: (context, searchSnapshot) {
                                                  return Text(
                                                    // '50',
                                                    // allUsers.length.toString(),
                                                    (searchListNotifier.value.isEmpty && filterValue.value.isEmpty)
                                                        ? sampleList.value.length.toString()
                                                        : (searchListNotifier.value.isEmpty ? '0' : searchListNotifier.value.length.toString()),
                                                    // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                                                    style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 25),

                                StreamBuilder(
                                    stream: searchListNotifier,
                                    builder: (context, searchSnapshot) {
                                      return Expanded(
                                        child: Container(
                                          // padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                          // margin: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 40),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey[200]!),
                                            // borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: SortablePage(
                                              allTickets: allTickets,
                                              sampleList: sampleList,
                                              list: (searchListNotifier.value.isEmpty && filterValue.value.isEmpty)
                                                  ? sampleList.value
                                                  : (searchListNotifier.value.isEmpty ? null : searchListNotifier.value)),
                                        ),
                                      );
                                    }),

                                StreamBuilder(
                                  stream: searchListNotifier,
                                  builder: (context, searchSnapshot) {
                                    // return (searchListNotifier.value.isEmpty && searchBloc.barcodeStream.value.isEmpty)
                                    print('akfhasfasfdsalog ${searchSnapshot.data}');
                                    return (searchListNotifier.value.isEmpty && filterValue.value.isEmpty)
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // ...List.generate(20, (index) {
                                                  ...List.generate(allTickets?.data?.totalPages ?? 0, (index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                                      child: ValueListenableBuilder(
                                                        valueListenable: currentPageForInventoryReport,
                                                        builder: (context, ix, _) {
                                                          return Container(
                                                            height: 22,
                                                            width: 22,
                                                            decoration: BoxDecoration(
                                                              color: index + 1 != currentPageForInventoryReport.value ? Colors.grey : Colors.purple[400],
                                                              borderRadius: BorderRadius.circular(50),
                                                            ),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                Loader.show(
                                                                  context,
                                                                  progressIndicator: LoadingAnimationWidget.fallingDot(color: secondaryColor2, size: 40),
                                                                );
                                                                //print('object');
                                                                final isLoading = await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);
                                                                currentPageForInventoryReport.value = index + 1;
                                                                currentPageForInventoryReport.notifyListeners();

                                                                if (isLoading) {
                                                                  Future.delayed(const Duration(seconds: 1), () {
                                                                    scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                    currentPageForInventoryReport.value = index + 1;
                                                                    currentPageForInventoryReport.notifyListeners();
                                                                    Loader.hide();
                                                                  });
                                                                } else {
                                                                  // ignore: unawaited_futures
                                                                  scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                  currentPageForInventoryReport.value = index + 1;
                                                                  currentPageForInventoryReport.notifyListeners();
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
                                          )
                                        // : const SizedBox.shrink();
                                        : StreamBuilder(
                                            stream: isSearchListNotifierAlongWithSearchKey,
                                            builder: (context, isSearchListNotifierAlongWithSearchKeySnapshot) {
                                              final isSearchListAlongWithSearchKey = isSearchListNotifierAlongWithSearchKeySnapshot.data ?? false;
                                              return StreamBuilder(
                                                stream: searchListRespmodelNotifier,
                                                builder: (context, snapshot) {
                                                  print('22222222222222222 ${snapshot.data?.data?.totalPages}');
                                                  return StreamBuilder(
                                                    stream: searchBloc.getAllCheckInItemsStream,
                                                    builder: (context, getAllCheckInItemsStreamsSnapshot) {
                                                      final checkInitems = getAllCheckInItemsStreamsSnapshot.data;
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              // ...List.generate(20, (index) {
                                                              ...List.generate(snapshot.data?.data?.totalPages ?? 0, (index) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                                                  child: ValueListenableBuilder(
                                                                    valueListenable: currentPageForInventoryReport,
                                                                    builder: (context, ix, _) {
                                                                      return Container(
                                                                        height: 22,
                                                                        width: 22,
                                                                        decoration: BoxDecoration(
                                                                          color: index + 1 != currentPageForInventoryReport.value ? Colors.grey : Colors.purple[400],
                                                                          borderRadius: BorderRadius.circular(50),
                                                                        ),
                                                                        child: InkWell(
                                                                          onTap: () async {
                                                                            Loader.show(
                                                                              context,
                                                                              progressIndicator: LoadingAnimationWidget.fallingDot(color: secondaryColor2, size: 40),
                                                                            );
                                                                            //print('object');
                                                                            // final isLoading = await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: index + 1);

                                                                            String? formattedStartDate;
                                                                            String? formattedEndDate;
                                                                            if (selectedStartDate.value != null) {
                                                                              formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedStartDate.value!);
                                                                            } else if (selectedEndDate.value != null && selectedStartDate.value == null) {
                                                                              // await toastInfo(
                                                                              //   msg: 'Please Select Start Date',
                                                                              //   gravity: ToastGravity.BOTTOM,
                                                                              // );
                                                                              await warningMotionToastInfo(context, msg: 'Please Select Start Date');
                                                                              Loader.hide();
                                                                              return;
                                                                            }
                                                                            if (selectedEndDate.value != null) {
                                                                              formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedEndDate.value!);
                                                                            } else if (selectedEndDate.value == null && selectedStartDate.value != null) {
                                                                              // await toastInfo(
                                                                              //   msg: 'Please Select End Date',
                                                                              //   gravity: ToastGravity.BOTTOM,
                                                                              // );
                                                                              await warningMotionToastInfo(context, msg: 'Please Select End Date');
                                                                              Loader.hide();
                                                                              return;
                                                                            }

                                                                            final brandId = checkInitems?.data?.carModels
                                                                                ?.where((e) => e.modelTitle == searchBloc.vehicleModelStream.value)
                                                                                .firstOrNull
                                                                                ?.modelId;
                                                                            final colorId = checkInitems?.data?.carColors
                                                                                ?.where((e) => e.carTitle == searchBloc.vehicleColorStream.value)
                                                                                .firstOrNull
                                                                                ?.carId;
                                                                            final emiratesId = checkInitems?.data?.vehicleLocations
                                                                                ?.where((e) => e.vehicleLocationName == searchBloc.vehicleLocationStream.value)
                                                                                .firstOrNull
                                                                                ?.vehicleLocationId;
                                                                            final outletId = checkInitems?.data?.outlets
                                                                                ?.where((e) => e.outletPostName == searchBloc.outletsStream.value)
                                                                                .firstOrNull
                                                                                ?.outletPostId;
                                                                            final cvaInId = checkInitems?.data?.cvas
                                                                                ?.where((e) => e.departmentName == searchBloc.cvaInStream.value)
                                                                                .firstOrNull
                                                                                ?.departmentId;
                                                                            final cvaOutId = checkInitems?.data?.cvas
                                                                                ?.where((e) => e.departmentName == searchBloc.cvaOutStream.value)
                                                                                .firstOrNull
                                                                                ?.departmentId;
                                                                            final locationId = allTickets?.data?.locationsList!
                                                                                .where((e) => e.departmentName == searchBloc.locationStream.value)
                                                                                .firstOrNull
                                                                                ?.departmentId;
                                                                            final userId = allTickets?.data?.usersList!
                                                                                .where((e) => e.departmentName == searchBloc.userTypeStream.value)
                                                                                .firstOrNull
                                                                                ?.departmentId;

                                                                            if (isSearchListAlongWithSearchKey) {
                                                                              final respModel =
                                                                                  await searchBloc.getTicketsWithSearchKey(orderBy: 'parking_time', searchKey: filterValue.value, pageNo: 1);
                                                                              final list = respModel?.data?.ticketsList ?? [];

                                                                              currentPageForInventoryReport.value = 1;
                                                                              currentPageForInventoryReport.notifyListeners();

                                                                              if (_controller.text.isEmpty) {
                                                                                searchListNotifier.add([]);
                                                                              }

                                                                              searchListNotifier.add(list);

                                                                              isSearchListNotifierAlongWithSearchKey.add(true);

                                                                              currentPageForInventoryReport.value = index + 1;
                                                                              currentPageForInventoryReport.notifyListeners();
                                                                            } else {
                                                                              final respModel = await searchBloc.getTicketsWithCombinations(
                                                                                orderBy: 'parking_time',
                                                                                checkOutStatus: searchBloc.statusStream.value,
                                                                                parkingLocationId: locationId ?? 0,
                                                                                locationUserId: userId ?? 0,
                                                                                cvaOut: cvaOutId ?? 0,
                                                                                cvaIn: cvaInId ?? 0,
                                                                                outletId: outletId ?? 0,
                                                                                emiratesId: emiratesId ?? 0,
                                                                                vehicleColorlId: colorId ?? 0,
                                                                                vehicleModelId: brandId ?? 0,
                                                                                startDate: formattedStartDate ?? '',
                                                                                endDate: formattedEndDate ?? '',
                                                                                mobileNumber: searchBloc.mobileNumberStream.value,
                                                                                vehicleNumber: searchBloc.plateNumberStream.value,
                                                                                barcode: searchBloc.barcodeStream.value,
                                                                                pageNo: index + 1,
                                                                              );

                                                                              final list = respModel?.data?.ticketsList!;

                                                                              if (_filterController.text.isEmpty) {
                                                                                searchListNotifier.add([]);
                                                                              }

                                                                              searchListNotifier.add(list ?? []);

                                                                              isSearchListNotifierAlongWithSearchKey.add(false);

                                                                              currentPageForInventoryReport.value = index + 1;
                                                                              currentPageForInventoryReport.notifyListeners();
                                                                            }

                                                                            // if (isLoading) {
                                                                            //   Future.delayed(const Duration(seconds: 1), () {
                                                                            //     _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                            //     currentPageForInventoryReport.value = index + 1;
                                                                            //     currentPageForInventoryReport.notifyListeners();
                                                                            //     Loader.hide();
                                                                            //   });
                                                                            // } else {
                                                                            //   // ignore: unawaited_futures
                                                                            //   _scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                            //   currentPageForInventoryReport.value = index + 1;
                                                                            //   currentPageForInventoryReport.notifyListeners();
                                                                            //   Loader.hide();
                                                                            // }

                                                                            // ignore: unawaited_futures
                                                                            scrollController.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
                                                                            currentPageForInventoryReport.value = index + 1;
                                                                            currentPageForInventoryReport.notifyListeners();
                                                                            Loader.hide();
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
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  Loader.hide();
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Something went wrong',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple[100]!),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 17),
                              SizedBox(width: 5),
                              Text('Refresh', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ).ripple(
                          context,
                          () async {
                            await searchBloc.getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: 1);
                          },
                          borderRadius: BorderRadius.circular(15),
                          overlayColor: Colors.purple.withOpacity(.15),
                        ),
                      ],
                    ),
                  );
                }
              });
        });
  }
}

class SortablePage extends StatefulWidget {
  const SortablePage({super.key, required this.sampleList, this.list, this.allTickets});

  final ValueNotifier<List<TicketsList>> sampleList;
  final List<TicketsList>? list;
  final GetAllTicketsResponse? allTickets;

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  List<CheckInModel> users = [];
  int? sortColumnIndex;
  bool isAscending = false;
  // late var timer;

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (mounted) {
  //       timer = Timer.periodic(
  //         const Duration(seconds: 2),
  //         (Timer t) {
  //           setState(() {
  //             users = List.of(allUsers);
  //           });
  //         },
  //       );
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: widget.sampleList,
      builder: (context, newList, _) {
        return StreamBuilder(
            stream: searchListNotifier,
            builder: (context, searchSnapshot) {
              if (searchListNotifier.value.isEmpty && filterValue.value != '') {
                return const Center(
                    child: Text(
                  'No Data Found!!',
                  style: TextStyle(color: secondaryColor2, fontWeight: FontWeight.w900, fontSize: 16),
                ));
              } else {
                return ScrollableWidget(child: buildDataTable());
              }
            });
      });

  Widget buildDataTable() {
    final columns = ['Ticket No.', 'Checkin Time', 'Checkin Updation Time', 'Request Time', 'On the way Time', 'Car Brand', 'Car Colour', 'CVA-In', 'Emirates', 'Plate No.', 'Status'];

    return DataTable(
      headingRowColor: MaterialStateProperty.all(secondaryColor2),
      // headingRowColor: MaterialStateProperty.all(Color(0xFFFBFCFC)),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      dividerThickness: .1,
      dataRowMaxHeight: 50,
      onSelectAll: (value) {},
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
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

  List<DataRow> getRows() {
    // if (users.isEmpty) {
    //   return List.generate(1, (index) => DataRow(cells: getCells(['', '', '', '', '', '', '', '', '', '', ''])));
    // }
    return widget.list!.map((TicketsList user) {
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

  List<DataCell> getCells(List<dynamic> cells) {
    // if (usersNotifier.value.isEmpty) {
    //   return List.generate(
    //     11,
    //     (index) => const DataCell(
    //       // usersNotifier.value.isEmpty
    //       //     ? LoadingAnimationWidget.hexagonDots(color: secondaryColor2, size: 13)
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
    if (columnIndex == 0) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.barcode ?? '', user2.barcode ?? ''));
    } else if (columnIndex == 1) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.initialCheckinTime ?? '', user2.initialCheckinTime ?? ''));
    } else if (columnIndex == 2) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.dataCheckinTime ?? '', user2.dataCheckinTime ?? ''));
    } else if (columnIndex == 3) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.requestedTime ?? '', user2.requestedTime ?? ''));
    } else if (columnIndex == 4) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.onthewayTime ?? '', user2.onthewayTime ?? ''));
    } else if (columnIndex == 5) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.carModelName ?? '', user2.carModelName ?? ''));
    } else if (columnIndex == 6) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.carColorName ?? '', user2.carColorName ?? ''));
    } else if (columnIndex == 7) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.cvaInName ?? '', user2.cvaInName ?? ''));
    } else if (columnIndex == 8) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.emiratesName ?? '', user2.emiratesName ?? ''));
    } else if (columnIndex == 9) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.vehicleNumber ?? '', user2.vehicleNumber ?? ''));
    } else if (columnIndex == 10) {
      widget.list?.sort((user1, user2) => compareString(ascending, user1.checkoutStatus ?? 'N', user2.checkoutStatus ?? 'N'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) => ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class _CustomExpansionTile extends StatefulWidget {
  const _CustomExpansionTile(this.allTickets);
  final GetAllTicketsResponse? allTickets;

  @override
  State<_CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<_CustomExpansionTile> {
  bool showAllIcons = true;

  @override
  Widget build(BuildContext context) {
    List<String> checkOutStatusStaticList = ['', 'CheckIn', 'Requested', 'On The Way', 'Collect Now', 'Parked'];
    Map<String, String> checkOutStatusStaticListMappingToSymbol = {'': '', 'CheckIn': 'N', 'Requested': 'R', 'On The Way': 'O', 'Collect Now': 'C', 'Parked': 'P'};
    Map<String, String> checkOutStatusStaticListMappingToName = {'': '', 'N': 'CheckIn', 'R': 'Requested', 'O': 'On The Way', 'C': 'Collect Now', 'P': 'Parked'};
    final bloc = Provider.of<NavigationReportBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,

          // iconTheme: IconThemeData(color: Colors.red)
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              if (!value && searchListNotifier.value.isNotEmpty && filterValue.value.isNotEmpty) {
                Loader.show(
                  context,
                  progressIndicator: LoadingAnimationWidget.fallingDot(color: secondaryColor2, size: 40),
                );
                Future.delayed(
                  const Duration(milliseconds: 700),
                  () async {
                    currentPageForInventoryReport.value = 1;
                    currentPageForInventoryReport.notifyListeners();

                    await context.read<NavigationReportBloc>().getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: 1);

                    isSearchListNotifierAlongWithSearchKey.add(false);

                    _controller.text = '';
                    filterValue.add('');
                    // filterValue.add(_controller.text);
                    selectedStartDate.value = null;
                    selectedStartDate.notifyListeners();
                    selectedEndDate.value = null;
                    selectedEndDate.notifyListeners();
                    bloc.barcodeStream.add('');
                    bloc.plateNumberStream.add('');
                    bloc.vehicleModelStream.add('');
                    bloc.vehicleColorStream.add('');
                    bloc.mobileNumberStream.add('');

                    bloc.vehicleLocationStream.add('');
                    bloc.outletsStream.add('');
                    bloc.cvaInStream.add('');
                    bloc.cvaOutStream.add('');
                    bloc.userTypeStream.add('');
                    bloc.locationStream.add('');

                    bloc.statusStream.add('');

                    searchListNotifier.add([]);

                    Loader.hide();
                  },
                );
              }
            },
            // trailing: const SizedBox.shrink(),
            iconColor: secondaryColor2,
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: secondaryColor2,
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: secondaryColor2, size: 20),
                  const SizedBox(width: 30),
                  Text(
                    'Searching Filter'.toUpperCase(),
                    style: GoogleFonts.poppins().copyWith(color: secondaryColor2, fontSize: 14, fontWeight: FontWeight.bold),
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            children: [
              Container(
                height: 170,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                child: StreamBuilder(
                    stream: bloc.getAllCheckInItemsStream,
                    builder: (context, getAllCheckInItemsStreamsnapshot) {
                      final checkInitems = getAllCheckInItemsStreamsnapshot.data;
                      return Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: selectedStartDate,
                            builder: (context, startDate, _) {
                              return SizedBox(
                                // width: MediaQuery.of(context).size.width / 2.3,
                                width: MediaQuery.of(context).size.width / 5,
                                height: 35,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // color: Colors.white,
                                    border: Border.all(
                                      // color: Colors.grey,
                                      // color: const Color.fromARGB(146, 146, 69, 197),
                                      color: Colors.purple.withOpacity(.1),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    selectedStartDate.value == null ? 'Select Start Date' : DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedStartDate.value!),
                                    style: GoogleFonts.openSans().copyWith(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ).ripple(context, () => _selectDate(context, selectedStartDate));
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: selectedEndDate,
                            builder: (context, endDate, _) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                                height: 35,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // color: Colors.white,
                                    border: Border.all(
                                      // color: Colors.grey,
                                      color: const Color.fromARGB(146, 146, 69, 197),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    selectedEndDate.value == null ? 'Select End Date' : DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedEndDate.value!),
                                    style: GoogleFonts.openSans().copyWith(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ).ripple(context, () => _selectDate(context, selectedEndDate));
                            },
                          ),
                          FilterTextField(
                            textStream: bloc.barcodeStream,
                            onTextChanged: (value) {
                              //print('object');
                              filterValue.add('');
                              filterValue.add(value);

                              // bloc.plateNumberStream.add('');
                              // bloc.mobileNumberStream.add('');
                              // _controller.text = '';
                              // selectedStartDate.value = null;
                              // selectedStartDate.notifyListeners();
                              // selectedEndDate.value = null;
                              // selectedEndDate.notifyListeners();
                              // bloc.vehicleModelStream.add('');
                              // bloc.vehicleColorStream.add('');

                              // bloc.vehicleLocationStream.add('');
                              // bloc.outletsStream.add('');
                              // bloc.cvaInStream.add('');
                              // bloc.cvaOutStream.add('');
                              // bloc.userTypeStream.add('');
                              // bloc.locationStream.add('');

                              // bloc.statusStream.add('');

                              bloc.barcodeStream.add(value);
                              //print(value);

                              if (bloc.barcodeStream.value.isEmpty) {
                                searchListNotifier.add([]);
                              }

                              // if (_filterController.text.isEmpty) {
                              //   searchListNotifier.add([]);
                              // }
                              // Debouncer(milliseconds: 500).run(() async {
                              //   // Call your handler after the specified delay

                              //   if (value == '') {
                              //     searchListNotifier.add([]);
                              //   } else {
                              //     //print(value);
                              //     Loader.show(
                              //       context,
                              //       progressIndicator: LoadingAnimationWidget.fallingDot(
                              //         color: AppColors.mainColor!,
                              //         size: 40.sp,
                              //       ),
                              //     );
                              //     Future.delayed(
                              //       const Duration(milliseconds: 400),
                              //       () async {
                              //         final respModel = await bloc.getTicketWithBarcode(orderBy: 'parking_time', barcode: value);
                              //         final list = respModel!.data.ticketsList!.where((elem) {
                              //           return elem.barcode!.trim().contains(value.toLowerCase().trim());
                              //           // return elem.barcode!.trim().contains(value.toLowerCase().trim()) ||
                              //           //     (elem.emiratesName.toString().toLowerCase().trim().contains(value.toLowerCase().trim()) && elem.dataCheckinTime != '0000-00-00 00:00:00') ||
                              //           //     (elem.vehicleNumber.toString().toLowerCase().trim().contains(value.toLowerCase().trim()) && elem.dataCheckinTime != '0000-00-00 00:00:00') ||
                              //           //     (elem.cvaInName.toString().toLowerCase().trim().contains(value.toLowerCase().trim())) ||
                              //           //     (elem.cvaOutName.toString().toLowerCase().trim().contains(value.toLowerCase().trim()));
                              //         }).toList();

                              //         if (_filterController.text.isEmpty) {
                              //           searchListNotifier.add([]);
                              //         }

                              //         searchListNotifier.add(list);

                              //         //print(searchListNotifier.value.length);
                              //         //print(_filterController.text.isEmpty);
                              //         //print(searchListNotifier.value.isEmpty);
                              //         Loader.hide();
                              //       },
                              //     );
                              //   }
                              // });
                            },
                            hintText: 'Barcode',
                            keyboardType: TextInputType.text,
                          ),

                          FilterTextField(
                            textStream: bloc.plateNumberStream,
                            onTextChanged: (value) {
                              filterValue.add('');
                              filterValue.add(value);

                              // bloc.barcodeStream.add('');
                              // bloc.mobileNumberStream.add('');
                              _controller.text = '';
                              // selectedStartDate.value = null;
                              // selectedStartDate.notifyListeners();
                              // selectedEndDate.value = null;
                              // selectedEndDate.notifyListeners();

                              // bloc.vehicleModelStream.add('');
                              // bloc.vehicleColorStream.add('');
                              // //print(value);

                              // bloc.vehicleLocationStream.add('');
                              // bloc.outletsStream.add('');
                              // bloc.cvaInStream.add('');
                              // bloc.cvaOutStream.add('');
                              // bloc.userTypeStream.add('');
                              // bloc.locationStream.add('');

                              // bloc.statusStream.add('');

                              bloc.plateNumberStream.add(value);

                              if (bloc.plateNumberStream.value.isEmpty) {
                                searchListNotifier.add([]);
                              }

                              // if (_filterController.text.isEmpty) {
                              //   searchListNotifier.add([]);
                              // }
                              // Debouncer(milliseconds: 500).run(() async {
                              //   // Call your handler after the specified delay

                              //   if (value == '') {
                              //     searchListNotifier.add([]);
                              //   } else {
                              //     //print(value);
                              //     Loader.show(
                              //       context,
                              //       progressIndicator: LoadingAnimationWidget.fallingDot(
                              //         color: AppColors.mainColor!,
                              //         size: 40.sp,
                              //       ),
                              //     );
                              //     Future.delayed(
                              //       const Duration(milliseconds: 400),
                              //       () async {
                              //         final respModel = await bloc.getTicketWithVehiclNumber(orderBy: 'parking_time', vehicleNumber: value);
                              //         final list = respModel!.data.ticketsList!.where((elem) {
                              //           return elem.vehicleNumber.toString().toLowerCase().trim().contains(value.toLowerCase().trim()) && elem.dataCheckinTime != '0000-00-00 00:00:00';
                              //           // return elem.barcode!.trim().contains(value.toLowerCase().trim()) ||
                              //           //     (elem.emiratesName.toString().toLowerCase().trim().contains(value.toLowerCase().trim()) && elem.dataCheckinTime != '0000-00-00 00:00:00') ||
                              //           //     (elem.vehicleNumber.toString().toLowerCase().trim().contains(value.toLowerCase().trim()) && elem.dataCheckinTime != '0000-00-00 00:00:00') ||
                              //           //     (elem.cvaInName.toString().toLowerCase().trim().contains(value.toLowerCase().trim())) ||
                              //           //     (elem.cvaOutName.toString().toLowerCase().trim().contains(value.toLowerCase().trim()));
                              //         }).toList();

                              //         if (_filterController.text.isEmpty) {
                              //           searchListNotifier.add([]);
                              //         }

                              //         searchListNotifier.add(list);

                              //         //print(searchListNotifier.value.length);
                              //         //print(_filterController.text.isEmpty);
                              //         //print(searchListNotifier.value.isEmpty);
                              //         Loader.hide();
                              //       },
                              //     );
                              //   }
                              // });
                            },
                            hintText: 'Plate Number',
                            keyboardType: TextInputType.text,
                          ),
                          StreamBuilder(
                            stream: bloc.vehicleModelStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleColorStream.add('');
                                  // bloc.vehicleLocationStream.add('');
                                  // bloc.outletsStream.add('');
                                  // bloc.cvaInStream.add('');
                                  // bloc.cvaOutStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // bloc.statusStream.add('');

                                  bloc.vehicleModelStream.add(val ?? '');
                                },
                                value: snapshot.data ?? '',
                                field: 'Car Brand',
                                labelText: 'Car Brand',
                                list: checkInitems == null || checkInitems.data == null || checkInitems.data?.carModels == null
                                    ? []
                                    : ['', ...checkInitems.data!.carModels!.map((e) => e.modelTitle ?? '')],
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: bloc.vehicleColorStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleModelStream.add('');
                                  // bloc.vehicleLocationStream.add('');
                                  // bloc.outletsStream.add('');
                                  // bloc.cvaInStream.add('');
                                  // bloc.cvaOutStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // bloc.statusStream.add('');

                                  bloc.vehicleColorStream.add(val ?? '');
                                },
                                value: snapshot.data ?? '',
                                field: 'Car Color',
                                labelText: 'Car Color',
                                list: checkInitems == null || checkInitems.data == null || checkInitems.data?.carColors == null
                                    ? []
                                    : ['', ...checkInitems.data!.carColors!.map((e) => e.carTitle ?? '')],
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: bloc.vehicleLocationStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleColorStream.add('');
                                  // bloc.vehicleModelStream.add('');
                                  // bloc.outletsStream.add('');
                                  // bloc.cvaInStream.add('');
                                  // bloc.cvaOutStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // bloc.statusStream.add('');

                                  bloc.vehicleLocationStream.add(val ?? '');
                                },
                                value: snapshot.data ?? '',
                                field: 'Emirates',
                                labelText: 'Emirates',
                                list: checkInitems == null || checkInitems.data == null || checkInitems.data?.vehicleLocations == null
                                    ? []
                                    : ['', ...checkInitems.data!.vehicleLocations!.map((e) => e.vehicleLocationName ?? '')],
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: bloc.outletsStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleModelStream.add('');
                                  // bloc.vehicleColorStream.add('');
                                  // bloc.vehicleLocationStream.add('');
                                  // bloc.cvaInStream.add('');
                                  // bloc.cvaOutStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // bloc.statusStream.add('');

                                  bloc.outletsStream.add(val ?? '');
                                },
                                value: snapshot.data ?? '',
                                field: 'Outlets',
                                labelText: 'Outlets',
                                list: checkInitems == null || checkInitems.data == null || checkInitems.data?.outlets == null
                                    ? []
                                    : ['', ...checkInitems.data!.outlets!.map((e) => e.outletPostName ?? '')],
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: bloc.statusStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleColorStream.add('');
                                  // bloc.vehicleModelStream.add('');
                                  // bloc.outletsStream.add('');
                                  // bloc.vehicleLocationStream.add('');
                                  // bloc.cvaInStream.add('');
                                  // bloc.cvaOutStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // //print('4444444444444444444444 : ${checkOutStatusStaticListMapping[val]}');

                                  bloc.statusStream.add(checkOutStatusStaticListMappingToSymbol[val] ?? '');
                                },
                                value: checkOutStatusStaticListMappingToName[snapshot.data] ?? '',
                                field: 'Status',
                                labelText: 'Status',
                                // list: checkInitems == null ? [] : ['', ...checkInitems.data.cvas.map((e) => e.departmentName)],
                                list: checkOutStatusStaticList,
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: bloc.cvaInStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleColorStream.add('');
                                  // bloc.vehicleModelStream.add('');
                                  // bloc.outletsStream.add('');
                                  // bloc.vehicleLocationStream.add('');
                                  // bloc.cvaOutStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // bloc.statusStream.add('');

                                  bloc.cvaInStream.add(val ?? '');
                                },
                                value: snapshot.data ?? '',
                                field: 'CVA IN',
                                labelText: 'CVA IN',
                                list: checkInitems == null || checkInitems.data == null || checkInitems.data?.cvas == null
                                    ? []
                                    : ['', ...checkInitems.data!.cvas!.map((e) => e.departmentName ?? '')],
                              );
                            },
                          ),
                          StreamBuilder(
                            stream: bloc.cvaOutStream,
                            builder: (context, snapshot) {
                              return CustomDropDown(
                                onChanged: (String? val) {
                                  filterValue.add('');
                                  filterValue.add(val ?? '');

                                  // bloc.plateNumberStream.add('');
                                  // bloc.mobileNumberStream.add('');
                                  // bloc.barcodeStream.add('');
                                  _controller.text = '';
                                  // selectedStartDate.value = null;
                                  // selectedStartDate.notifyListeners();
                                  // selectedEndDate.value = null;
                                  // selectedEndDate.notifyListeners();

                                  // bloc.vehicleModelStream.add('');
                                  // bloc.vehicleColorStream.add('');
                                  // bloc.vehicleLocationStream.add('');
                                  // bloc.outletsStream.add('');
                                  // bloc.cvaInStream.add('');
                                  // bloc.userTypeStream.add('');
                                  // bloc.locationStream.add('');

                                  // bloc.statusStream.add('');

                                  bloc.cvaOutStream.add(val ?? '');
                                },
                                value: snapshot.data ?? '',
                                field: 'CVA OUT',
                                labelText: 'CVA OUT',
                                list: checkInitems == null || checkInitems.data == null || checkInitems.data?.cvas == null
                                    ? []
                                    : ['', ...checkInitems.data!.cvas!.map((e) => e.departmentName ?? '')],
                              );
                            },
                          ),
                          if (widget.allTickets != null &&
                              widget.allTickets!.data != null &&
                              widget.allTickets!.data!.locationsList != null &&
                              widget.allTickets!.data!.usersList != null &&
                              widget.allTickets!.data!.locationsList!.isNotEmpty &&
                              widget.allTickets!.data!.usersList!.isNotEmpty)
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: StreamBuilder(
                                stream: bloc.locationStream,
                                builder: (context, snapshot) {
                                  return CustomDropDown(
                                    onChanged: (String? val) async {
                                      filterValue.add('');
                                      filterValue.add(val ?? '');

                                      // bloc.plateNumberStream.add('');
                                      // bloc.mobileNumberStream.add('');
                                      // bloc.barcodeStream.add('');
                                      _controller.text = '';
                                      // selectedStartDate.value = null;
                                      // selectedStartDate.notifyListeners();
                                      // selectedEndDate.value = null;
                                      // selectedEndDate.notifyListeners();

                                      // bloc.vehicleColorStream.add('');
                                      // bloc.vehicleModelStream.add('');
                                      // bloc.outletsStream.add('');
                                      // bloc.vehicleLocationStream.add('');
                                      // bloc.cvaInStream.add('');
                                      // bloc.cvaOutStream.add('');

                                      // bloc.statusStream.add('');
                                      // bloc.userTypeStream.add('');

                                      bloc.locationStream.add(val ?? 'Users');
                                      final id = widget.allTickets?.data?.locationsList?.where((e) => e.departmentName == val).first.departmentId;
                                      // print('9999999999999999999999999999999999999999999999999999 $id');
                                      bloc.userTypeStream.add('');
                                      await bloc.getUsersWithLocation(orderBy: 'parking_time', locationId: id ?? 0);
                                    },
                                    value: snapshot.data ?? '',
                                    field: 'Locations',
                                    labelText: 'Locations',
                                    // list: checkInitems == null ? [] : ['', ...widget.allTickets!.data!.locationsList!.map((e) => e.departmentName ?? '')],
                                    list: widget.allTickets == null || widget.allTickets?.data == null || widget.allTickets?.data?.locationsList == null
                                        ? []
                                        : ['', ...widget.allTickets!.data!.locationsList!.map((e) => e.departmentName ?? '')],
                                  );
                                },
                              ),
                            ),

                          if (widget.allTickets != null &&
                              widget.allTickets!.data != null &&
                              widget.allTickets!.data!.locationsList != null &&
                              widget.allTickets!.data!.usersList != null &&
                              widget.allTickets!.data!.locationsList!.isNotEmpty &&
                              widget.allTickets!.data!.usersList!.isNotEmpty)
                            Container(
                              // margin: EdgeInsets.symmetric(vertical: 10.h),
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: StreamBuilder(
                                stream: bloc.locationStream,
                                builder: (context, snapshot) {
                                  return StreamBuilder(
                                    stream: bloc.getUsersWithLocationStream,
                                    builder: (context, getUsersWithLocationStreamsnapshot) {
                                      // print('2222222222222222222222222 ${getUsersWithLocationStreamsnapshot.data!.data!.users!.map((e) => e.departmentName ?? '')}');

                                      return StreamBuilder(
                                        stream: bloc.userTypeStream,
                                        builder: (context, snapshot) {
                                          if (bloc.locationStream.value.isEmpty) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 10, top: 10),
                                              child: Container(
                                                height: 35,
                                                width: double.infinity,
                                                alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: Colors.grey[400]!),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Text('Users', style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w800)),
                                                ),
                                              ).ripple(context, () {
                                                // Fluttertoast.cancel();
                                                // toastInfo(
                                                //   msg: 'Please Select Location',
                                                //   gravity: ToastGravity.BOTTOM,
                                                // );
                                                warningMotionToastInfo(context, msg: 'Please Select Location');
                                              }),
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10,
                                                // top:10,
                                              ),
                                              child: CustomDropDown(
                                                onChanged: (String? val) async {
                                                  filterValue.add('');
                                                  filterValue.add(val ?? '');

                                                  // bloc.plateNumberStream.add('');
                                                  // bloc.mobileNumberStream.add('');
                                                  // bloc.barcodeStream.add('');
                                                  _controller.text = '';
                                                  // selectedStartDate.value = null;
                                                  // selectedStartDate.notifyListeners();
                                                  // selectedEndDate.value = null;
                                                  // selectedEndDate.notifyListeners();

                                                  // bloc.vehicleModelStream.add('');
                                                  // bloc.vehicleColorStream.add('');
                                                  // bloc.vehicleLocationStream.add('');
                                                  // bloc.outletsStream.add('');
                                                  // bloc.cvaInStream.add('');
                                                  // bloc.cvaOutStream.add('');
                                                  // // bloc.locationStream.add('');

                                                  // bloc.statusStream.add('');

                                                  bloc.userTypeStream.add(val ?? '');
                                                },
                                                value: snapshot.data ?? '',
                                                field: 'Users',
                                                labelText: 'Users',
                                                // list: widget.allTickets == null || widget.allTickets?.data == null || widget.allTickets?.data?.usersList == null
                                                //     ? []
                                                //     : ['', ...widget.allTickets!.data!.usersList!.map((e) => e.departmentName ?? '')],
                                                list: getUsersWithLocationStreamsnapshot.data == null ||
                                                        getUsersWithLocationStreamsnapshot.data?.data == null ||
                                                        getUsersWithLocationStreamsnapshot.data?.data?.users == null
                                                    ? []
                                                    : ['', ...getUsersWithLocationStreamsnapshot.data!.data!.users!.map((e) => e.departmentName ?? '')],
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                          FilterTextField(
                            textStream: bloc.mobileNumberStream,
                            onTextChanged: (value) {
                              filterValue.add('');
                              filterValue.add(value);

                              // bloc.barcodeStream.add('');
                              // bloc.plateNumberStream.add('');
                              _controller.text = '';
                              // selectedStartDate.value = null;
                              // selectedStartDate.notifyListeners();
                              // selectedEndDate.value = null;
                              // selectedEndDate.notifyListeners();
                              // //print(value);
                              // bloc.vehicleModelStream.add('');
                              // bloc.vehicleColorStream.add('');
                              // bloc.vehicleLocationStream.add('');
                              // bloc.outletsStream.add('');
                              // bloc.cvaInStream.add('');
                              // bloc.cvaOutStream.add('');
                              // bloc.userTypeStream.add('');
                              // bloc.locationStream.add('');

                              // bloc.statusStream.add('');

                              bloc.mobileNumberStream.add(value);

                              if (bloc.mobileNumberStream.value.isEmpty) {
                                searchListNotifier.add([]);
                              }
                            },
                            hintText: 'Mobile Number',
                            keyboardType: TextInputType.number,
                          ),

                          // Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                  // margin: const EdgeInsets.only(right: 50,top: 10,bottom: 5),
                                  margin: const EdgeInsets.only(right: 20, top: 5, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: secondaryColor2,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.filter_alt_outlined),
                                      const SizedBox(width: 10),
                                      Text('FILTER', style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                ).ripple(context, overlayColor: Colors.transparent, () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  customLoader(context);
                                  //
                                  // Combinations

                                  _controller.text = '';

                                  Debouncer(milliseconds: 500).run(() async {
                                    Loader.show(
                                      context,
                                      progressIndicator: LoadingAnimationWidget.fallingDot(color: secondaryColor2, size: 40),
                                    );
                                    String? formattedStartDate;
                                    String? formattedEndDate;
                                    if (selectedStartDate.value != null) {
                                      formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedStartDate.value!);
                                    } else if (selectedEndDate.value != null && selectedStartDate.value == null) {
                                      // await toastInfo(
                                      //   msg: 'Please Select Start Date',
                                      //   gravity: ToastGravity.BOTTOM,
                                      // );
                                      await warningMotionToastInfo(context, msg: 'Please Select Start Date');
                                      Loader.hide();
                                      return;
                                    }
                                    if (selectedEndDate.value != null) {
                                      if (selectedEndDate.value!.isBefore(selectedStartDate.value!)) {
                                        await erroMotionToastInfo(context, msg: 'Selected End Date is not allowed. Select a date that after the start date');
                                        Loader.hide();
                                        return;
                                      }
                                      // formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedEndDate.value!);
                                      formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(DateTime(selectedEndDate.value!.year, selectedEndDate.value!.month, selectedEndDate.value!.day, 23, 59, 59));
                                    } else if (selectedEndDate.value == null && selectedStartDate.value != null) {
                                      // await toastInfo(
                                      //   msg: 'Please Select End Date',
                                      //   gravity: ToastGravity.BOTTOM,
                                      // );
                                      await warningMotionToastInfo(context, msg: 'Please Select End Date');
                                      Loader.hide();
                                      return;
                                    }

                                    final brandId = checkInitems?.data?.carModels?.where((e) => e.modelTitle == bloc.vehicleModelStream.value).firstOrNull?.modelId;
                                    final colorId = checkInitems?.data?.carColors?.where((e) => e.carTitle == bloc.vehicleColorStream.value).firstOrNull?.carId;
                                    final emiratesId =
                                        checkInitems?.data?.vehicleLocations?.where((e) => e.vehicleLocationName == bloc.vehicleLocationStream.value).firstOrNull?.vehicleLocationId;
                                    final outletId = checkInitems?.data?.outlets?.where((e) => e.outletPostName == bloc.outletsStream.value).firstOrNull?.outletPostId;
                                    final cvaInId = checkInitems?.data?.cvas?.where((e) => e.departmentName == bloc.cvaInStream.value).firstOrNull?.departmentId;
                                    final cvaOutId = checkInitems?.data?.cvas?.where((e) => e.departmentName == bloc.cvaOutStream.value).firstOrNull?.departmentId;
                                    final locationId = widget.allTickets?.data?.locationsList!.where((e) => e.departmentName == bloc.locationStream.value).firstOrNull?.departmentId;
                                    final userId = widget.allTickets?.data?.usersList!.where((e) => e.departmentName == bloc.userTypeStream.value).firstOrNull?.departmentId;

                                    Future.delayed(const Duration(milliseconds: 400), () async {
                                      final respModel = await bloc.getTicketsWithCombinations(
                                        orderBy: 'parking_time',
                                        checkOutStatus: bloc.statusStream.value,
                                        parkingLocationId: locationId ?? 0,
                                        locationUserId: userId ?? 0,
                                        cvaOut: cvaOutId ?? 0,
                                        cvaIn: cvaInId ?? 0,
                                        outletId: outletId ?? 0,
                                        emiratesId: emiratesId ?? 0,
                                        vehicleColorlId: colorId ?? 0,
                                        vehicleModelId: brandId ?? 0,
                                        startDate: formattedStartDate ?? '',
                                        endDate: formattedEndDate ?? '',
                                        mobileNumber: bloc.mobileNumberStream.value,
                                        vehicleNumber: bloc.plateNumberStream.value,
                                        barcode: bloc.barcodeStream.value,
                                        pageNo: 1,
                                      );

                                      final list = respModel?.data?.ticketsList!;

                                      if (_filterController.text.isEmpty) {
                                        searchListNotifier.add([]);
                                      }

                                      isSearchListNotifierAlongWithSearchKey.add(false);

                                      currentPageForInventoryReport.value = 1;
                                      currentPageForInventoryReport.notifyListeners();

                                      searchListNotifier.add(list ?? []);

                                      searchListRespmodelNotifier.add(respModel);

                                      //print(searchListNotifier.value.length);
                                      //print(_filterController.text.isEmpty);
                                      //print(searchListNotifier.value.isEmpty);
                                      Loader.hide();
                                    });
                                  });
                                }),
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, ValueNotifier<DateTime?> selectedDate) async {
    final bloc = Provider.of<NavigationReportBloc>(context, listen: false);
    filterValue.add('');

    // bloc.barcodeStream.add('');
    // bloc.mobileNumberStream.add('');
    // bloc.plateNumberStream.add('');
    // _controller.text = '';
    // bloc.vehicleModelStream.add('');
    // bloc.vehicleColorStream.add('');

    // bloc.vehicleLocationStream.add('');
    // bloc.outletsStream.add('');

    // bloc.cvaInStream.add('');
    // bloc.cvaOutStream.add('');
    // bloc.userTypeStream.add('');
    // bloc.locationStream.add('');

    // bloc.statusStream.add('');

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value == null ? DateTime.now() : selectedDate.value!,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    // if (picked != null && picked != selectedDate.value) {
    //   selectedDate.value = picked;
    //   selectedDate.notifyListeners();
    // }
    // selectedDate.value = picked;
    // selectedDate.notifyListeners();

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final ThemeData theme = Theme.of(context);
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate.value ?? DateTime.now()),
        builder: (BuildContext? context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        selectedDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        selectedDate.notifyListeners();
      }
    }
    filterValue.add('date_added');
  }
}

// class _FilterTextField extends StatefulWidget {
//   const _FilterTextField({
//     required this.textStream,
//     required this.onTextChanged,
//     required this.hintText,
//     required this.keyboardType,
//     this.errorStream,
//   });

//   final BehaviorSubject<String> textStream;
//   final void Function(String) onTextChanged;
//   final String hintText;
//   final TextInputType keyboardType;
//   final Stream<String>? errorStream;

//   @override
//   State<_FilterTextField> createState() => _FilterTextFieldState();
// }

// class _FilterTextFieldState extends State<_FilterTextField> {
//   final _controller = TextEditingController();
//   @override
//   void initState() {
//     widget.textStream.listen((value) {
//       if (value.isEmpty) {
//         _controller.clear();
//       } else if (_controller.text != value) {
//         _controller.text = value;
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0),
//       child: SizedBox(
//         height: 35,
//         width: MediaQuery.of(context).size.width / 5,
//         child: TextField(
//           controller: _controller,
//           onChanged: widget.onTextChanged,
//           keyboardType: widget.keyboardType,
//           style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//             // hintStyle: GoogleFonts.openSans().copyWith(fontSize: 12.w),
//             hintStyle: GoogleFonts.openSans().copyWith(color: Colors.grey[700], fontSize: 10.5),
//             contentPadding: const EdgeInsets.only(left: 15),

//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color.fromARGB(146, 146, 69, 197)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(
//                 // color: Color.fromARGB(255, 80, 19, 121),
//                 color: Color.fromARGB(146, 146, 69, 197),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class _FilterTextField extends StatefulWidget {
//   const _FilterTextField({
//     required this.textStream,
//     required this.onTextChanged,
//     required this.hintText,
//     required this.keyboardType,
//     this.errorStream,
//   });

//   final BehaviorSubject<String> textStream;
//   final void Function(String) onTextChanged;
//   final String hintText;
//   final TextInputType keyboardType;
//   final Stream<String>? errorStream;

//   @override
//   State<_FilterTextField> createState() => _FilterTextFieldState();
// }

// class _FilterTextFieldState extends State<_FilterTextField> {
//   final _controller = TextEditingController();
//   @override
//   void initState() {
//     widget.textStream.listen((value) {
//       if (value.isEmpty) {
//         _controller.clear();
//       } else if (_controller.text != value) {
//         _controller.text = value;
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 35,
//             child: TextField(
//               controller: _controller,
//               onChanged: widget.onTextChanged,
//               keyboardType: widget.keyboardType,
//               style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 // hintStyle: GoogleFonts.openSans().copyWith(fontSize: 12),
//                 hintStyle: GoogleFonts.openSans().copyWith(
//                   color: Colors.grey[700],
//                   fontSize: 10.5,
//                 ),
//                 contentPadding: EdgeInsets.only(left: 15),

//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color.fromARGB(146, 146, 69, 197)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     // color: Color.fromARGB(255, 80, 19, 121),
//                     color: Color.fromARGB(146, 146, 69, 197),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // SizedBox(height: 10),
//           StreamBuilder<String>(
//             stream: widget.errorStream,
//             builder: (context, snapshot) {
//               final error = snapshot.data ?? '';
//               return StreamBuilder<String>(
//                 stream: widget.textStream,
//                 builder: (context, textSnapshot) {
//                   final textData = textSnapshot.data ?? '';
//                   // if (widget.isEmptyError &&
//                   //     textData.isEmpty &&
//                   //     error.isNotEmpty) {
//                   //   return _ErrorTextWidget(errorText: error);
//                   // } else if (!widget.isEmptyError && error.isNotEmpty) {
//                   //   return _ErrorTextWidget(errorText: error);
//                   // } else {
//                   //   return Container();
//                   // }
//                   if (textData.isEmpty && error.isNotEmpty) {
//                     return ErrorTextWidget(errorText: error);
//                   } else if (textData.isNotEmpty && error.isNotEmpty) {
//                     return ErrorTextWidget(errorText: error);
//                   } else {
//                     return Container();
//                   }
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
