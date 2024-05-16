// ignore_for_file: lines_longer_than_80_chars, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:admin_panel/controllers/dashboard_tab_controller.dart';
import 'package:admin_panel/logic/account/account_bloc.dart';
import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/logic/search/search_bloc.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/models/new/permission/permssion_model.dart';
import 'package:admin_panel/models/new/print/printing_header_model.dart';
import 'package:admin_panel/screens/actions/actions_page.dart';
import 'package:admin_panel/screens/widgets/invemtory_item.dart';
import 'package:admin_panel/utils/const_variables.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/utility_functions.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart' as flutter_esc;
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rxdart/rxdart.dart';

class ActionTopCard extends StatefulWidget {
  const ActionTopCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.allPermissions,
    this.isParkedPage = false,
    this.result,
    this.isExists = false,
    super.key,
  });
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final String? result;
  final bool isExists;
  final bool isParkedPage;
  final GetAllPermissions? allPermissions;

  @override
  State<ActionTopCard> createState() => ActionTopCardState();
}

final ValueNotifier<bool> isExpandedNotifier = ValueNotifier(true);

// isExpandedNotifier2 is not usable in action_top_card.dart but usable in action_top_card_latest.dart.
// So just added to avoid errors in other pages
final ValueNotifier<bool> isExpandedNotifier2 = ValueNotifier(false);

class ActionTopCardState extends State<ActionTopCard> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
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

  // bool isExpanded = true;

  // final StreamController<String> _dateTimeController = StreamController<String>();
  final BehaviorSubject<String> _dateTimeController = BehaviorSubject<String>();

  // @override
  // void dispose() {
  //   _dateTimeController.close();
  //   super.dispose();
  // }

  void _updateDateTime({required String dateTime}) {
    // Simulate updating the DateTime
    // DateTime now = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    _dateTimeController.add(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final dashTabController = Provider.of<DashBoardTabController>(context);
    final isSelected = dashTabController.menuName == 'Current Inventory';
    final bloc = Provider.of<ActionsBloc>(context);
    final dashBloc = Provider.of<DashboardBloc>(context);
    final userType = StorageServices.to.getString('userType');
    return InkWell(
      onTap: () {
        // dashTabController.setMenuName('Current Inventory');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 160),
        child: Card(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: const Color.fromARGB(255, 88, 69, 197),
          color: Colors.white,
          elevation: isSelected ? 5 : 1,
          child: ValueListenableBuilder(
            valueListenable: isExpandedNotifier,
            builder: (context, isExpanded, _) {
              final minValue = StorageServices.to.getInt(StorageServicesKeys.minValue);
              final maxValue = StorageServices.to.getInt(StorageServicesKeys.maxValue);
              var isInRange = false;
              if (widget.result != null) {
                isInRange = (widget.result!.length >= minValue) && (widget.result!.length <= maxValue);
              }
        
              return StreamBuilder(
                stream: bloc.ticketDetailsResponse,
                builder: (context, snapshot) {
                  var tickinfo = <TicketInfo>[];
                  // //print('aaaaaaaa ${snapshot.hasData}');
                  if (snapshot.hasData) {
                    final ticketDetails = snapshot.data;
                    tickinfo = ticketDetails?.data?.ticketInfo ?? [];
                    // //print('111111111111111111 : $tickinfo');
                    // //print('create Date ${tickinfo[0].createDate}');
                  }
        
                  final locationName = StorageServices.to.getString('locationName');
        
                  String totalDuration = '';
        
                  if (tickinfo.isNotEmpty) {
                    // needed to implement somewhere. now it commented due to some unknown bugs.It needs for updating UI when fee collection is enabled or not
                    // bloc.getAllCheckOutItems(id: tickinfo[0].id);
        
                    totalDuration = UtilityFunctions.getDurationOf2TimesIsNegative(
                      startTimeString: tickinfo[0].initialCheckinTime!,
                      endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                        // UtilityFunctions.convertLocalToDubaiTime().isNegative
                        //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                        //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                      ),
                      checkoutStatus: tickinfo[0].checkoutStatus ?? 'N',
                      checkoutTime: tickinfo[0].checkoutTime,
                    );
        
                    // print('ddddddddddddddddddddddddddddddd ${totalDuration}');
                    // if (!totalDuration.contains('-1 s') && totalDuration.contains('-')) {
                    //   erroMotionToastInfo(context, msg: 'Please Contact Admin or Developer. There is an issue in current timezone region');
                    // }
                  }
        
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5),
                            // Image.asset(
                            //   'assets/images/location_logo1.png',
                            //   width: 50,
                            // ),
        
                            if (tickinfo.isEmpty)
                              // Image.asset(
                              //   'assets/images/barcode_sample.jpg',
                              //   width: 100,
                              // )
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  data: '*************',
                                  style: const TextStyle(color: Colors.black, fontSize: 22, letterSpacing: 2),
                                  width: 250,
                                  height: 110,
                                ),
                              )
                            else
                              BarcodeWidget(
                                barcode: Barcode.code128(),
                                // data: tickinfo[0].barcode!.split('').join(' '),
                                data: tickinfo[0].checkoutStatus == 'Y' ? '${tickinfo[0].barcode}-${tickinfo[0].id}' : tickinfo[0].barcode!,
                                // style: TextStyle(fontSize: 10),
                                style: const TextStyle(fontSize: 0),
                                width: 250,
                                height: 110,
                              ),
        
                            if (tickinfo.isNotEmpty) const Spacer() else const SizedBox(width: 30),
        
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tickinfo.isEmpty)
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      // widget.title,
                                      'Location',
                                      // locationName.toUpperCase(),
                                      style: GoogleFonts.openSans().copyWith(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black, overflow: TextOverflow.ellipsis),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: SizedBox(
                                      width: 300,
                                      child: Text(
                                        // widget.title,
                                        tickinfo[0].locationName?.toUpperCase() ?? '',
                                        style: GoogleFonts.openSans().copyWith(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                // if (widget.result != null && widget.result != '' && tickinfo.isNotEmpty && isInRange && snapshot.hasData && widget.isExists)
                                // if (widget.result != null && widget.result != '' && tickinfo.isNotEmpty && isInRange)
                                if (widget.result != null && widget.result != '' && tickinfo.isNotEmpty && isInRange)
                                  Padding(
                                    // padding: EdgeInsets.symmetric(vertical: 0),
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      // alignment: WrapAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: statusNotifier,
                                          builder: (context, status, _) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InventoryItem(
                                                  isActionPage: true,
                                                  title: 'Created',
                                                  // value: '12/05/2023, 9:00 am',
                                                  value: tickinfo[0].createDate,
                                                ),
                                                Tooltip(
                                                  onTriggered: () {
                                                    if (checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime).length > 9) return;
                                                  },
                                                  message: checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime).length > 9
                                                      ? checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)
                                                      : '',
                                                  triggerMode: TooltipTriggerMode.tap,
                                                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                                                  child: InventoryItem(
                                                    isActionPage: true,
                                                    title: 'Status',
                                                    haveStatus: true,
                                                    // status: status,
                                                    status: checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime),
                                                    // status: tickinfo[0].checkoutStatus,
                                                    // value: '12/05/2023, 11:00 am',
                                                    // value: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(tickinfo[0].initialCheckinTime)),
                                                    // value: tickinfo[0]
                                                    //     .initialCheckinTime,
                                                    value: checkoutStatusTime(tickinfo[0].checkoutStatus ?? 'N', tickinfo),
                                                    ticketInfo: tickinfo[0],
                                                  ),
                                                ),
                                                StreamBuilder<String>(
                                                  stream: _dateTimeController.stream,
                                                  builder: (context, snapshot) {
                                                    // _dateTimeController.add('');
                                                    _dateTimeController.add(
                                                      UtilityFunctions.getDuration(
                                                        startTimeString: tickinfo[0].initialCheckinTime!,
                                                        endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                                          DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                          // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                          //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                          //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                        ),
                                                        checkoutStatus: tickinfo[0].checkoutStatus ?? 'N',
                                                        checkoutTime: tickinfo[0].finalCheckoutTime,
                                                      ),
                                                    );
                                                    return InventoryItem(
                                                      isActionPage: true,
                                                      title: 'Duration',
                                                      // value: '02:10:30 Hrs',
                                                      // value: UtilityFunctions.extractTimeFromDateTime(),
                                                      // value: UtilityFunctions.getDurationOf2Times(
                                                      //   startTimeString: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(tickinfo[0].initialCheckinTime)),
                                                      //   endTimeString: UtilityFunctions.extractTimeFromDateTime(),
                                                      // ),
                                                      value: totalDuration.contains('-1 s')
                                                          ? '0 s'
                                                          : totalDuration.contains('-')
                                                              ? 'negative duration\nplease contact admin'
                                                              : snapshot.data ?? '0 s',
                                                    );
                                                  },
                                                ),
        
                                                // Utility Buttons
                                                // if (!isExpanded)
                                                if ((tickinfo[0].dataCheckinTime != null || (tickinfo[0].payment != null && tickinfo[0].payment != ''))
                                                    ? (!isExpanded)
                                                    : tickinfo[0].dataCheckinTime == null)
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 7),
                                                    child: StreamBuilder(
                                                      stream: dashBloc.printSettingsAndHeader,
                                                      builder: (context, snapshot) {
                                                        final settings = snapshot.data;
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            // SizedBox(width: 19),
                                                            InkWell(
                                                              onLongPress: () async {
                                                                customLoaderForPrintReceipt(context);
                                                                FocusManager.instance.primaryFocus?.unfocus();
        
                                                                if (userType == 'A' || userType == 'ADMIN') {
                                                                  final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                                  final locationName = tickinfo[0].locationName ?? '';
                                                                  final currentLocationId =
                                                                      allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                                } else {
                                                                  await context.read<AccountBloc>().getTokenDetails();
                                                                  final locationId = StorageServices.to.getInt('locationId');
                                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                                }
        
                                                                if (settings == null) {
                                                                  Loader.hide();
                                                                  await erroMotionToastInfo(context, msg: 'Try Again');
                                                                  return;
                                                                }
        
                                                                await bluetoothPrinting(settings: dashBloc.printSettingsAndHeader.value, tickinfo: tickinfo);
                                                              },
        
                                                              // ignore: unnecessary_statements
                                                              onTap: () async {
                                                                customLoaderForPrintReceipt(context);
                                                                FocusManager.instance.primaryFocus?.unfocus();
        
                                                                if (userType == 'A' || userType == 'ADMIN') {
                                                                  final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                                  final locationName = tickinfo[0].locationName ?? '';
                                                                  print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                                  final currentLocationId =
                                                                      allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                                } else {
                                                                  await context.read<AccountBloc>().getTokenDetails();
                                                                  final locationId = StorageServices.to.getInt('locationId');
                                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                                }
        
                                                                // if (widget.allPermissions != null &&
                                                                //     widget.allPermissions!.data != null &&
                                                                //     widget.allPermissions!.data!.isNotEmpty &&
                                                                //     widget.allPermissions!.data![0].ticketMobilePrint == 'N') {
                                                                //   await erroMotionToastInfo(context, msg: 'No Permission to print ticket');
                                                                //   return;
                                                                // }
        
                                                                if (settings == null) {
                                                                  Loader.hide();
                                                                  await erroMotionToastInfo(context, msg: 'Try Again');
                                                                  return;
                                                                }
        
                                                                final macAddr = StorageServices.to.getString('blue_mac');
                                                                print('macAddr $macAddr');
                                                                if (macAddr == '') {
                                                                  await bluetoothPrinting(settings: dashBloc.printSettingsAndHeader.value, tickinfo: tickinfo);
                                                                  return;
                                                                }
        
                                                                Loader.hide();
        
                                                                // ignore: inference_failure_on_function_invocation, use_build_context_synchronously
                                                                await showDialog(
                                                                  barrierDismissible: false,
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                      ),
                                                                      actionsPadding: const EdgeInsets.symmetric(
                                                                        horizontal: 12,
                                                                        vertical: 15,
                                                                      ),
                                                                      iconPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                                      buttonPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                                      // insetPadding: EdgeInsets.only(
                                                                      //   bottom: 50,
                                                                      //   left: 15,
                                                                      //   right: 15,
                                                                      // ),
                                                                      titlePadding: const EdgeInsets.symmetric(
                                                                        horizontal: 12,
                                                                        vertical: 10,
                                                                      ),
                                                                      title: Text(
                                                                        'Print Ticket',
                                                                        style: TextStyle(
                                                                          fontSize: 13,
                                                                          color: Colors.orange[800],
                                                                        ),
                                                                      ),
                                                                      content: const Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            'Are you sure to print ticket?',
                                                                            style: TextStyle(fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                            'Long press to go to bluetooth settings',
                                                                            style: TextStyle(fontSize: 8),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      actions: <Widget>[
                                                                        SizedBox(
                                                                          height: 27,
                                                                          child: OutlinedButton(
                                                                            style: OutlinedButton.styleFrom(
                                                                              side: const BorderSide(
                                                                                color: Color.fromARGB(255, 209, 174, 226),
                                                                              ),
                                                                              // backgroundColor:
                                                                              //     Color.fromARGB(255, 146, 80, 177),
                                                                              foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                                                                            ),
                                                                            onPressed: () {},
                                                                            // onPressed: () async {
                                                                            //   await PrintBluetoothThermal.pairedBluetooths.then((listResult) async {
                                                                            //     // customLoader(context);
                                                                            //     customLoaderForPrintReceipt(context);
                                                                            //     print('11111111111111111111111111111111111111');
                                                                            //     print('paired bluetooth ${listResult.first.macAdress}');
                                                                            //     // final mac = value.first.macAdress;
                                                                            //     await PrintBluetoothThermal.disconnect;
                                                                            //     final enabled = await PrintBluetoothThermal.bluetoothEnabled;
                                                                            //     print('bluetooth enabled: $enabled');
                                                                            //     final blueConnect = await PrintBluetoothThermal.connect(macPrinterAddress: macAddr);
                                                                            //     print('blueConnect : $blueConnect');
        
                                                                            //     final conexionStatus = await PrintBluetoothThermal.connectionStatus;
        
                                                                            //     print("connection status: $conexionStatus");
        
                                                                            //     if (!conexionStatus) {
                                                                            //       await erroMotionToastInfo(context,
                                                                            //           msg: "Can't able to connect. Please check $macAddr is turned on ", height: 50);
                                                                            //       Loader.hide();
                                                                            //       return;
                                                                            //     }
        
                                                                            //     // not important
                                                                            //     Loader.hide();
        
                                                                            //     final ticket = await testTicket(
                                                                            //       printModel: dashBloc.printSettingsAndHeader.value,
                                                                            //       barcode: tickinfo[0].barcode ?? '',
                                                                            //       slNo: (tickinfo[0].id ?? '').toString(),
                                                                            //       checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                                            //       checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                                            //       checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                            //       checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                            //       duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                                            //         startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                                            //         endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                                            //           DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                            //           // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                                            //           //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                                            //           //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                            //         ),
                                                                            //       ),
                                                                            //       amount: tickinfo[0].grossAmount ?? '',
                                                                            //       vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                                            //       vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                                            //       discount: tickinfo[0].discountAmount ?? '0',
                                                                            //       netAmount: tickinfo[0].payment ?? '0',
                                                                            //       isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                                            //       carBrand: tickinfo[0].carBrandName ?? '',
                                                                            //       carColor: tickinfo[0].carColorName ?? '',
                                                                            //     );
        
                                                                            //     final result = await PrintBluetoothThermal.writeBytes(ticket);
                                                                            //     Loader.hide();
                                                                            //   });
                                                                            //   Navigator.pop(context);
                                                                            // },
                                                                            child: const Text(
                                                                              'Yes',
                                                                              style: TextStyle(fontSize: 13),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 27,
                                                                          child: OutlinedButton(
                                                                            style: OutlinedButton.styleFrom(
                                                                              side: const BorderSide(
                                                                                color: Color.fromARGB(255, 209, 174, 226),
                                                                              ),
                                                                              // backgroundColor:
                                                                              //     Color.fromARGB(255, 146, 80, 177),
                                                                              foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: const Text(
                                                                              'No',
                                                                              style: TextStyle(fontSize: 13),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.purpleAccent.withOpacity(.07),
                                                                child: Icon(
                                                                  FontAwesomeIcons.print,
                                                                  color: StorageServices.to.getString('blue_mac').isNotEmpty ? Colors.green[700] : Colors.grey,
                                                                  size: 19,
                                                                ),
                                                              ),
        
                                                              // .ripple(context, () {
                                                              //   if (settings == null) return;
        
                                                              //   // );
                                                              // }),
                                                            ),
                                                            const SizedBox(width: 19),
                                                            CircleAvatar(
                                                              backgroundColor: Colors.purpleAccent.withOpacity(.07),
                                                              child: Icon(
                                                                FontAwesomeIcons.whatsapp,
                                                                color: Colors.green[400],
                                                                size: 19,
                                                              ),
                                                            ).ripple(
                                                              context,
                                                              () async {
                                                                // customLoaderForPdf(context);
                                                                // FocusManager.instance.primaryFocus?.unfocus();
        
                                                                // // await context.read<AccountBloc>().getTokenDetails();
                                                                // // final locationId = StorageServices.to.getInt('locationId');
                                                                // // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                                // if (userType == 'A' || userType == 'ADMIN') {
                                                                //   final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                                //   final locationName = tickinfo[0].customerMobile ?? '';
                                                                //   print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                                //   final currentLocationId =
                                                                //       allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                                //   await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                                // } else {
                                                                //   await context.read<AccountBloc>().getTokenDetails();
                                                                //   final locationId = StorageServices.to.getInt('locationId');
                                                                //   await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                                // }
        
                                                                // final whatsappNumber = tickinfo[0].customerMobile ?? '';
                                                                // if (whatsappNumber != '') {
                                                                //   // print('111111111111111111111111111111111111111111111111');
                                                                //   FocusManager.instance.primaryFocus?.unfocus();
                                                                //   // var whatsappUrl = "whatsapp://send?phone=${_countryCodeController.text + _phoneController.text}" + "&text=${Uri.encodeComponent(_messageController.text)}";
                                                                //   // var whatsappUrl = "whatsapp://send?phone=$whatsappNumber" + "&text=${Uri.encodeComponent('Hi')}";
                                                                //   // try {
                                                                //   //   await launchUrl(Uri.parse(whatsappUrl));
                                                                //   // } catch (e) {
                                                                //   //   //To handle error and display error message
                                                                //   //   // Helper.errorSnackBar(context: context, message: "Unable to open whatsapp");
                                                                //   //   await erroMotionToastInfo(context, msg: 'Unable to open whatsapp');
                                                                //   // }
        
                                                                //   final pdfFile = await PdfInvoiceApi.generateWithoutSave(
                                                                //     // printingModel: settings,
                                                                //     printingModel: dashBloc.printSettingsAndHeader.value,
                                                                //     ticketId: tickinfo[0].id.toString(),
                                                                //     isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                                //     barcode: tickinfo[0].barcode ?? '',
                                                                //     checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                                //     checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                                //     slNo: tickinfo[0].id.toString(),
                                                                //     checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //     checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //     duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                                //       startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                                //       endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                                //         DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //         // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                                //         //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                                //         //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //       ),
                                                                //     ),
                                                                //     amount: tickinfo[0].grossAmount ?? '',
                                                                //     vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                                //     vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                                //     discount: tickinfo[0].discountAmount ?? '0',
                                                                //     netAmount: tickinfo[0].payment ?? '0',
                                                                //     carBrand: tickinfo[0].carBrandName ?? '',
                                                                //     carColor: tickinfo[0].carColorName ?? '',
                                                                //     country: tickinfo[0].emiratesName ?? '',
                                                                //     vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                                //   );
        
                                                                //   final folder = await getDownloadsDirectory();
                                                                //   // folder?.listSync();
                                                                //   final filePath = '${folder?.path}/varlet_parking_ticket_${widget.result ?? ''}.pdf';
        
                                                                //   final bytes = await pdfFile?.save();
        
                                                                //   final file = File(filePath);
        
                                                                //   // print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww $bytes');
        
                                                                //   if (bytes != null) {
                                                                //     Loader.hide();
                                                                //     print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww $bytes');
                                                                //     await file.writeAsBytes(bytes);
                                                                //   }
        
                                                                //   if (pdfFile != null) {
                                                                //     try {
                                                                //       // await WhatsappShare.shareFile(
                                                                //       //   // text: 'Whatsapp share text',
                                                                //       //   phone: whatsappNumber,
                                                                //       //   filePath: [file.path],
                                                                //       // );
                                                                //       customLoaderForPdf(context);
                                                                //       await ShareToWhatsapp.sharePDF(file.path, 'application/pdf', whatsappNumber);
                                                                //       // Loader.hide();
        
                                                                //       // Future.delayed(
                                                                //       //   const Duration(seconds: 14),
                                                                //       //   () async {
                                                                //       //     // ignore: prefer_adjacent_string_concatenation
                                                                //       //     final whatsappUrl = 'whatsapp://send?phone=$whatsappNumber' +
                                                                //       //         "&text=${Uri.encodeComponent('${StorageServices.to.getString('companyUrl')}/${StorageServices.to.getInt('locationId')}.html')}";
                                                                //       //     try {
                                                                //       //       await launchUrl(Uri.parse(whatsappUrl));
                                                                //       //     } catch (e) {
                                                                //       //       //To handle error and display error message
                                                                //       //       // Helper.errorSnackBar(context: context, message: "Unable to open whatsapp");
                                                                //       //       await erroMotionToastInfo(context, msg: 'Unable to open whatsapp');
                                                                //       //     }
                                                                //       //   },
                                                                //       // );
                                                                //       // Loader.hide();
                                                                //       // print('3333333333333333333333333333333333333333333333  ${filePath}');
                                                                //     } catch (e) {
                                                                //       Loader.hide();
                                                                //       // print('3333333333333333333333333333333333333333333333 $e ${filePath}');
        
                                                                //       FocusManager.instance.primaryFocus?.unfocus();
        
                                                                //       // await context.read<AccountBloc>().getTokenDetails();
                                                                //       // final locationId = StorageServices.to.getInt('locationId');
                                                                //       // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                                //       if (userType == 'A' || userType == 'ADMIN') {
                                                                //         final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                                //         final locationName = tickinfo[0].locationName ?? '';
                                                                //         final currentLocationId =
                                                                //             allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                                //         await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                                //       } else {
                                                                //         await context.read<AccountBloc>().getTokenDetails();
                                                                //         final locationId = StorageServices.to.getInt('locationId');
                                                                //         await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                                //       }
        
                                                                //       if (settings == null) {
                                                                //         Loader.hide();
                                                                //         await erroMotionToastInfo(context, msg: 'Try Again');
                                                                //         return;
                                                                //       }
        
                                                                //       //print('object');
                                                                //       // Navigator.of(context).pop();
                                                                //       // await shareOnWhatsApp(context);
                                                                //       // ignore: use_build_context_synchronously
                                                                //       try {
                                                                //         // ignore: use_build_context_synchronously
                                                                //         await shareOnWhatsApp(
                                                                //           context,
                                                                //           printingModel: dashBloc.printSettingsAndHeader.value,
                                                                //           ticketId: tickinfo[0].id.toString(),
                                                                //           isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                                //           barcode: tickinfo[0].barcode ?? '',
                                                                //           checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                                //           checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                                //           slNo: tickinfo[0].id.toString(),
                                                                //           checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //           checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //           duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                                //             startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                                //             endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                                //               DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //               // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                                //               //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                                //               //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //             ),
                                                                //           ),
                                                                //           amount: tickinfo[0].grossAmount ?? '',
                                                                //           vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                                //           vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                                //           discount: tickinfo[0].discountAmount ?? '0',
                                                                //           netAmount: tickinfo[0].payment ?? '0',
                                                                //           carBrand: tickinfo[0].carBrandName ?? '',
                                                                //           carColor: tickinfo[0].carColorName ?? '',
                                                                //           country: tickinfo[0].emiratesName ?? '',
                                                                //           vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                                //         );
                                                                //         Loader.hide();
                                                                //       } catch (e) {
                                                                //         Loader.hide();
                                                                //         await erroMotionToastInfo(context, msg: 'Pdf Sharing has some Issues.Please Contact Adminstrator');
                                                                //       }
                                                                //     }
                                                                //   } else {
                                                                //     // print('3333333333333333333333333333333333333333333333');
                                                                //     FocusManager.instance.primaryFocus?.unfocus();
        
                                                                //     // await context.read<AccountBloc>().getTokenDetails();
                                                                //     // final locationId = StorageServices.to.getInt('locationId');
                                                                //     // // ignore: use_build_context_synchronously
                                                                //     // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                                //     if (userType == 'A' || userType == 'ADMIN') {
                                                                //       final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                                //       final locationName = tickinfo[0].locationName ?? '';
                                                                //       print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                                //       final currentLocationId =
                                                                //           allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                                //       await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                                //     } else {
                                                                //       await context.read<AccountBloc>().getTokenDetails();
                                                                //       final locationId = StorageServices.to.getInt('locationId');
                                                                //       await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                                //     }
        
                                                                //     if (settings == null) {
                                                                //       Loader.hide();
                                                                //       await erroMotionToastInfo(context, msg: 'Try Again');
                                                                //       return;
                                                                //     }
                                                                //     //print('object');
                                                                //     // Navigator.of(context).pop();
                                                                //     // await shareOnWhatsApp(context);
        
                                                                //     try {
                                                                //       await shareOnWhatsApp(
                                                                //         context,
                                                                //         // printingModel: settings,
                                                                //         printingModel: dashBloc.printSettingsAndHeader.value,
                                                                //         ticketId: tickinfo[0].id.toString(),
                                                                //         isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                                //         barcode: tickinfo[0].barcode ?? '',
                                                                //         checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                                //         checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                                //         slNo: tickinfo[0].id.toString(),
                                                                //         checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //         checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //         duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                                //           startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                                //           endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                                //             DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //             // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                                //             //     ? DateTime.now().add(UtilityFunctions.convThe width of printing media (thermal papers) is not the same between 80mm thermal receipt printer and 58mm thermal receiptertLocalToDubaiTime())
                                                                //             //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //           ),
                                                                //         ),
                                                                //         amount: tickinfo[0].grossAmount ?? '',
                                                                //         vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                                //         vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                                //         discount: tickinfo[0].discountAmount ?? '0',
                                                                //         netAmount: tickinfo[0].payment ?? '0',
                                                                //         carBrand: tickinfo[0].carBrandName ?? '',
                                                                //         carColor: tickinfo[0].carColorName ?? '',
                                                                //         country: tickinfo[0].emiratesName ?? '',
                                                                //         vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                                //       );
                                                                //       Loader.hide();
                                                                //     } catch (e) {
                                                                //       Loader.hide();
                                                                //       await erroMotionToastInfo(context, msg: 'Pdf Sharing has some Issues.Please Contact Adminstrator');
                                                                //     }
                                                                //   }
                                                                // } else {
                                                                //   // print('3333333333333333333333333333333333333333333333');
                                                                //   FocusManager.instance.primaryFocus?.unfocus();
        
                                                                //   // await context.read<AccountBloc>().getTokenDetails();
                                                                //   // final locationId = StorageServices.to.getInt('locationId');
                                                                //   // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                                //   if (userType == 'A' || userType == 'ADMIN') {
                                                                //     final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                                //     final locationName = tickinfo[0].locationName ?? '';
                                                                //     print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                                //     final currentLocationId =
                                                                //         allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                                //     await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                                //   } else {
                                                                //     await context.read<AccountBloc>().getTokenDetails();
                                                                //     final locationId = StorageServices.to.getInt('locationId');
                                                                //     await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                                //   }
        
                                                                //   if (settings == null) {
                                                                //     Loader.hide();
                                                                //     await erroMotionToastInfo(context, msg: 'Try Again');
                                                                //     return;
                                                                //   }
                                                                //   //print('object');
                                                                //   // Navigator.of(context).pop();
                                                                //   // await shareOnWhatsApp(context);
        
                                                                //   try {
                                                                //     await shareOnWhatsApp(
                                                                //       context,
                                                                //       // printingModel: settings,
                                                                //       printingModel: dashBloc.printSettingsAndHeader.value,
                                                                //       ticketId: tickinfo[0].id.toString(),
                                                                //       isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                                //       barcode: tickinfo[0].barcode ?? '',
                                                                //       checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                                //       checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                                //       slNo: tickinfo[0].id.toString(),
                                                                //       checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //       checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                                //       duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                                //         startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                                //         endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                                //           DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //           // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                                //           //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                                //           //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                                //         ),
                                                                //       ),
                                                                //       amount: tickinfo[0].grossAmount ?? '',
                                                                //       vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                                //       vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                                //       discount: tickinfo[0].discountAmount ?? '0',
                                                                //       netAmount: tickinfo[0].payment ?? '0',
                                                                //       carBrand: tickinfo[0].carBrandName ?? '',
                                                                //       carColor: tickinfo[0].carColorName ?? '',
                                                                //       country: tickinfo[0].emiratesName ?? '',
                                                                //       vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                                //     );
                                                                //     Loader.hide();
                                                                //   } catch (e) {
                                                                //     Loader.hide();
                                                                //     await erroMotionToastInfo(context, msg: 'Pdf Sharing has some Issues.Please Contact Adminstrator');
                                                                //   }
                                                                // }
                                                              },
                                                            ),
                                                            const SizedBox(width: 19),
                                                            CircleAvatar(
                                                              backgroundColor: Colors.purpleAccent.withOpacity(.07),
                                                              child: Icon(
                                                                FontAwesomeIcons.receipt,
                                                                color: Colors.blue[400],
                                                                size: 19,
                                                              ),
                                                            ).ripple(context, () async {
                                                              // FocusManager.instance.primaryFocus?.unfocus();
                                                              // final ticketId = tickinfo[0].id;
                                                              // final companyUrl = StorageServices.to.getString('companyUrl');
                                                              // await Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //     builder: (context) => WebViewContainer(
                                                              //       // url: 'https://demo.varletpark.com/print/whatsapp.php?id=${ticketId}',
                                                              //       url: '$companyUrl/print/whatsapp.php?id=$ticketId',
                                                              //       title: 'Ticket',
                                                              //     ),
                                                              //   ),
                                                              // );
                                                            }),
                                                            // SizedBox(width: 19),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  SizedBox(
                                    width: 400,
                                    child: Text(
                                      'Please Provide Barcode (length from $minValue to $maxValue) To Get Current Details',
                                      style: const TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                  ),
                              ],
                            ),
                            const Spacer(),
        
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
        
                      // if (!isExpanded &&
                      //     widget.result != null &&
                      //     widget.result != '' &&
                      //     isInRange &&
                      //     tickinfo.isNotEmpty &&
                      //     tickinfo[0].dataCheckinTime != '0000-00-00 00:00:00' &&
                      //     snapshot.hasData &&
                      //     widget.isExists)
        
                      // if (!isExpanded && widget.result != null && widget.result != '' && isInRange && tickinfo.isNotEmpty && tickinfo[0].dataCheckinTime != null)
                      if (!isExpanded &&
                          widget.result != null &&
                          widget.result != '' &&
                          isInRange &&
                          tickinfo.isNotEmpty &&
                          (tickinfo[0].dataCheckinTime != null || (tickinfo[0].payment != null && tickinfo[0].payment != '')))
                        InkWell(
                          onTap: () {
                            isExpandedNotifier.value = !isExpandedNotifier.value;
                            isExpandedNotifier.notifyListeners();
                          },
                          child: const Icon(
                            // isExpanded
                            //     ? Icons.keyboard_arrow_up_rounded
                            //     : Icons.keyboard_arrow_down_rounded,
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                        ),
        
                      //
                      // if (isExpanded &&
                      //     widget.result != '' &&
                      //     isInRange &&
                      //     widget.isExists &&
                      //     tickinfo.isNotEmpty &&
                      //     tickinfo[0].dataCheckinTime != '0000-00-00 00:00:00' &&
                      //     snapshot.hasData &&
                      //     widget.isExists)
        
                      // if (isExpanded && widget.result != '' && isInRange && tickinfo.isNotEmpty && tickinfo[0].dataCheckinTime != null)
                      if (isExpanded &&
                          widget.result != '' &&
                          isInRange &&
                          tickinfo.isNotEmpty &&
                          (tickinfo[0].dataCheckinTime != null || (tickinfo[0].payment != null && tickinfo[0].payment != '')))
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: ValueListenableBuilder(
                                      valueListenable: statusNotifier,
                                      builder: (context, status, _) {
                                        return SizedBox(
                                          width: MediaQuery.of(context).size.width / 1.8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InventoryItem(
                                                isActionPage: true,
                                                title: 'Plate No',
                                                // value: 'DXB R 45360',
                                                ticketInfo: tickinfo.isNotEmpty ? tickinfo[0] : null,
                                                otherValue: true,
                                                isLarge: true,
                                              ),
                                              if (tickinfo.isNotEmpty && tickinfo[0].carBrandName != null || tickinfo[0].carColorName != null)
                                                StreamBuilder(
                                                  stream: dashBloc.carBrands,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return LoadingAnimationWidget.prograssiveDots(
                                                        color: Colors.purple,
                                                        size: 32,
                                                      );
                                                    }
                                                    final car = snapshot.data;
        
                                                    String? carBrandSelection({required int? modelId}) {
                                                      final carImagesList = car?.data?.carImages;
                                                      final carImageFileName = carImagesList?.firstWhere((e) => e == '$modelId.png', orElse: () => '-1');
        
                                                      if (modelId == 0 || modelId == null) {
                                                        return null;
                                                      }
        
                                                      // if (carImageFileName == '-1') {
                                                      //   return '${car?.data?.carImageBaseUrl}${car?.data?.carImages?[67]}';
                                                      // } else {
                                                      //   return '${car?.data?.carImageBaseUrl}$carImageFileName';
                                                      // }
                                                      return '${car?.data?.carImageBaseUrl}$carImageFileName';
                                                    }
        
                                                    String? carColorHexCode({required String? colorName}) {
                                                      final carColorsMap = car?.data?.carColors;
                                                      final hexCode = carColorsMap?[colorName];
        
                                                      if (colorName == null) {
                                                        return null;
                                                      }
        
                                                      if (hexCode != null) {
                                                        return hexCode as String;
                                                      }
                                                      return null;
                                                    }
        
                                                    return InventoryItem(
                                                      isActionPage: true,
                                                      title: 'Vehicle',
                                                      // value: 'Toyoto, Yellow',
                                                      otherValue2: true,
                                                      isLarge: true,
                                                      carBrand: tickinfo.isNotEmpty ? carBrandSelection(modelId: tickinfo[0].vehicleModel) : null,
                                                      carColor: tickinfo.isNotEmpty ? carColorHexCode(colorName: tickinfo[0].carColorName?.toLowerCase()) : null,
                                                    );
                                                  },
                                                ),
                                              if (tickinfo.isNotEmpty && tickinfo[0].cvaInName != null && tickinfo[0].cvaInName != '')
                                                InventoryItem(isActionPage: true, title: 'CV In', value: tickinfo[0].cvaInName ?? '', isLarge: true),
        
                                              if (tickinfo.isNotEmpty && tickinfo[0].slot != null && tickinfo[0].slot != '' && tickinfo[0].slot != '0')
                                                InventoryItem(isActionPage: true, title: 'Parking No:', value: tickinfo[0].slot, isLarge: true),
        
                                              if (tickinfo.isNotEmpty && tickinfo[0].cvaOutName != null && tickinfo[0].cvaOutName != '')
                                                InventoryItem(isActionPage: true, title: 'CV Out', value: tickinfo[0].cvaOutName ?? '', isLarge: true),
        
                                              if (tickinfo.isNotEmpty && tickinfo[0].payment != null && tickinfo[0].payment != '')
                                                InventoryItem(isActionPage: true, title: 'Payment Method', value: tickinfo[0].paymentPaidMethod, isLarge: true),
        
                                              if (tickinfo.isNotEmpty && tickinfo[0].payment != null && tickinfo[0].payment != '')
                                                StreamBuilder(
                                                  stream: dashBloc.getSettingsStream,
                                                  builder: (context, snapshot) {
                                                    final settings = snapshot.data;
                                                    return InventoryItem(isActionPage: true, title: 'Payment', value: '${tickinfo[0].payment} ${settings?.data?.cURRENCY}', isLarge: true);
                                                  },
                                                ),
        
                                              // if (statusNotifier.value != 'Intial')
        
                                              // Container(
                                              //   padding: EdgeInsets.symmetric(
                                              //     horizontal: 5,
                                              //     vertical: 5,
                                              //   ),
                                              //   decoration: BoxDecoration(
                                              //     // color: Colors.green[400],
                                              //     color: getTicketStatusColor(tickinfo: tickinfo),
                                              //     borderRadius: BorderRadius.circular(6),
                                              //   ),
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(
                                              //         Icons.check_circle_outline_outlined,
                                              //         size: 17,
                                              //         color: Colors.white,
                                              //       ),
                                              //       SizedBox(width: 4),
                                              //       Text(
                                              //         checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.checkIn ||
                                              //                 checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.checkIn ||
                                              //                 checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.vehicleArrived
                                              //             ? '${checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)} Successfully'
                                              //             : checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.parked
                                              //                 ? 'Vehicle Parked'
                                              //                 : checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.ontheWay ||
                                              //                         checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.requested ||
                                              //                         checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.ontheWay
                                              //                     ? 'Car is ${checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)}'
                                              //                     : 'Car is ${checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)}',
                                              //         // statusNotifier.value == ConstVariables.checkIn ||
                                              //         //         statusNotifier.value == ConstVariables.checkIn ||
                                              //         //         statusNotifier.value == ConstVariables.vehicleArrived
                                              //         //     ? '${statusNotifier.value} Successfully'
                                              //         //     : statusNotifier.value == ConstVariables.parked
                                              //         //         ? 'Vehicle Parked'
                                              //         //         : statusNotifier.value == ConstVariables.ontheWay ||
                                              //         //                 statusNotifier.value == ConstVariables.requested ||
                                              //         //                 statusNotifier.value == ConstVariables.ontheWay
                                              //         //             ? 'Car is ${statusNotifier.value}'
                                              //         //             : '',
                                              //         style: TextStyle(
                                              //           color: Colors.white,
                                              //           fontSize: 12,
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 20,
                                        // width: 80,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.green[700],
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: const Text(
                                          'Scan E-Ticket',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          // child: Image.asset(
                                          //   'assets/images/QR_image.png',
                                          //   width: 140,
                                          //   fit: BoxFit.fill,
                                          // ),
                                          child: QrImageView(
                                            data: 'https://demo.varletpark.com/print/whatsapp.php?id=${tickinfo[0].id}',
                                            // version: QrVersions.auto,
                                            size: 110,
                                          ),
                                        ),
                                      ),
                                      // StreamBuilder(
                                      //   stream: dashBloc.printSettingsAndHeader,
                                      //   builder: (context, snapshot) {
                                      //     final settings = snapshot.data;
                                      //     return Row(
                                      //       mainAxisAlignment: MainAxisAlignment.end,
                                      //       children: [
                                      //         // SizedBox(width: 19),
                                      //         InkWell(
                                      //           onLongPress: () {
                                      //             bluetoothPrinting(settings: settings, tickinfo: tickinfo);
                                      //           },
        
                                      //           // ignore: unnecessary_statements
                                      //           onTap: () async {
                                      //             if (settings == null) return;
                                      //             final macAddr = StorageServices.to.getString('blue_mac');
                                      //             print('macAddr $macAddr');
                                      //             if (macAddr == '') {
                                      //               bluetoothPrinting(settings: settings, tickinfo: tickinfo);
                                      //               return;
                                      //             }
        
                                      //             // ignore: inference_failure_on_function_invocation
                                      //             await showDialog(
                                      //               barrierDismissible: false,
                                      //               context: context,
                                      //               builder: (BuildContext context) {
                                      //                 return AlertDialog(
                                      //                   shape: RoundedRectangleBorder(
                                      //                     borderRadius: BorderRadius.circular(15),
                                      //                   ),
                                      //                   actionsPadding: EdgeInsets.symmetric(
                                      //                     horizontal: 12,
                                      //                     vertical: 15,
                                      //                   ),
                                      //                   iconPadding: EdgeInsets.symmetric(horizontal: 12),
                                      //                   buttonPadding: EdgeInsets.symmetric(horizontal: 12),
                                      //                   contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                      //                   // insetPadding: EdgeInsets.only(
                                      //                   //   bottom: 50,
                                      //                   //   left: 15,
                                      //                   //   right: 15,
                                      //                   // ),
                                      //                   titlePadding: EdgeInsets.symmetric(
                                      //                     horizontal: 12,
                                      //                     vertical: 10,
                                      //                   ),
                                      //                   title: Text(
                                      //                     'Print Ticket',
                                      //                     style: TextStyle(
                                      //                       fontSize: 13,
                                      //                       color: Colors.orange[800],
                                      //                     ),
                                      //                   ),
                                      //                   content: Column(
                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                      //                     mainAxisSize: MainAxisSize.min,
                                      //                     children: [
                                      //                       Text(
                                      //                         'Are you sure to print ticket?',
                                      //                         style: TextStyle(fontSize: 14),
                                      //                       ),
                                      //                       Text(
                                      //                         'Long press to go to bluetooth settings',
                                      //                         style: TextStyle(fontSize: 8),
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                   actions: <Widget>[
                                      //                     SizedBox(
                                      //                       height: 27,
                                      //                       child: OutlinedButton(
                                      //                         style: OutlinedButton.styleFrom(
                                      //                           side: const BorderSide(
                                      //                             color: Color.fromARGB(255, 209, 174, 226),
                                      //                           ),
                                      //                           // backgroundColor:
                                      //                           //     Color.fromARGB(255, 146, 80, 177),
                                      //                           foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                                      //                         ),
                                      //                         onPressed: () async {
                                      //                           await PrintBluetoothThermal.pairedBluetooths.then((listResult) async {
                                      //                             customLoader(context);
                                      //                             print('11111111111111111111111111111111111111');
                                      //                             print('paired bluetooth ${listResult.first.macAdress}');
                                      //                             // final mac = value.first.macAdress;
                                      //                             await PrintBluetoothThermal.disconnect;
                                      //                             final enabled = await PrintBluetoothThermal.bluetoothEnabled;
                                      //                             print('bluetooth enabled: $enabled');
                                      //                             final blueConnect = await PrintBluetoothThermal.connect(macPrinterAddress: macAddr);
                                      //                             print('blueConnect : $blueConnect');
        
                                      //                             final conexionStatus = await PrintBluetoothThermal.connectionStatus;
        
                                      //                             print("connection status: $conexionStatus");
        
                                      //                             if (!conexionStatus) {
                                      //                               erroMotionToastInfo(context, msg: "Can't able to connect. Please check $macAddr is turned on ", height: 50);
                                      //                               Loader.hide();
                                      //                               return;
                                      //                             }
        
                                      //                             final ticket = await testTicket(
                                      //                               printModel: settings,
                                      //                               barcode: tickinfo[0].barcode ?? '',
                                      //                               slNo: (tickinfo[0].id ?? '').toString(),
                                      //                               checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                      //                               checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                      //                               checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                      //                               checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                      //                               duration: UtilityFunctions.getDurationForBlutoothPrint(
                                      //                                 startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                      //                                 endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                                      //                               ),
                                      //                               amount: tickinfo[0].grossAmount ?? '',
                                      //                               vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                      //                               vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                      //                               discount: tickinfo[0].discountAmount ?? '0',
                                      //                               netAmount: tickinfo[0].payment ?? '0',
                                      //                               isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                      //                               carBrand: tickinfo[0].carBrandName ?? '',
                                      //                               carColor: tickinfo[0].carColorName ?? '',
                                      //                             );
        
                                      //                             final result = await PrintBluetoothThermal.writeBytes(ticket);
                                      //                             Loader.hide();
                                      //                           });
                                      //                           Navigator.pop(context);
                                      //                         },
                                      //                         child: Text(
                                      //                           'Yes',
                                      //                           style: TextStyle(fontSize: 13),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                     SizedBox(
                                      //                       height: 27,
                                      //                       child: OutlinedButton(
                                      //                         style: OutlinedButton.styleFrom(
                                      //                           side: const BorderSide(
                                      //                             color: Color.fromARGB(255, 209, 174, 226),
                                      //                           ),
                                      //                           // backgroundColor:
                                      //                           //     Color.fromARGB(255, 146, 80, 177),
                                      //                           foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                                      //                         ),
                                      //                         onPressed: () {
                                      //                           Navigator.pop(context);
                                      //                         },
                                      //                         child: Text(
                                      //                           'No',
                                      //                           style: TextStyle(fontSize: 13),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 );
                                      //               },
                                      //             );
                                      //           },
                                      //           child: Icon(
                                      //             FontAwesomeIcons.print,
                                      //             color: StorageServices.to.getString('blue_mac').isNotEmpty ? Colors.green[700] : Colors.grey,
                                      //             size: 19,
                                      //           ),
        
                                      //           // .ripple(context, () {
                                      //           //   if (settings == null) return;
        
                                      //           //   // );
                                      //           // }),
                                      //         ),
                                      //         SizedBox(width: 19),
                                      //         Icon(
                                      //           FontAwesomeIcons.whatsapp,
                                      //           color: Colors.green[400],
                                      //           size: 19,
                                      //         ).ripple(
                                      //           context,
                                      //           () async {
                                      //             if (settings == null) return;
                                      //             //print('object');
                                      //             // Navigator.of(context).pop();
                                      //             // await shareOnWhatsApp(context);
                                      //             await shareOnWhatsApp(
                                      //               context,
                                      //               printingModel: settings,
                                      //               isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                      //               barcode: tickinfo[0].barcode ?? '',
                                      //               checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                      //               checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                      //               slNo: tickinfo[0].id.toString(),
                                      //               checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                      //               checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                      //               duration: UtilityFunctions.getDurationForBlutoothPrint(
                                      //                 startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                      //                 endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                                      //               ),
                                      //               amount: tickinfo[0].grossAmount ?? '',
                                      //               vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                      //               vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                      //               discount: tickinfo[0].discountAmount ?? '0',
                                      //               netAmount: tickinfo[0].payment ?? '0',
                                      //               carBrand: tickinfo[0].carBrandName ?? '',
                                      //               carColor: tickinfo[0].carColorName ?? '',
                                      //             );
                                      //           },
                                      //         ),
                                      //         SizedBox(width: 19),
                                      //         Icon(
                                      //           FontAwesomeIcons.receipt,
                                      //           color: Colors.blue[400],
                                      //           size: 19,
                                      //         ).ripple(context, () async {
                                      //           final ticketId = tickinfo[0].id;
                                      //           Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //               builder: (context) => WebViewContainer(
                                      //                 url: 'https://demo.varletpark.com/print/whatsapp.php?id=${ticketId}',
                                      //                 title: 'Ticket',
                                      //               ),
                                      //             ),
                                      //           );
                                      //         }),
                                      //         // SizedBox(width: 19),
                                      //       ],
                                      //     );
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                // padding: EdgeInsets.only(left: 16, right: 25,top: 8),
                                padding: const EdgeInsets.only(right: 20, top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        // color: Colors.green[400],
                                        color: getTicketStatusColor(tickinfo: tickinfo),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 17,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.checkIn ||
                                                    checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.checkIn ||
                                                    checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.vehicleArrived
                                                ? '${checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)} Successfully'
                                                : checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.parked
                                                    ? 'Vehicle Parked'
                                                    : checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.ontheWay ||
                                                            checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.requested ||
                                                            checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime) == ConstVariables.ontheWay
                                                        ? 'Car is ${checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)}'
                                                        : 'Car is ${checkoutStatus(tickinfo[0].checkoutStatus ?? 'N', tickinfo[0].dataCheckinTime)}',
                                            // statusNotifier.value == ConstVariables.checkIn ||
                                            //         statusNotifier.value == ConstVariables.checkIn ||
                                            //         statusNotifier.value == ConstVariables.vehicleArrived
                                            //     ? '${statusNotifier.value} Successfully'
                                            //     : statusNotifier.value == ConstVariables.parked
                                            //         ? 'Vehicle Parked'
                                            //         : statusNotifier.value == ConstVariables.ontheWay ||
                                            //                 statusNotifier.value == ConstVariables.requested ||
                                            //                 statusNotifier.value == ConstVariables.ontheWay
                                            //             ? 'Car is ${statusNotifier.value}'
                                            //             : '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
        
                                    // Buttons
                                    StreamBuilder(
                                      stream: dashBloc.printSettingsAndHeader,
                                      builder: (context, snapshot) {
                                        final settings = snapshot.data;
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // SizedBox(width: 19),
                                            const SizedBox(width: 15),
                                            InkWell(
                                              onLongPress: () async {
                                                FocusManager.instance.primaryFocus?.unfocus();
        
                                                // await context.read<AccountBloc>().getTokenDetails();
                                                // final locationId = StorageServices.to.getInt('locationId');
                                                // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                // await context.read<AccountBloc>().getTokenDetails();
                                                // final locationId = StorageServices.to.getInt('locationId');
                                                // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                if (userType == 'A' || userType == 'ADMIN') {
                                                  final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                  final locationName = tickinfo[0].locationName ?? '';
                                                  final currentLocationId = allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                } else {
                                                  await context.read<AccountBloc>().getTokenDetails();
                                                  final locationId = StorageServices.to.getInt('locationId');
                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                }
        
                                                if (settings == null) {
                                                  Loader.hide();
                                                  await erroMotionToastInfo(context, msg: 'Try Again');
                                                  return;
                                                }
        
                                                await bluetoothPrinting(settings: dashBloc.printSettingsAndHeader.value, tickinfo: tickinfo);
                                              },
        
                                              // ignore: unnecessary_statements
                                              onTap: () async {
                                                // FocusManager.instance.primaryFocus?.unfocus();
                                                customLoaderForPrintReceipt(context);
                                                FocusManager.instance.primaryFocus?.unfocus();
        
                                                if (userType == 'A' || userType == 'ADMIN') {
                                                  final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                  final locationName = tickinfo[0].locationName ?? '';
                                                  print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                  final currentLocationId = allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                } else {
                                                  await context.read<AccountBloc>().getTokenDetails();
                                                  final locationId = StorageServices.to.getInt('locationId');
                                                  await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                }
        
                                                // if (widget.allPermissions != null &&
                                                //     widget.allPermissions!.data != null &&
                                                //     widget.allPermissions!.data!.isNotEmpty &&
                                                //     widget.allPermissions!.data![0].ticketMobilePrint == 'N') {
                                                //   await erroMotionToastInfo(context, msg: 'No Permission to print ticket');
                                                //   return;
                                                // }
        
                                                if (settings == null) {
                                                  Loader.hide();
                                                  await erroMotionToastInfo(context, msg: 'Try Again');
                                                  return;
                                                }
        
                                                final macAddr = StorageServices.to.getString('blue_mac');
                                                print('macAddr $macAddr');
                                                if (macAddr == '') {
                                                  await bluetoothPrinting(settings: dashBloc.printSettingsAndHeader.value, tickinfo: tickinfo);
                                                  return;
                                                }
        
                                                Loader.hide();
        
                                                // ignore: inference_failure_on_function_invocation, use_build_context_synchronously
                                                await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),
                                                      actionsPadding: const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 15,
                                                      ),
                                                      iconPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                      buttonPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                      // insetPadding: EdgeInsets.only(
                                                      //   bottom: 50,
                                                      //   left: 15,
                                                      //   right: 15,
                                                      // ),
                                                      titlePadding: const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 10,
                                                      ),
                                                      title: Text(
                                                        'Print Ticket',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.orange[800],
                                                        ),
                                                      ),
                                                      content: const Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Are you sure to print ticket?',
                                                            style: TextStyle(fontSize: 14),
                                                          ),
                                                          Text(
                                                            'Long press to go to bluetooth settings',
                                                            style: TextStyle(fontSize: 8),
                                                          ),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        SizedBox(
                                                          height: 27,
                                                          child: OutlinedButton(
                                                            style: OutlinedButton.styleFrom(
                                                              side: const BorderSide(
                                                                color: Color.fromARGB(255, 209, 174, 226),
                                                              ),
                                                              // backgroundColor:
                                                              //     Color.fromARGB(255, 146, 80, 177),
                                                              foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                                                            ),
                                                            onPressed: () async {
                                                              // await PrintBluetoothThermal.pairedBluetooths.then((listResult) async {
                                                              //   // customLoader(context);
                                                              //   customLoaderForPrintReceipt(context);
                                                              //   print('11111111111111111111111111111111111111');
                                                              //   print('paired bluetooth ${listResult.first.macAdress}');
                                                              //   // final mac = value.first.macAdress;
                                                              //   await PrintBluetoothThermal.disconnect;
                                                              //   final enabled = await PrintBluetoothThermal.bluetoothEnabled;
                                                              //   print('bluetooth enabled: $enabled');
                                                              //   final blueConnect = await PrintBluetoothThermal.connect(macPrinterAddress: macAddr);
                                                              //   print('blueConnect : $blueConnect');
        
                                                              //   final conexionStatus = await PrintBluetoothThermal.connectionStatus;
        
                                                              //   print("connection status: $conexionStatus");
        
                                                              //   if (!conexionStatus) {
                                                              //     await erroMotionToastInfo(context, msg: "Can't able to connect. Please check $macAddr is turned on ", height: 50);
                                                              //     Loader.hide();
                                                              //     return;
                                                              //   }
        
                                                              //   // not important
                                                              //   Loader.hide();
        
                                                              //   final ticket = await testTicket(
                                                              //     printModel: dashBloc.printSettingsAndHeader.value,
                                                              //     barcode: tickinfo[0].barcode ?? '',
                                                              //     slNo: (tickinfo[0].id ?? '').toString(),
                                                              //     checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                              //     checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                              //     checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                              //     checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                              //     duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                              //       startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                              //       endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                              //         DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                              //         // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                              //         //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                              //         //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                              //       ),
                                                              //     ),
                                                              //     amount: tickinfo[0].grossAmount ?? '',
                                                              //     vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                              //     vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                              //     discount: tickinfo[0].discountAmount ?? '0',
                                                              //     netAmount: tickinfo[0].payment ?? '0',
                                                              //     isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                              //     carBrand: tickinfo[0].carBrandName ?? '',
                                                              //     carColor: tickinfo[0].carColorName ?? '',
                                                              //   );
        
                                                              //   final result = await PrintBluetoothThermal.writeBytes(ticket);
                                                              //   Loader.hide();
                                                              // });
                                                              // Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'Yes',
                                                              style: TextStyle(fontSize: 13),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 27,
                                                          child: OutlinedButton(
                                                            style: OutlinedButton.styleFrom(
                                                              side: const BorderSide(
                                                                color: Color.fromARGB(255, 209, 174, 226),
                                                              ),
                                                              // backgroundColor:
                                                              //     Color.fromARGB(255, 146, 80, 177),
                                                              foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'No',
                                                              style: TextStyle(fontSize: 13),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.purpleAccent.withOpacity(.07),
                                                maxRadius: 15,
                                                child: Icon(
                                                  FontAwesomeIcons.print,
                                                  // color: StorageServices.to.getString('blue_mac').isNotEmpty ? Colors.green[700] : Colors.grey,
                                                  color: StorageServices.to.getString('blue_mac').isNotEmpty ? Colors.purple[700] : Colors.grey,
                                                  // size: 19,
                                                  size: 17,
                                                ),
                                              ),
        
                                              // .ripple(context, () {
                                              //   if (settings == null) return;
        
                                              //   // );
                                              // }),
                                            ),
                                            // SizedBox(width: 19),
                                            const SizedBox(width: 8),
                                            CircleAvatar(
                                              backgroundColor: Colors.purpleAccent.withOpacity(.07),
                                              maxRadius: 15,
                                              child: Icon(
                                                FontAwesomeIcons.whatsapp,
                                                // color: Colors.green[400],
                                                color: Colors.green[700],
                                                // size: 19,
                                                size: 17,
                                              ),
                                            ).ripple(
                                              context,
                                              () async {
                                                // customLoaderForPdf(context);
                                                // FocusManager.instance.primaryFocus?.unfocus();
        
                                                // // await context.read<AccountBloc>().getTokenDetails();
                                                // // final locationId = StorageServices.to.getInt('locationId');
                                                // // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                // if (userType == 'A' || userType == 'ADMIN') {
                                                //   final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                //   final locationName = tickinfo[0].customerMobile ?? '';
                                                //   print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                //   final currentLocationId = allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                //   await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                // } else {
                                                //   await context.read<AccountBloc>().getTokenDetails();
                                                //   final locationId = StorageServices.to.getInt('locationId');
                                                //   await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                // }
                                                // final whatsappNumber = tickinfo[0].customerMobile ?? '';
        
                                                // if (whatsappNumber != '') {
                                                //   FocusManager.instance.primaryFocus?.unfocus();
                                                //   // var whatsappUrl = "whatsapp://send?phone=${_countryCodeController.text + _phoneController.text}" + "&text=${Uri.encodeComponent(_messageController.text)}";
                                                //   // var whatsappUrl = "whatsapp://send?phone=$whatsappNumber" + "&text=${Uri.encodeComponent('Hi')}";
                                                //   // try {
                                                //   //   await launchUrl(Uri.parse(whatsappUrl));
                                                //   // } catch (e) {
                                                //   //   //To handle error and display error message
                                                //   //   // Helper.errorSnackBar(context: context, message: "Unable to open whatsapp");
                                                //   //   await erroMotionToastInfo(context, msg: 'Unable to open whatsapp');
                                                //   // }
        
                                                //   final pdfFile = await PdfInvoiceApi.generateWithoutSave(
                                                //     // printingModel: settings,
                                                //     printingModel: dashBloc.printSettingsAndHeader.value,
                                                //     ticketId: tickinfo[0].id.toString(),
                                                //     isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                //     barcode: tickinfo[0].barcode ?? '',
                                                //     checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                //     checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                //     slNo: tickinfo[0].id.toString(),
                                                //     checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //     checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //     duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                //       startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                //       endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                //         DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //         // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                //         //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                //         //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //       ),
                                                //     ),
                                                //     amount: tickinfo[0].grossAmount ?? '',
                                                //     vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                //     vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                //     discount: tickinfo[0].discountAmount ?? '0',
                                                //     netAmount: tickinfo[0].payment ?? '0',
                                                //     carBrand: tickinfo[0].carBrandName ?? '',
                                                //     carColor: tickinfo[0].carColorName ?? '',
                                                //     country: tickinfo[0].emiratesName ?? '',
                                                //     vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                //   );
        
                                                //   final folder = await getDownloadsDirectory();
                                                //   // folder?.listSync();
                                                //   final filePath = '${folder?.path}/varlet_parking_ticket_${widget.result ?? ''}.pdf';
        
                                                //   final bytes = await pdfFile?.save();
        
                                                //   final file = File(filePath);
        
                                                //   // print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww $bytes');
        
                                                //   if (bytes != null) {
                                                //     Loader.hide();
                                                //     print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww $bytes');
                                                //     await file.writeAsBytes(bytes);
                                                //   }
        
                                                //   if (pdfFile != null) {
                                                //     try {
                                                //       // await WhatsappShare.shareFile(
                                                //       //   // text: 'Whatsapp share text',
                                                //       //   phone: whatsappNumber,
                                                //       //   filePath: [file.path],
                                                //       // );
                                                //       customLoaderForPdf(context);
                                                //       await ShareToWhatsapp.sharePDF(file.path, 'application/pdf', whatsappNumber);
                                                //       // Loader.hide();
                                                //       // Future.delayed(
                                                //       //   const Duration(seconds: 14),
                                                //       //   () async {
                                                //       //     // ignore: prefer_adjacent_string_concatenation
                                                //       //     final whatsappUrl = 'whatsapp://send?phone=$whatsappNumber' +
                                                //       //         "&text=${Uri.encodeComponent('${StorageServices.to.getString('companyUrl')}/${StorageServices.to.getInt('locationId')}.html')}";
                                                //       //     try {
                                                //       //       await launchUrl(Uri.parse(whatsappUrl));
                                                //       //     } catch (e) {
                                                //       //       //To handle error and display error message
                                                //       //       // Helper.errorSnackBar(context: context, message: "Unable to open whatsapp");
                                                //       //       await erroMotionToastInfo(context, msg: 'Unable to open whatsapp');
                                                //       //     }
                                                //       //   },
                                                //       // );
                                                //       // Loader.hide();
                                                //       // print('3333333333333333333333333333333333333333333333  ${filePath}');
                                                //     } catch (e) {
                                                //       Loader.hide();
                                                //       // print('3333333333333333333333333333333333333333333333 $e ${filePath}');
        
                                                //       FocusManager.instance.primaryFocus?.unfocus();
        
                                                //       // await context.read<AccountBloc>().getTokenDetails();
                                                //       // final locationId = StorageServices.to.getInt('locationId');
                                                //       // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                //       if (userType == 'A' || userType == 'ADMIN') {
                                                //         final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                //         final locationName = tickinfo[0].locationName ?? '';
                                                //         final currentLocationId = allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                //         await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                //       } else {
                                                //         await context.read<AccountBloc>().getTokenDetails();
                                                //         final locationId = StorageServices.to.getInt('locationId');
                                                //         await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                //       }
        
                                                //       if (settings == null) {
                                                //         Loader.hide();
                                                //         await erroMotionToastInfo(context, msg: 'Try Again');
                                                //         return;
                                                //       }
                                                //       //print('object');
                                                //       // Navigator.of(context).pop();
                                                //       // await shareOnWhatsApp(context);
                                                //       // ignore: use_build_context_synchronously
                                                //       try {
                                                //         // ignore: use_build_context_synchronously
                                                //         await shareOnWhatsApp(
                                                //           context,
                                                //           // printingModel: settings,
                                                //           printingModel: dashBloc.printSettingsAndHeader.value,
                                                //           ticketId: tickinfo[0].id.toString(),
                                                //           isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                //           barcode: tickinfo[0].barcode ?? '',
                                                //           checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                //           checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                //           slNo: tickinfo[0].id.toString(),
                                                //           checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //           checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //           duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                //             startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                //             endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                //               DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //               // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                //               //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                //               //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //             ),
                                                //           ),
                                                //           amount: tickinfo[0].grossAmount ?? '',
                                                //           vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                //           vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                //           discount: tickinfo[0].discountAmount ?? '0',
                                                //           netAmount: tickinfo[0].payment ?? '0',
                                                //           carBrand: tickinfo[0].carBrandName ?? '',
                                                //           carColor: tickinfo[0].carColorName ?? '',
                                                //           country: tickinfo[0].emiratesName ?? '',
                                                //           vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                //         );
                                                //         Loader.hide();
                                                //       } catch (e) {
                                                //         Loader.hide();
                                                //         await erroMotionToastInfo(context, msg: 'Pdf Sharing has some Issues.Please Contact Adminstrator');
                                                //       }
                                                //     }
                                                //   } else {
                                                //     // print('3333333333333333333333333333333333333333333333');
                                                //     FocusManager.instance.primaryFocus?.unfocus();
        
                                                //     // await context.read<AccountBloc>().getTokenDetails();
                                                //     // final locationId = StorageServices.to.getInt('locationId');
                                                //     // // ignore: use_build_context_synchronously
                                                //     // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                //     if (userType == 'A' || userType == 'ADMIN') {
                                                //       final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                //       final locationName = tickinfo[0].locationName ?? '';
                                                //       print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                //       final currentLocationId = allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                //       await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                //     } else {
                                                //       await context.read<AccountBloc>().getTokenDetails();
                                                //       final locationId = StorageServices.to.getInt('locationId');
                                                //       await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                //     }
        
                                                //     if (settings == null) {
                                                //       Loader.hide();
                                                //       await erroMotionToastInfo(context, msg: 'Try Again');
                                                //       return;
                                                //     }
                                                //     //print('object');
                                                //     // Navigator.of(context).pop();
                                                //     // await shareOnWhatsApp(context);
                                                //     // ignore: use_build_context_synchronously
                                                //     try {
                                                //       // ignore: use_build_context_synchronously
                                                //       await shareOnWhatsApp(
                                                //         context,
                                                //         // printingModel: settings,
                                                //         printingModel: dashBloc.printSettingsAndHeader.value,
                                                //         ticketId: tickinfo[0].id.toString(),
                                                //         isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                //         barcode: tickinfo[0].barcode ?? '',
                                                //         checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                //         checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                //         slNo: tickinfo[0].id.toString(),
                                                //         checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //         checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //         duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                //           startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                //           endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                //             DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //             // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                //             //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                //             //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //           ),
                                                //         ),
                                                //         amount: tickinfo[0].grossAmount ?? '',
                                                //         vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                //         vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                //         discount: tickinfo[0].discountAmount ?? '0',
                                                //         netAmount: tickinfo[0].payment ?? '0',
                                                //         carBrand: tickinfo[0].carBrandName ?? '',
                                                //         carColor: tickinfo[0].carColorName ?? '',
                                                //         country: tickinfo[0].emiratesName ?? '',
                                                //         vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                //       );
                                                //       Loader.hide();
                                                //     } catch (e) {
                                                //       Loader.hide();
                                                //       await erroMotionToastInfo(context, msg: 'Pdf Sharing has some Issues.Please Contact Adminstrator');
                                                //     }
                                                //   }
                                                // } else {
                                                //   FocusManager.instance.primaryFocus?.unfocus();
        
                                                //   // await context.read<AccountBloc>().getTokenDetails();
                                                //   // final locationId = StorageServices.to.getInt('locationId');
                                                //   // await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
        
                                                //   if (userType == 'A' || userType == 'ADMIN') {
                                                //     final allLocationsAndUsers = await context.read<SearchBloc>().getUsersAllLocationAndUsers(orderBy: 'parking_time');
                                                //     final locationName = tickinfo[0].locationName ?? '';
                                                //     print('22222222222222222222222222222222222 ${allLocationsAndUsers?.data?.locations?.map((e) => e.departmentName)}');
                                                //     final currentLocationId = allLocationsAndUsers?.data?.locations?.where((e) => e.departmentName == locationName).first.departmentId;
                                                //     await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: currentLocationId!);
                                                //   } else {
                                                //     await context.read<AccountBloc>().getTokenDetails();
                                                //     final locationId = StorageServices.to.getInt('locationId');
                                                //     await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);
                                                //   }
        
                                                //   if (settings == null) {
                                                //     Loader.hide();
                                                //     await erroMotionToastInfo(context, msg: 'Try Again');
                                                //     return;
                                                //   }
        
                                                //   // ignore: use_build_context_synchronously
                                                //   try {
                                                //     // ignore: use_build_context_synchronously
                                                //     await shareOnWhatsApp(
                                                //       context,
                                                //       // printingModel: settings,
                                                //       printingModel: dashBloc.printSettingsAndHeader.value,
                                                //       ticketId: tickinfo[0].id.toString(),
                                                //       isCheckout: tickinfo[0].checkoutStatus == 'Y',
                                                //       barcode: tickinfo[0].barcode ?? '',
                                                //       checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
                                                //       checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
                                                //       slNo: tickinfo[0].id.toString(),
                                                //       checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //       checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
                                                //       duration: UtilityFunctions.getDurationForBlutoothPrint(
                                                //         startTimeString: tickinfo[0].initialCheckinTime ?? '',
                                                //         endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
                                                //           DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //           // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                //           //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                //           //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                //         ),
                                                //       ),
                                                //       amount: tickinfo[0].grossAmount ?? '',
                                                //       vatAmount: tickinfo[0].vatAmount ?? 0.0,
                                                //       vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
                                                //       discount: tickinfo[0].discountAmount ?? '0',
                                                //       netAmount: tickinfo[0].payment ?? '0',
                                                //       carBrand: tickinfo[0].carBrandName ?? '',
                                                //       carColor: tickinfo[0].carColorName ?? '',
                                                //       country: tickinfo[0].emiratesName ?? '',
                                                //       vehicleNumber: tickinfo[0].vehicleNumber ?? '',
                                                //     );
                                                //     Loader.hide();
                                                //   } catch (e) {
                                                //     Loader.hide();
                                                //     await erroMotionToastInfo(context, msg: 'Pdf Sharing has some Issues.Please Contact Adminstrator');
                                                //   }
                                                // }
        
                                                //print('object');
                                                // Navigator.of(context).pop();
                                                // await shareOnWhatsApp(context);
                                              },
                                            ),
                                            // SizedBox(width: 19),
                                            const SizedBox(width: 8),
                                            CircleAvatar(
                                              backgroundColor: Colors.purpleAccent.withOpacity(.07),
                                              maxRadius: 15,
                                              child: Icon(
                                                FontAwesomeIcons.receipt,
                                                color: Colors.blue[400],
                                                // size: 19,
                                                size: 17,
                                              ),
                                            ).ripple(context, () async {
                                              // FocusManager.instance.primaryFocus?.unfocus();
        
                                              // final ticketId = tickinfo[0].id;
                                              // final companyUrl = StorageServices.to.getString('companyUrl');
                                              // await Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => WebViewContainer(
                                              //       url: '$companyUrl/print/whatsapp.php?id=$ticketId',
                                              //       title: 'Ticket',
                                              //     ),
                                              //   ),
                                              // );
                                            }),
                                            // SizedBox(width: 19),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      // if (isExpanded && widget.result != null && widget.result != '' && tickinfo.isNotEmpty && tickinfo[0].dataCheckinTime != null && snapshot.hasData)
                      if (isExpanded &&
                          widget.result != null &&
                          widget.result != '' &&
                          tickinfo.isNotEmpty &&
                          (tickinfo[0].dataCheckinTime != null || (tickinfo[0].payment != null && tickinfo[0].payment != '')) &&
                          snapshot.hasData)
                        // snapshot.hasData &&
                        // widget.isExists)
                        InkWell(
                          onTap: () {
                            isExpandedNotifier.value = !isExpandedNotifier.value;
                            isExpandedNotifier.notifyListeners();
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 20,
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> bluetoothPrinting({required List<TicketInfo> tickinfo, PrintingHeadingModel? settings}) async {
    if (settings == null) {
      Loader.hide();
      await erroMotionToastInfo(context, msg: 'Try Again');
      return;
    } else {
      Loader.hide();
    }

    // await Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => PrintPageIos2(
    //       printingModel: settings,
    //       barcode: tickinfo[0].barcode ?? '',
    //       slNo: (tickinfo[0].id ?? '').toString(),
    //       checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
    //       checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
    //       checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
    //       checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
    //       duration: UtilityFunctions.getDurationForBlutoothPrint(
    //         startTimeString: tickinfo[0].initialCheckinTime ?? '',
    //         endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
    //           UtilityFunctions.convertLocalToDubaiTime().isNegative
    //               ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
    //               : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
    //         ),
    //       ),
    //       amount: tickinfo[0].grossAmount ?? '',
    //       vatAmount: tickinfo[0].vatAmount ?? 0.0,
    //       vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
    //       discount: tickinfo[0].discountAmount ?? '0',
    //       netAmount: tickinfo[0].payment ?? '0',
    //       isCheckout: tickinfo[0].checkoutStatus == 'Y',
    //       carBrand: tickinfo[0].carBrandName ?? '',
    //       carColor: tickinfo[0].carColorName ?? '',
    //       country: tickinfo[0].emiratesName ?? '',
    //       vehicleNumber: tickinfo[0].vehicleNumber ?? '',
    //     ),
    //     // transitionDuration: Duration(seconds: 8),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       const begin = Offset(0.0, 1.0);
    //       const end = Offset.zero;
    //       const curve = Curves.ease;
    //       final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //       return SlideTransition(
    //         transformHitTests: false,
    //         position: animation.drive(tween),
    //         child: child,
    //       );
    //     },
    //   ),
    //   //   MaterialPageRoute(
    //   //     builder: (context) => PrintPageIos2(
    //   //       printingModel: settings,
    //   //       barcode: tickinfo[0].barcode ?? '',
    //   //       slNo: (tickinfo[0].id ?? '').toString(),
    //   //       checkInDate: UtilityFunctions.splitDateFromString(tickinfo[0].parkingTime ?? ''),
    //   //       checkInTime: UtilityFunctions.splitTimeFromString(tickinfo[0].parkingTime ?? ''),
    //   //       checkoutDate: UtilityFunctions.splitDateFromString(tickinfo[0].finalCheckoutTime ?? ''),
    //   //       checkoutTime: UtilityFunctions.splitTimeFromString(tickinfo[0].finalCheckoutTime ?? ''),
    //   //       duration: UtilityFunctions.getDurationForBlutoothPrint(
    //   //         startTimeString: tickinfo[0].initialCheckinTime ?? '',
    //   //         endTimeString: DateFormat('yyyy-MM-dd HH:mm').format(
    //   //           UtilityFunctions.convertLocalToDubaiTime().isNegative
    //   //               ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
    //   //               : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
    //   //         ),
    //   //       ),
    //   //       amount: tickinfo[0].grossAmount ?? '',
    //   //       vatAmount: tickinfo[0].vatAmount ?? 0.0,
    //   //       vatPercentage: tickinfo[0].vatPercentage ?? 0.0,
    //   //       discount: tickinfo[0].discountAmount ?? '0',
    //   //       netAmount: tickinfo[0].payment ?? '0',
    //   //       isCheckout: tickinfo[0].checkoutStatus == 'Y',
    //   //       carBrand: tickinfo[0].carBrandName ?? '',
    //   //       carColor: tickinfo[0].carColorName ?? '',
    //   //       country: tickinfo[0].emiratesName ?? '',
    //   //       vehicleNumber: tickinfo[0].vehicleNumber ?? '',
    //   //     ),
    //   //   ),
    // );
  }

  Future<List<int>> testTicket({
    required String barcode,
    required String slNo,
    required String checkInDate,
    required String checkInTime,
    required String checkoutDate,
    required String checkoutTime,
    required String duration,
    required String amount,
    required double vatAmount,
    required double vatPercentage,
    required String discount,
    required String netAmount,
    required bool isCheckout,
    required String carBrand,
    required String carColor,
    PrintingHeadingModel? printModel,
  }) async {
    final dashBloc = Provider.of<DashboardBloc>(context, listen: false);
    final settings = dashBloc.getSettingsStream.value;
    var bytes = <int>[];
    // Using default profile
    final profile = await flutter_esc.CapabilityProfile.load();
    final generator = flutter_esc.Generator(flutter_esc.PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text(printModel!.data!.printSettings!.printsettingsHeader ?? '', styles: const flutter_esc.PosStyles(bold: true, align: flutter_esc.PosAlign.center));
    bytes += generator.text(printModel.data!.printSettings!.printsettingsTitle1 ?? '', styles: const flutter_esc.PosStyles(bold: true, align: flutter_esc.PosAlign.center));
    bytes += generator.text(printModel.data!.printSettings!.printsettingsTitle2 ?? '', styles: const flutter_esc.PosStyles(bold: true, align: flutter_esc.PosAlign.center));
    bytes += generator.text(printModel.data!.printSettings!.printsettingsTrnNo ?? '', styles: const flutter_esc.PosStyles(bold: true, align: flutter_esc.PosAlign.center));

    // bytes += generator.feed(1);
    var bar = barcode.trim().split('');

    bytes += generator.emptyLines(1);

    bytes += generator.barcode(flutter_esc.Barcode.code128(bar), textPos: flutter_esc.BarcodeText.none);

    bytes += generator.emptyLines(1);
    // bytes += generator.hr();

    bytes += generator.text('Ticket No. : $barcode');
    bytes += generator.text('Serial No. : $slNo');
    bytes += generator.text('CheckIn Date : $checkInDate');
    bytes += generator.text('CheckIn Time : $checkInTime');

    if (carBrand != '') {
      bytes += generator.text('Car Brand : $carBrand');
      bytes += generator.text('Car Color : $carColor');
    }

    if (isCheckout) {
      bytes += generator.text('Delivery Date : $checkoutDate');
      bytes += generator.text('Delivery Time : $checkoutTime');
      bytes += generator.text('Duration : $duration');
      // bytes += generator.text( 'Duration : ${duration}');
    }

    if (amount != '' && amount != '0') {
      bytes += generator.text('Amount : $amount ${settings?.data?.cURRENCY}');
      if (vatAmount > 0.00) {
        bytes += generator.text('VAT Amount ($vatPercentage% ) : $vatAmount ${settings?.data?.cURRENCY}');
      }
      if (discount != '' && discount != '0.0') {
        bytes += generator.text('Discount : $discount ${settings?.data?.cURRENCY}');
      }
      bytes += generator.text('Net Amount : $netAmount ${settings?.data?.cURRENCY}');
    }

    bytes += generator.feed(1);

    bytes += generator.text(printModel.data!.printSettings!.printsettingsFooter ?? '', styles: const flutter_esc.PosStyles(bold: true, align: flutter_esc.PosAlign.center));
    bytes += generator.text('Powered by: Arabinfotech', styles: const flutter_esc.PosStyles(bold: true, align: flutter_esc.PosAlign.center));

    bytes += generator.feed(2);
    return bytes;
  }

  Color getTicketStatusColor({
    required List<TicketInfo> tickinfo,
  }) {
    final checkOutStatus = tickinfo[0].checkoutStatus;
    if (checkOutStatus == 'N' && tickinfo[0].dataCheckinTime == null) {
      return Colors.green;
    } else if (checkOutStatus == 'N' && tickinfo[0].dataCheckinTime != null) {
      return Colors.orange;
    } else {
      switch (checkOutStatus) {
        // case 'N':
        //   return 'CheckIn';
        case 'Y':
          return Colors.red;
        case 'R':
          return Colors.blue.shade400;
        case 'O':
          return Colors.purple;
        // 'Collect Now' and 'Vehicle Arrived are same
        case 'C':
          return Colors.pink[400]!;
        default:
          return Colors.green;
      }
    }
  }

  String checkoutStatus(String checkoutStatus, String? dataCheckinTime) {
    var status = '';

    if (checkoutStatus == 'N' && dataCheckinTime == null) {
      status = 'CheckIn';
    } else if (checkoutStatus == 'N' && dataCheckinTime != null) {
      status = 'Parked';
    } else if (checkoutStatus == 'R') {
      status = 'Requested';
    } else if (checkoutStatus == 'O') {
      status = 'On The Way';
    } else if (checkoutStatus == 'C') {
      status = 'Vehicle Arrived';
    } else if (checkoutStatus == 'Y') {
      status = 'Checkout';
    }

    return status;
  }

  // String? checkoutStatusTime(String checkoutStatus, List<TicketInfo> tickinfo) {
  //   String? checkoutStatusTime = '';

  //   if (checkoutStatus == 'N') {
  //     checkoutStatusTime = tickinfo[0].initialCheckinTime;
  //   } else if (checkoutStatus == 'R') {
  //     checkoutStatusTime = tickinfo[0].requestedTime;
  //   } else if (checkoutStatus == 'O') {
  //     checkoutStatusTime = tickinfo[0].onthewayTime;
  //   } else if (checkoutStatus == 'C') {
  //     checkoutStatusTime = tickinfo[0].onthewayTime == '0000-00-00 00:00:00'
  //         ? tickinfo[0].requestedTime == '0000-00-00 00:00:00'
  //             ? tickinfo[0].requestedTime == '0000-00-00 00:00:00'
  //                 ? UtilityFunctions.calculateTimeDifference(tickinfo[0].initialCheckinTime!).substring(0, 18)
  //                 : tickinfo[0].dataCheckinTime
  //             : tickinfo[0].requestedTime
  //         : tickinfo[0].onthewayTime;
  //   }

  //   // //print(checkoutStatusTime.length);

  //   return checkoutStatusTime;
  // }

  String? checkoutStatusTime(String checkoutStatus, List<TicketInfo> tickinfo) {
    String? checkoutStatusTime = '';

    if (checkoutStatus == 'N') {
      checkoutStatusTime = tickinfo[0].initialCheckinTime;
    } else if (checkoutStatus == 'R') {
      checkoutStatusTime = tickinfo[0].requestedTime;
    } else if (checkoutStatus == 'O') {
      checkoutStatusTime = tickinfo[0].onthewayTime;
    } else if (checkoutStatus == 'C') {
      checkoutStatusTime = tickinfo[0].onthewayTime ??
          (tickinfo[0].requestedTime ??
              (tickinfo[0].requestedTime == null ? UtilityFunctions.calculateTimeDifference(tickinfo[0].initialCheckinTime!).substring(0, 18) : tickinfo[0].dataCheckinTime));
    } else if (checkoutStatus == 'Y') {
      checkoutStatusTime = tickinfo[0].finalCheckoutTime;
    }

    // //print(checkoutStatusTime.length);

    return checkoutStatusTime;
  }
}
