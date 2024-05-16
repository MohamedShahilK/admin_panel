import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/actions/checkin/checkin_page.dart';
import 'package:admin_panel/screens/actions/checkin/custom_action_textfield.dart';
import 'package:admin_panel/screens/actions/checkout/checkout_page.dart';
import 'package:admin_panel/screens/actions/payment/payment_page.dart';
import 'package:admin_panel/screens/actions/widgets/action_top_card.dart';
import 'package:admin_panel/screens/actions/widgets/custom_main_button.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

final ValueNotifier<String> statusNotifier = ValueNotifier('CheckIn');

class ActionsPage extends StatefulWidget {
  const ActionsPage({
    super.key,
  });

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  ActionsBloc? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bloc ??= Provider.of<ActionsBloc>(context);
    });
    // bloc!.ticketGenerationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    final bloc = Provider.of<ActionsBloc>(context);
    final dashBloc = Provider.of<DashboardBloc>(context);
    return Stack(
      children: [
        //
        StreamBuilder(
            stream: bloc.getAllPermissionStream,
            builder: (context, permissionSnapshot) {
              if (permissionSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: LoadingAnimationWidget.fallingDot(color: Colors.purple, size: 20));
              } else if (permissionSnapshot.hasError) {
                return const Center(child: Text('SomeThing Wrong'));
              }
              final permissionResp = permissionSnapshot.data;
              if (permissionResp == null) {
                Loader.hide();
                // return const Center(child: Text('Permission has Some Issue in Server Side.Try Again After Some Time'));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sorry, we're having trouble with permissions on our server. Please try again later."),
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
                          ).ripple(context, bloc.getAllPermissions, borderRadius: BorderRadius.circular(15), overlayColor: Colors.purple.withOpacity(.15)),
                        ],
                      ),
                    ),
                  ],
                );
              }
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
                    if (settingsSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.prograssiveDots(
                              color: Colors.purple,
                              size: 32,
                            ),
                            const Text('Loading ...', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    }
                    if (appMaintenanceMode == 'ON' || maintenanceMode == 'ON') {
                      return Column(
                        mainAxisAlignment: (commonScrollMessage != null && commonScrollMessage.isNotEmpty) || (scrollMessage != null && scrollMessage.isNotEmpty)
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          // const Spacer(),
                          if ((commonScrollMessage != null && commonScrollMessage.isNotEmpty) || (scrollMessage != null && scrollMessage.isNotEmpty)) const SizedBox(height: 70),
                          Container(
                            alignment: Alignment.center,
                            // padding: EdgeInsets.only(right: 15.w),
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
                          //   style: AppStyles.openSans.copyWith(color: Colors.black, fontSize: 20.w, fontWeight: FontWeight.w800),
                          // ),
                          const SizedBox(height: 10),
                          Text(
                            'WE WILL COMING BACK SOON',
                            style: GoogleFonts.openSans().copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800),
                          ),
                          // SizedBox(height: 25.h),
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 120, left: 160, right: 160),
                      child: SingleChildScrollView(
                        child: StreamBuilder(
                            stream: bloc.barcodeStream,
                            builder: (context, snapshot) {
                              final result = snapshot.data;
                              var checkOutStatus = '';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 160),
                                    child: ActionTopCard(title: 'title', count: 'count', icon: Icons.abc, color: Colors.red),
                                  ),

                                  const SizedBox(height: 50),

                                  //
                                  CustomActionTextField(onTextChanged: (val) {}),

                                  const SizedBox(height: 30),

                                  //
                                  StreamBuilder(
                                      stream: bloc.ticketDetailsResponse,
                                      builder: (context, snapshot) {
                                        var tickinfo = <TicketInfo>[];
                                        // //print('aaaaaaaa ${snapshot.hasData}');
                                        if (snapshot.hasData) {
                                          final ticketDetails = snapshot.data;
                                          tickinfo = ticketDetails!.data!.ticketInfo!;

                                          //print('111111111111111111 : $tickinfo');
                                          // //print('create Date ${tickinfo[0].createDate}');
                                        }

                                        if (tickinfo.isNotEmpty) {
                                          bloc.getAllCheckOutItems(id: tickinfo[0].id).then((value) {
                                            // print('1111111111111111111111111111111111');
                                          });
                                        }
                                        return StreamBuilder(
                                            stream: bloc.getAllCheckOutItemsStream,
                                            builder: (context, getAllCheckOutItemsStreamsnapshot) {
                                              final snap = getAllCheckOutItemsStreamsnapshot.data;
                                              final isFeeCollectionAllowed = (snap?.data?.cashSetting?.popupStatus == 'A' && snap?.data?.cashSetting?.popupSettingId == 1) &&
                                                  (permissionResp.data?.first.feeCollection == 'Y');
                                              // print('111111111111111111111111111 ${permissionResp.data?.first.feeCollection == 'Y'}');
                                              // print('111111111111111111111111111 ${snap?.data.cashSetting.popupStatus == 'A' && snap?.data.cashSetting.popupSettingId == 1}');
                                              // final  isFeeCollectionAllowed = true;
                                              return SizedBox(
                                                width: MediaQuery.of(context).size.width / 2,
                                                child: Wrap(
                                                  // crossAxisAlignment: WrapCrossAlignment.center,
                                                  alignment: WrapAlignment.center,
                                                  // padding: const EdgeInsets.symmetric( vertical: 30),
                                                  // shrinkWrap: true,
                                                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 100),
                                                  spacing: 15,
                                                  runSpacing: 5,
                                                  children: [
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'CheckIn',
                                                      result: result,
                                                      bgColor: Colors.green[600]!,
                                                      icon2: 'assets/icons/key_exchange.svg',
                                                      status: 'N',
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'Parked',
                                                      bgColor: Colors.orange[600]!,
                                                      icon: Icons.local_parking_rounded,
                                                      result: result,
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                      child: CheckInScreen(result: result),
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'Requested',
                                                      bgColor: Colors.blue[600]!,
                                                      icon: FontAwesomeIcons.registered,
                                                      result: result,
                                                      status: 'R',
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'On The Way',
                                                      bgColor: Colors.purple[600]!,
                                                      icon: FontAwesomeIcons.route,
                                                      result: result,
                                                      status: 'O',
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'Vehivle Arrived',
                                                      bgColor: Colors.pink[600]!,
                                                      icon2: 'assets/icons/checkin.svg',
                                                      result: result,
                                                      status: 'C',
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'Payment',
                                                      bgColor: Colors.tealAccent[700]!,
                                                      icon: FontAwesomeIcons.moneyBillTransfer,
                                                      result: result,
                                                      allPermissions: permissionResp,
                                                      isPaymentPage: true,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                      child: PaymentPage(
                                                        ticketNumber: result,
                                                        id: tickinfo.isEmpty ? 0 : tickinfo[0].id,
                                                      ),
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'CheckOut',
                                                      bgColor: Colors.red[600]!,
                                                      icon: FontAwesomeIcons.caravan,
                                                      result: result,
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                      child: CheckOutPage(
                                                        ticketNumber: result,
                                                        isAllCheckin: true,
                                                        id: tickinfo.isEmpty ? 0 : tickinfo[0].id,
                                                      ),
                                                    ),
                                                    CustomMainButton(
                                                      tickinFo: tickinfo,
                                                      title: 'Outlet Validator',
                                                      bgColor: Colors.grey[600]!,
                                                      icon: FontAwesomeIcons.barcode,
                                                      result: result,
                                                      allPermissions: permissionResp,
                                                      settings: settings,
                                                      isFeeCollectionAllowed: isFeeCollectionAllowed,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      })
                                ],
                              );
                            }),
                      ),
                    );
                  });
            }),

        // Header
        const Header(),
      ],
    );
  }
}
