import 'dart:async';

import 'package:admin_panel/data/checkin_model.dart';
import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/check_in/check_in_bloc.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/logic/parked/parked_bloc.dart';
import 'package:admin_panel/models/new/actions/actions_response_model.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/models/old/user.dart';
// import 'package:admin_panel/models/new/user.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:admin_panel/screens/widgets/custom_dropdown.dart';
import 'package:admin_panel/screens/widgets/scrollable_widget.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/utility_functions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({
    this.result,
    super.key,
  });

  final String? result;

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ActionsBloc? bloc;
  ParkedBloc? parkedBloc;
  DashboardBloc? dashBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    bloc ??= Provider.of<ActionsBloc>(context);
    dashBloc ??= Provider.of<DashboardBloc>(context);
    parkedBloc ??= Provider.of<ParkedBloc>(context);
    bloc!.getAllCheckInItems();
    dashBloc?.getCarBrands();
    // parkedBloc!.getTicketDetails(ticketNumber: widget.result ?? '');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await bloc?.getAllCheckInItems();
      await dashBloc?.getCarBrands();
      await parkedBloc!.getTicketDetails(ticketNumber: widget.result ?? '').then((value) {
        // print('tikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${bloc!.ticketDetailsResponse.value?.data?.ticketInfo}');
        if (parkedBloc!.ticketDetailsResponse.value!.data!.ticketInfo!.isEmpty) {
          parkedBloc!.clearStreams();
        }
      });
    });
    // _tabController = TabController(
    //   vsync: this,
    //   length: parkedBloc?.ticketDetailsResponse.valueOrNull != null &&
    //           parkedBloc?.ticketDetailsResponse.valueOrNull?.data != null &&
    //           parkedBloc?.ticketDetailsResponse.valueOrNull?.data?.ticketInfo != null &&
    //           parkedBloc!.ticketDetailsResponse.valueOrNull!.data!.ticketInfo!.isNotEmpty
    //       ? 2
    //       : 1,
    // );
    _tabController = TabController(
      vsync: this,
      length: 2,
    );

    // if (parkedBloc!.ticketDetailsResponse.valueOrNull!.data!.ticketInfo!.isNotEmpty) {
    //   parkedBloc!.sourceIdStream.add(null);
    //   parkedBloc!.codeStream.add('');
    //   parkedBloc!.vechicleNumberStream.add('');
    // }

    parkedBloc!.clearStreams();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  // String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              Expanded(
                flex: 7,
                child: _Body(tickNum: widget.result),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
    this.tickNum,
  });

  final String? tickNum;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // _AllChecinSection(),
        _NewCheckInForm(tickNum: tickNum),

        // Header
        const Header(reqBackBtn: true),
      ],
    );
  }
}

class _NewCheckInForm extends StatelessWidget {
  const _NewCheckInForm({
    super.key,
    this.tickNum,
  });

  final String? tickNum;

  @override
  Widget build(BuildContext context) {
    final parkedBloc = Provider.of<ParkedBloc>(context);
    final actionsBloc = Provider.of<ActionsBloc>(context);
    return StreamBuilder(
        stream: actionsBloc.getAllCheckInItemsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.prograssiveDots(
                    color: Colors.purple,
                    size: 35,
                  ),
                  const Text('Please Wait ...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            Loader.hide();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong', style: TextStyle(fontSize: 16)),
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
                      await actionsBloc.getAllCheckInItems();
                    },
                    borderRadius: BorderRadius.circular(15),
                    overlayColor: Colors.purple.withOpacity(.15),
                  ),
                ],
              ),
            );
          } else {
            final respModel = snapshot.data;

            StorageServices.to.setList('cvas', respModel?.data?.cvas?.map((e) => e.departmentName ?? '').toList() ?? []);
            return StreamBuilder(
                stream: parkedBloc.ticketDetailsResponse,
                builder: (context, snapshot) {
                  TicketDetailsResponseModel? details;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return const CircularProgressIndicator();
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 35),
                          const Text('Please Wait ...', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    details = snapshot.data;

                    if (details != null && details.data != null && details.data!.ticketInfo != null && details.data!.ticketInfo!.isNotEmpty) {
                      final ticketInfo = details.data!.ticketInfo;

                      if (ticketInfo!.isNotEmpty) {
                        if (ticketInfo[0].vehicleModel != 0) {
                          final brandNameList = respModel?.data?.carModels?.where((e) => e.modelId == ticketInfo[0].vehicleModel).toList();
                          var brandName = '';
                          if (brandNameList != null && brandNameList.isNotEmpty) {
                            brandName = brandNameList[0].modelTitle ?? '';
                          }
                          parkedBloc.brandStream.add(brandName);
                        } else {
                          parkedBloc.brandStream.add('');
                        }
                        if (ticketInfo[0].vehicleModel != 0) {
                          final brandIdList = respModel?.data?.carModels?.where((e) => e.modelId == ticketInfo[0].vehicleModel).toList();
                          int? brandId;
                          if (brandIdList != null && brandIdList.isNotEmpty) {
                            brandId = brandIdList[0].modelId;
                          }
                          parkedBloc.brandIdStream.add(brandId);
                        } else {
                          parkedBloc.brandIdStream.add(null);
                        }
                        if (ticketInfo[0].vehicleColr != 0) {
                          final colorList = respModel?.data?.carColors?.where((e) => e.carId == ticketInfo[0].vehicleColr).toList();
                          var color = '';
                          if (colorList != null && colorList.isNotEmpty) {
                            color = colorList[0].carTitle ?? '';
                          }
                          parkedBloc.colorStream.add(color);
                        } else {
                          parkedBloc.colorStream.add('');
                        }

                        if (ticketInfo[0].vehicleColr != 0) {
                          final colorList = respModel?.data?.carColors?.where((e) => e.carId == ticketInfo[0].vehicleColr).toList();
                          int? color;
                          if (colorList != null && colorList.isNotEmpty) {
                            color = colorList[0].carId;
                          }
                          parkedBloc.colorIdStream.add(color);
                        } else {
                          parkedBloc.colorIdStream.add(null);
                        }
                        if (ticketInfo[0].cvaIn != 0) {
                          // final driverName = respModel!.data.cvas.where((e) => e.departmentId == ticketInfo[0].cvaIn).toList()[0].departmentName;
                          final list = respModel?.data?.cvas?.where((e) => e.departmentId == ticketInfo[0].cvaIn).toList();
                          var driverName = '';
                          int? driverId;
                          if (list != null && list.isNotEmpty) {
                            driverName = list[0].departmentName ?? '';
                            driverId = list[0].departmentId;
                          }
                          parkedBloc.driverStream.add(driverName);
                          parkedBloc.driverIdStream.add(driverId);
                        } else {
                          parkedBloc.driverStream.add('');
                          parkedBloc.driverIdStream.add(null);
                        }
                        if (ticketInfo[0].emirates != 0) {
                          print('5555555555555555555555555555555555555555555555555555');
                          // final sourceId = respModel!.data.vehicleLocations.where((e) => e.vehicleLocationId == ticketInfo[0].emirates).toList()[0].vehicleLocationId;
                          final list = respModel?.data?.vehicleLocations?.where((e) => e.vehicleLocationId == ticketInfo[0].emirates).toList();
                          int? sourceId;
                          if (list != null && list.isNotEmpty) {
                            sourceId = list[0].vehicleLocationId;
                          }
                          parkedBloc.sourceIdStream.add(sourceId);
                        } else {
                          parkedBloc.sourceIdStream.add(null);
                        }
                        if (ticketInfo[0].vehicleNumber != null) {
                          final vechicleNumber = UtilityFunctions.extractNumbers(ticketInfo[0].vehicleNumber ?? '');
                          parkedBloc.vechicleNumberStream.add(vechicleNumber);
                        } else {
                          parkedBloc.vechicleNumberStream.add('');
                        }
                        if (ticketInfo[0].vehicleNumber != null) {
                          final vechicleCode = UtilityFunctions.extractAlphabets(ticketInfo[0].vehicleNumber ?? '');
                          parkedBloc.codeStream.add(vechicleCode);
                        } else {
                          parkedBloc.codeStream.add('');
                        }

                        if (ticketInfo[0].customerDetails != null) {
                          final customerDetails = ticketInfo[0].customerDetails ?? '';
                          parkedBloc.guestNameStream.add(customerDetails);
                        } else {
                          parkedBloc.guestNameStream.add('');
                        }

                        if (ticketInfo[0].customerMobile != null) {
                          final customerMobile = ticketInfo[0].customerMobile ?? '';
                          parkedBloc.guestNumberStream.add(customerMobile);
                        } else {
                          parkedBloc.guestNumberStream.add('');
                        }

                        if (ticketInfo[0].vehicleRemark != null) {
                          final vehicleRemark = ticketInfo[0].vehicleRemark ?? '';
                          print('vehicleRemark $vehicleRemark');
                          parkedBloc.guestNotesStream.add(vehicleRemark);
                        } else {
                          parkedBloc.guestNotesStream.add('');
                        }

                        if (ticketInfo[0].slot != null) {
                          final slot = ticketInfo[0].slot ?? '';
                          // print('vehicleRemark $slot');
                          if (slot == '0') {
                            parkedBloc.parkingSlotStream.add('');
                          } else {
                            parkedBloc.parkingSlotStream.add(slot);
                          }
                        } else {
                          parkedBloc.parkingSlotStream.add('');
                        }

                        // if (ticketInfo[0]. != null) {
                        //   final  = ticketInfo[0]. ?? '';
                        //   bloc.guestNameStream.add();
                        // } else {
                        //   bloc.guestNameStream.add('');
                        // }
                      }
                    }
                    return StreamBuilder(
                        stream: actionsBloc.getAllPermissionStream,
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

                                Column(
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
                                    ).ripple(context, actionsBloc.getAllPermissions, borderRadius: BorderRadius.circular(15), overlayColor: Colors.purple.withOpacity(.15)),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 110, left: 210, right: 210),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ticket Number', style: GoogleFonts.poppins().copyWith(fontSize: 13, color: Colors.grey[700])),
                                  const SizedBox(height: 15),
                                  // CustomActionTextField(onTextChanged: (val) {}),
                                  Container(
                                    // margin: const EdgeInsets.only(top: 15),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        // color: Colors.red,
                                        color: const Color.fromARGB(255, 92, 45, 153),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Ticket No :',
                                          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          tickNum ?? '',
                                          style: const TextStyle(color: Color.fromARGB(255, 126, 65, 155), fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text('Vehicle Plate', style: GoogleFonts.poppins().copyWith(fontSize: 13, color: Colors.grey[700])),
                                  const SizedBox(height: 15),
                                  Wrap(
                                    spacing: 30,
                                    runSpacing: 15,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      _VehiclePlate(respModel: respModel),
                                      // const SizedBox(width: 30),
                                      _PlateTextField(
                                        textStream: parkedBloc.parkingSlotStream,
                                        onTextChanged: parkedBloc.parkingSlotStream.add,
                                        hintText: 'Parking Slot',
                                        width: MediaQuery.of(context).size.width / 4,
                                        contentPadding: const EdgeInsets.only(left: 20),
                                        keyboardType: TextInputType.text,
                                      ),
                                      // const SizedBox(width: 30),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Text('Vehicle Information', style: GoogleFonts.poppins().copyWith(fontSize: 13, color: Colors.grey[700])),
                                  const SizedBox(height: 15),
                                  _VehicleInformation(respModel: respModel),
                                  const SizedBox(height: 30),
                                  Text('Guest Information (Optional)', style: GoogleFonts.poppins().copyWith(fontSize: 13, color: Colors.grey[700])),
                                  const SizedBox(height: 15),
                                  Wrap(
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 30,
                                    runSpacing: 15,
                                    children: [
                                      _PlateTextField(
                                        textStream: parkedBloc.guestNameStream,
                                        onTextChanged: parkedBloc.guestNameStream.add,
                                        hintText: 'Guest Name',
                                        width: MediaQuery.of(context).size.width / 4,
                                        contentPadding: const EdgeInsets.only(left: 20),
                                        keyboardType: TextInputType.text,
                                      ),
                                      _PlateTextField(
                                          textStream: parkedBloc.guestNumberStream,
                                          onTextChanged: parkedBloc.guestNumberStream.add,
                                          hintText: 'Phone number with the country code (e.g., 971, 965)',
                                          width: MediaQuery.of(context).size.width / 4,
                                          keyboardType: TextInputType.text,
                                          contentPadding: const EdgeInsets.only(left: 20)),
                                      _PlateTextField(
                                        textStream: parkedBloc.guestNotesStream,
                                        onTextChanged: parkedBloc.guestNotesStream.add,
                                        hintText: 'Note',
                                        width: MediaQuery.of(context).size.width / 4,
                                        contentPadding: const EdgeInsets.only(left: 20),
                                        keyboardType: TextInputType.text,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,

                                      // iconTheme: IconThemeData(color: Colors.red)
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ExpansionTile(
                                        // trailing: const SizedBox.shrink(),
                                        iconColor: secondaryColor2,
                                        tilePadding: EdgeInsets.zero,
                                        collapsedIconColor: secondaryColor2,
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.image_outlined, color: secondaryColor2, size: 20),
                                              const SizedBox(width: 30),
                                              Text(
                                                'UPLOAD VEHICLE IMAGES',
                                                style: GoogleFonts.poppins().copyWith(color: secondaryColor2, fontSize: 14, fontWeight: FontWeight.bold),
                                                // textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: Align(
                                              child: Image.asset(
                                                'assets/images/car-diagram.png',
                                                width: 400,
                                                // fit: BoxFit.cover,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //
                                  Container(
                                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(color: secondaryColor2, borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'CHECKIN',
                                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                                          style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                        ),
                                      ],
                                    ).ripple(context, () async {
                                      FocusManager.instance.primaryFocus?.unfocus();

                                      customLoader(context);

                                      // print('11111111111111111111111111 ${bloc.sourceIdStream.valueOrNull }');
                                      // print('11111111111111111111111111 ${'${bloc.codeStream.valueOrNull}${bloc.vechicleNumberStream.valueOrNull}' }');

                                      //  print('5453415343543543436 ${!await bloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                      //     emirates: bloc.sourceIdStream.valueOrNull ?? 0,
                                      //     vehicleNumber: '${bloc.codeStream.value}${bloc.vechicleNumberStream.value}'.trim(),
                                      //   )}');

                                      if (details!.data!.ticketInfo!.isEmpty) {
                                        print('3333333333333333333333333333333333333333333333333');

                                        print(parkedBloc.codeStream.value);

                                        // print('468464646846846846846846846843');
                                        // print('5453415343543543436 ${!await bloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                        //   emirates: bloc.sourceIdStream.valueOrNull ?? 0,
                                        //   vehicleNumber: '${bloc.codeStream.valueOrNull}${bloc.vechicleNumberStream.valueOrNull}',
                                        // )}');
                                        // if (bloc.sourceIdStream.value == null && (bloc.codeStream.value != '' && bloc.vechicleNumberStream.value != '')) {
                                        //   await erroMotionToastInfo(context, msg: 'Please Select Country');
                                        // } else
                                        if (!await parkedBloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                              emirates: parkedBloc.sourceIdStream.valueOrNull ?? 0,
                                              vehicleNumber: '${parkedBloc.codeStream.valueOrNull}${parkedBloc.vechicleNumberStream.valueOrNull}',
                                            ) ||
                                            (parkedBloc.sourceIdStream.value == null && parkedBloc.codeStream.value == '' && parkedBloc.vechicleNumberStream.value == '')) {
                                          // print('44444444444444444444444444444444444444444444444444');

                                          await actionsBloc.checkInSubmit(ticketNumber: tickNum ?? '').then((value) async {
                                            // print('8888888888888888888888888888888888888888888888888888888888');
                                            await parkedBloc.getTicketDetails(ticketNumber: tickNum ?? '').then((value) async {
                                              // print('99999999999999999999999999999999999999999999999999999999999');
                                              await parkedBloc.checkInSubmitEdit(context, ticketNumber: tickNum ?? '').then((value) async {
                                                // print('777777777777777777777777777777777777777777777777777777777777');
                                                // print('44444444444444444444444444444444444444444444444444');
                                                Loader.hide();

                                                // if (bloc.checkInSubmitResponse.value == null) return;
                                                parkedBloc.checkInSubmitResponse.listen((value) {
                                                  if (value == null) {
                                                    // erroMotionToastInfo(context, msg: 'something wrong');
                                                    return;
                                                  }
                                                });

                                                // print('44444444444444444444444444444444444444444444444444');

                                                actionsBloc.barcodeStream.add(tickNum ?? '');
                                                await actionsBloc.getTicketDetails(ticketNumber: tickNum ?? '').then((value) {
                                                  final tick = actionsBloc.ticketDetailsResponse.value;
                                                  if (tick?.data?.ticketInfo?[0].vehicleColr != null && tick?.data?.ticketInfo?[0].carColorName != null) {
                                                    parkedBloc.colorIdStream.add(tick?.data?.ticketInfo?[0].vehicleColr);
                                                    parkedBloc.colorStream.add(tick?.data?.ticketInfo?[0].carColorName ?? '');
                                                  }
                                                  if (tick?.data?.ticketInfo?[0].vehicleModel != null && tick?.data?.ticketInfo?[0].carBrandName != null) {
                                                    parkedBloc.brandIdStream.add(tick?.data?.ticketInfo?[0].vehicleModel);
                                                    parkedBloc.brandStream.add(tick?.data?.ticketInfo?[0].carBrandName ?? '');
                                                  }

                                                  if (tick?.data?.ticketInfo?[0].cvaIn != null && tick?.data?.ticketInfo?[0].cvaInName != null) {
                                                    parkedBloc.driverIdStream.add(tick?.data?.ticketInfo?[0].cvaIn);
                                                    parkedBloc.driverStream.add(tick?.data?.ticketInfo?[0].cvaInName ?? '');
                                                  }

                                                  if (tick?.data?.ticketInfo?[0].emirates != null && tick?.data?.ticketInfo?[0].emiratesName != null) {
                                                    parkedBloc.sourceIdStream.add(tick?.data?.ticketInfo?[0].emirates ?? 0);
                                                    parkedBloc.sourceStream.add(tick?.data?.ticketInfo?[0].emiratesName ?? '');
                                                  }

                                                  parkedBloc.codeStream.add(UtilityFunctions.extractAlphabets(tick?.data?.ticketInfo?[0].vehicleNumber ?? ''));
                                                  parkedBloc.vechicleNumberStream.add(UtilityFunctions.extractNumbers(tick?.data?.ticketInfo?[0].vehicleNumber ?? ''));
                                                  parkedBloc.parkingSlotStream.add(tick?.data?.ticketInfo?[0].slot ?? '');
                                                  parkedBloc.guestNameStream.add(tick?.data?.ticketInfo?[0].customerDetails ?? '');
                                                  parkedBloc.guestNumberStream.add(tick?.data?.ticketInfo?[0].customerPhoneNo ?? '');
                                                  parkedBloc.guestNotesStream.add(tick?.data?.ticketInfo?[0].vehicleRemark ?? '');
                                                });

                                                //
                                                //
                                                // Navigator.pop(context);
                                                //
                                                //

                                                await successMotionToastInfo(context, msg: 'Vechicle Details Added Sucessfully');
                                              });
                                              Loader.hide();
                                            });
                                            Loader.hide();
                                          });

                                          Loader.hide();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CheckInScreen(result: details?.ticketNumber),
                                              ));
                                        } else if (await parkedBloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                          emirates: parkedBloc.sourceIdStream.valueOrNull ?? 0,
                                          vehicleNumber: '${parkedBloc.codeStream.valueOrNull}${parkedBloc.vechicleNumberStream.valueOrNull}',
                                        )) {
                                          print('3333333333333333333333333333333333333333333');
                                          await erroMotionToastInfo(context, msg: 'Vehicle Number is already used in another ticket', height: 50);
                                          Loader.hide();
                                        }
                                        Loader.hide();
                                      } else {
                                        // if (bloc.sourceIdStream.value == null && bloc.codeStream.value != '' && bloc.vechicleNumberStream.value != '') {
                                        //   // print('1111111111111111111111111111111111111111111111111');
                                        //   await erroMotionToastInfo(context, msg: 'Please Select Country');
                                        // } else
                                        if (
                                            // if ticket is not null and plate number is not exist
                                            (parkedBloc.sourceIdStream.value != null &&
                                                    details != null &&
                                                    details.data != null &&
                                                    details.data!.ticketInfo != null &&
                                                    details.data!.ticketInfo!.isNotEmpty &&
                                                    !await parkedBloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                                      emirates: parkedBloc.sourceIdStream.valueOrNull ?? 0,
                                                      vehicleNumber: '${parkedBloc.codeStream.valueOrNull}${parkedBloc.vechicleNumberStream.valueOrNull}',
                                                    )) ||

                                                // plate number is not exist and emirate is null but either the code or plate number is not null
                                                (details != null &&
                                                    details.data != null &&
                                                    details.data!.ticketInfo != null &&
                                                    details.data!.ticketInfo!.isNotEmpty &&
                                                    !await parkedBloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                                      emirates: parkedBloc.sourceIdStream.valueOrNull ?? 0,
                                                      vehicleNumber: '${parkedBloc.codeStream.valueOrNull}${parkedBloc.vechicleNumberStream.valueOrNull}',
                                                    ) &&
                                                    parkedBloc.sourceIdStream.value == null &&
                                                    (parkedBloc.codeStream.value != '' || parkedBloc.vechicleNumberStream.value != '')) ||

                                                // pass the save function when we empty all plate number field
                                                (details != null &&
                                                    details.data != null &&
                                                    details.data!.ticketInfo != null &&
                                                    details.data!.ticketInfo!.isNotEmpty &&
                                                    parkedBloc.sourceIdStream.value == null &&
                                                    parkedBloc.codeStream.value == '' &&
                                                    parkedBloc.vechicleNumberStream.value == '') ||

                                                // pass the save function when field values in plate number fields are same to ticket details
                                                (details != null &&
                                                    details.data != null &&
                                                    details.data!.ticketInfo != null &&
                                                    details.data!.ticketInfo!.isNotEmpty && // (details.data!.ticketInfo[0].emirates == null || details.data!.ticketInfo[0].emirates == 0) &&
                                                    details.data!.ticketInfo?[0].emirates == (parkedBloc.sourceIdStream.valueOrNull ?? 0) &&
                                                    // (details.data!.ticketInfo[0].vehicleNumber == null || details.data!.ticketInfo[0].vehicleNumber == '') &&
                                                    details.data!.ticketInfo?[0].vehicleNumber == '${parkedBloc.codeStream.valueOrNull}${parkedBloc.vechicleNumberStream.valueOrNull}')) {
                                          // print('22222222222222222222222222222222222222222222222222222222222222');
                                          //
                                          print(parkedBloc.vechicleNumberStream.value);
                                          // customLoader(context);
                                          if (parkedBloc.guestNumberStream.value != '' && parkedBloc.guestNumberStream.value.length < 10) {
                                            erroMotionToastInfo(context, msg: 'Mobile Number Must be 10 in length');
                                            Loader.hide();
                                          } else {
                                            await parkedBloc.checkInSubmitEdit(context, ticketNumber: tickNum ?? '').then((value) async {
                                              Loader.hide();

                                              if (parkedBloc.checkInSubmitResponse.value == null) return;

                                              actionsBloc.barcodeStream.add(tickNum ?? '');
                                              // await actionsBloc.getTicketDetails(ticketNumber: widget.result ?? '');

                                              Navigator.pop(context);

                                              await successMotionToastInfo(context, msg: 'Vechicle Details Added Sucessfully');
                                            });
                                            Loader.hide();
                                          }
                                          Loader.hide();
                                          // } else if (bloc.sourceIdStream.value != null &&
                                        } else if (await parkedBloc.ticketHavingSamePlateNumberExcludeCheckOut(
                                          emirates: parkedBloc.sourceIdStream.valueOrNull ?? 0,
                                          vehicleNumber: '${parkedBloc.codeStream.valueOrNull}${parkedBloc.vechicleNumberStream.valueOrNull}',
                                        )) {
                                          print('3333333333333333333333333333333333333333333');
                                          await erroMotionToastInfo(context, msg: 'Vehicle Number is already used in another ticket', height: 50);
                                          Loader.hide();
                                        }
                                      }

                                      Loader.hide();
                                    }),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const SizedBox.shrink();
                  }
                });
          }
        });
  }
}

class _VehicleInformation extends StatelessWidget {
  const _VehicleInformation({
    super.key,
    this.respModel,
  });

  final ActionsResponseModel? respModel;

  @override
  Widget build(BuildContext context) {
    final parkedBloc = Provider.of<ParkedBloc>(context);
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 30,
      runSpacing: 15,
      children: [
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width / 4,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              // color: Colors.white,
              border: Border.all(
                // color: Colors.grey,
                color: const Color.fromARGB(146, 146, 69, 197),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder(
              stream: parkedBloc.brandStream,
              builder: (context, snapshot) {
                final brand = snapshot.data;
                // //print('res${snapshot.data}');

                return brand == null || brand == ''
                    ? Text(
                        'Select Brand',
                        // style: TextStyle(
                        //   color: Colors.grey[700],
                        // ),
                        style: GoogleFonts.openSans().copyWith(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   brandModel!.brandIconUrl,
                          //   width: 30.w,
                          // ),
                          const SizedBox(width: 5),
                          Text(
                            brand,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[900],
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      );
              },
            ),
          ).ripple(context, () async {
            await _searchingBrands(context, respModel: respModel);
          }),
        ),
        // const SizedBox(width: 30),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width / 4,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              // color: Colors.white,
              border: Border.all(
                // color: Colors.grey,
                color: const Color.fromARGB(146, 146, 69, 197),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder(
              stream: parkedBloc.colorStream,
              builder: (context, snapshot) {
                final color = snapshot.data;
                return Text(
                  textAlign: TextAlign.center,
                  color == null || color == '' ? 'Select Color' : color,
                  style: color == null || color == ''
                      ? GoogleFonts.openSans().copyWith(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        )
                      : TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: Colors.grey[900],
                        ),
                );
              },
            ),
          ).ripple(context, () async {
            await _searchingColor(context, respModel: respModel!);
          }),
        ),
        // const SizedBox(width: 30),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width / 4,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              // color: Colors.white,
              border: Border.all(
                // color: Colors.grey,
                color: const Color.fromARGB(146, 146, 69, 197),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder(
              stream: parkedBloc.driverStream,
              builder: (context, snapshot) {
                final driver = snapshot.data;
                return Text(
                  textAlign: TextAlign.center,
                  driver == null || driver == '' ? 'Select Driver' : driver,
                  style: driver == null || driver == ''
                      ? GoogleFonts.openSans().copyWith(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        )
                      : TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: Colors.grey[900],
                        ),
                );
              },
            ),
          ).ripple(context, () async {
            await _searchingDriver(context, respModel: respModel!);
          }),
        ),
      ],
    );
  }

  Future<dynamic> _searchingBrands(
    BuildContext context, {
    ActionsResponseModel? respModel,
  }) async {
    final bloc = Provider.of<ParkedBloc>(context, listen: false);
    final dashBloc = Provider.of<DashboardBloc>(context, listen: false);

    final brandList = ValueNotifier<List<String>>(
      respModel!.data?.carModels?.map((e) => e.modelTitle ?? '').toList() ?? [],
    );
    // print('1111111111111111111111111111111 ${respModel.data?.carModels?.map((e) => e.modelTitle ?? '').toList()}');

    var brandIdsList = respModel.data?.carModels?.map((e) => e.modelId).toList();

    // For Ipad
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final largeDev = (screenHeight > 1100) && (screenWidth > 800);
    // For Ipad

    return await showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(
      //     20.r,
      //   ),
      // ),
      context: context,
      builder: (context) => Container(
        height: 600,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    if (value == '') {
                      // brandList = carBrandList;
                      brandList.value = respModel.data?.carModels?.map((e) => e.modelTitle ?? '').toList() ?? [];
                      brandList.notifyListeners();
                      brandIdsList = respModel.data?.carModels?.map((e) => e.modelId).toList();
                    } else {
                      // brandList = carBrandList.where((elem) {
                      //   return elem.brandName
                      //       .toLowerCase()
                      //       .trim()
                      //       .contains(value.toLowerCase().trim());
                      // }).toList();
                      brandList.value = respModel.data?.carModels
                              ?.map((e) => e.modelTitle ?? '')
                              .where(
                                (element) => element.toLowerCase().trim().contains(value.toLowerCase().trim()),
                              )
                              .toList() ??
                          [];
                      brandList.notifyListeners();
                      // brandIdsList = respModel.data.carModels.map((e) => e.modelId).toList();
                      brandIdsList = respModel.data?.carModels
                          ?.where(
                            (element) => (element.modelTitle ?? '').toLowerCase().trim().contains(value.toLowerCase().trim()),
                          )
                          .map((e) => e.modelId)
                          .toList();
                      //print(brandList);
                    }
                  },
                  cursorColor: Colors.grey[700],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    hintText: 'Searching brand ...',
                    hintStyle: GoogleFonts.openSans().copyWith(fontSize: 11, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                    ),
                  ),
                ),
              ),
            ),

            //
            // ValueListenableBuilder(
            //   valueListenable: brandList,
            //   builder: (context, list, _) {
            //     return Column(
            //       children: List.generate(
            //         brandList.value.length,
            //         (index) {
            //           // //print(brandList.value[index]);
            //           return Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //             child: ListTile(
            //               // leading: Image.asset(
            //               //   brandList[index].brandIconUrl,
            //               //   width: 28,
            //               // ),
            //               title: Text(brandList.value[index]),
            //               onTap: () {
            //                 bloc.brandStream.add(brandList.value[index]);
            //                 //print('Brand ID ${brandIdsList[index]}');
            //                 bloc.brandIdStream.add(brandIdsList[index]);
            //                 Navigator.pop(context);
            //               },
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),

            ValueListenableBuilder(
              valueListenable: brandList,
              builder: (context, list, _) {
                // return Column(
                //   children: List.generate(
                //     brandList.value.length,
                //     (index) {
                //       // //print(brandList.value[index]);
                //       return Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                //         child: ListTile(
                //           // leading: Image.asset(
                //           //   brandList[index].brandIconUrl,
                //           //   width: 28,
                //           // ),
                //           title: Text(brandList.value[index]),
                //           onTap: () {
                //             bloc.brandStream.add(brandList.value[index]);
                //             //print('Brand ID ${brandIdsList[index]}');
                //             bloc.brandIdStream.add(brandIdsList[index]);
                //             Navigator.pop(context);
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // );
                return Expanded(
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 120,
                    ),
                    children: List.generate(
                      brandList.value.length,
                      (index) {
                        // //print(brandList.value[index]);
                        // return Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        //   child: ListTile(
                        //     // leading: Image.asset(
                        //     //   brandList[index].brandIconUrl,
                        //     //   width: 28,
                        //     // ),
                        //     title: Text(brandList.value[index]),
                        //     onTap: () {
                        //       bloc.brandStream.add(brandList.value[index]);
                        //       //print('Brand ID ${brandIdsList[index]}');
                        //       bloc.brandIdStream.add(brandIdsList[index]);
                        //       Navigator.pop(context);
                        //     },
                        //   ),
                        // );
                        return StreamBuilder(
                          stream: bloc.ticketDetailsResponse,
                          builder: (context, tickSnapshot) {
                            TicketDetailsResponseModel? details;
                            if (tickSnapshot.connectionState == ConnectionState.waiting) {
                              // return const CircularProgressIndicator();
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0),
                                  // padding: const EdgeInsets.symmetric(vertical: 50),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadingAnimationWidget.prograssiveDots(
                                        color: Colors.purple,
                                        size: largeDev ? 20 : 35,
                                      ),
                                      Text(
                                        'Please Wait ...',
                                        style: TextStyle(fontSize: largeDev ? 9 : 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            details = tickSnapshot.data;
                            var selectedBrand = ValueNotifier<bool>(
                              bloc.brandIdStream.value != null
                                  ? (respModel.data?.carModels?[index].modelId ?? 0) == bloc.brandIdStream.value
                                  : (details!.data != null && details.data!.ticketInfo != null && details.data!.ticketInfo!.isEmpty)
                                      ? false
                                      : details.data?.ticketInfo?[0].vehicleModel == (respModel.data?.carModels?[index].modelId ?? 0),
                            );
                            return StreamBuilder(
                              stream: dashBloc.carBrands,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // return LoadingAnimationWidget.prograssiveDots(
                                  //   color: Colors.purple,
                                  //   size: 32,
                                  // );
                                  return const SizedBox.shrink();
                                }

                                final car = snapshot.data;
                                // final carModelsList = car?.data?.carModels;

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

                                return ValueListenableBuilder(
                                  valueListenable: selectedBrand,
                                  builder: (context, brand, _) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: respModel.data?.carModels?[index].modelId != null && selectedBrand.value ? Colors.grey[300] : null,
                                          border: respModel.data?.carModels?[index].modelId != null && selectedBrand.value
                                              ? Border.all(color: Colors.purple[300]!)
                                              : Border.all(color: Colors.grey[300]!),
                                          // borderRadius: respModel.data.carModels[index].modelId != null && selectedBrand.value ? BorderRadius.circular(10) : null,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              if (carBrandSelection(modelId: brandIdsList?[index])!.contains('-1'))
                                                Image.asset(
                                                  'assets/images/no_image.jpeg',
                                                  // width: 60,
                                                  height: largeDev ? 25 : 50,
                                                )
                                              else
                                                Image.network(
                                                  // carBrandSelection(modelId: respModel.data.carModels[index].modelId) ?? '',
                                                  carBrandSelection(modelId: brandIdsList?[index]) ?? '',
                                                  width: largeDev ? 30 : 60,
                                                  height: largeDev ? 25 : 50,
                                                ),
                                              Text(brandList.value[index], style: TextStyle(fontSize: largeDev ? 9 : 12, color: Colors.black), textAlign: TextAlign.center),
                                            ],
                                          ).ripple(context, () async {
                                            print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrr ${brandIdsList?[index]}');
                                            bloc.brandStream.add(brandList.value[index]);
                                            //print('Brand ID ${brandIdsList[index]}');
                                            bloc.brandIdStream.add(brandIdsList?[index]);
                                            // selectedBrand.value = details?.data?.ticketInfo?[0].vehicleModel == bloc.brandIdStream.value;
                                            // selectedBrand.notifyListeners();
                                            Navigator.pop(context);
                                          }),
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _searchingColor(
    BuildContext context, {
    required ActionsResponseModel respModel,
  }) {
    final bloc = Provider.of<ParkedBloc>(context, listen: false);

    final dashBloc = Provider.of<DashboardBloc>(context, listen: false);

    final colorsList = ValueNotifier<List<String>>(
      respModel.data?.carColors?.map((e) => e.carTitle ?? '').toList() ?? [],
    );

    var colorsIdsList = respModel.data?.carColors?.map((e) => e.carId).toList();

    // For Ipad
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final largeDev = (screenHeight > 1100) && (screenWidth > 800);
    // For Ipad

    return showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(
      //     20.r,
      //   ),
      // ),
      context: context,
      builder: (context) => Container(
        height: 600,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    if (value == '') {
                      // colorsList = sampleColorsList;
                      colorsList.value = respModel.data?.carColors?.map((e) => e.carTitle ?? '').toList() ?? [];
                      colorsList.notifyListeners();
                      colorsIdsList = respModel.data?.carColors?.map((e) => e.carId).toList();
                    } else {
                      // colorsList = sampleColorsList.where((elem) {
                      //   return elem.colorName
                      //       .toLowerCase()
                      //       .trim()
                      //       .contains(value.toLowerCase().trim());
                      // }).toList();
                      colorsList.value = respModel.data?.carColors
                              ?.map((e) => e.carTitle ?? '')
                              .where(
                                (element) => element.toLowerCase().trim().contains(value.toLowerCase().trim()),
                              )
                              .toList() ??
                          [];
                      colorsList.notifyListeners();
                      colorsIdsList = respModel.data?.carColors?.map((e) => e.carId).toList();
                    }
                  },
                  cursorColor: Colors.grey[700],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    hintText: 'Searching colors ...',
                    hintStyle: GoogleFonts.openSans().copyWith(fontSize: 11, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                    ),
                  ),
                ),
              ),
            ),

            //
            // ValueListenableBuilder(
            //   valueListenable: colorsList,
            //   builder: (context, list, _) {
            //     return Column(
            //       children: List.generate(
            //         colorsList.value.length,
            //         (index) {
            //           // ColorNames.guess(this.colorsList[index]);
            //           return Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //             child: ListTile(
            //               dense: true,
            //               // leading: Container(
            //               //   height: 10,
            //               //   width: 10,
            //               //   color: colorsList[index],
            //               // ),
            //               title: Text(colorsList.value[index]),
            //               onTap: () {
            //                 bloc.colorStream.add(colorsList.value[index]);
            //                 bloc.colorIdStream.add(colorsIdsList[index]);
            //                 Navigator.pop(context);
            //               },
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   },
            // )

            ValueListenableBuilder(
              valueListenable: colorsList,
              builder: (context, list, _) {
                return Expanded(
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisExtent: 100,
                    ),
                    children: List.generate(
                      colorsList.value.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: bloc.ticketDetailsResponse,
                                builder: (context, tickSnapshot) {
                                  TicketDetailsResponseModel? details;
                                  if (tickSnapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                        // padding: const EdgeInsets.symmetric(vertical: 50),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            LoadingAnimationWidget.prograssiveDots(
                                              color: Colors.purple,
                                              size: largeDev ? 20 : 35,
                                            ),
                                            // Text(
                                            //   'Please Wait ...',
                                            //   style: TextStyle(fontSize: 14),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  details = tickSnapshot.data;
                                  var selectedColor = ValueNotifier<bool>(
                                    bloc.colorIdStream.value != null
                                        ? (respModel.data?.carColors?[index].carId ?? 0) == bloc.colorIdStream.value
                                        : (details!.data != null && details.data!.ticketInfo != null && details.data!.ticketInfo!.isEmpty)
                                            ? false
                                            : details?.data?.ticketInfo?[0].vehicleColr == (respModel.data?.carColors?[index].carId ?? 0),
                                  );
                                  return StreamBuilder(
                                    stream: dashBloc.carBrands,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // return LoadingAnimationWidget.prograssiveDots(
                                        //   color: Colors.purple,
                                        //   size: 32,
                                        // );
                                        return const SizedBox.shrink();
                                      }

                                      final car = snapshot.data;

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

                                      // return Image.network(
                                      //   carBrandSelection(modelId: respModel.data.carModels[index].modelId) ?? '',
                                      //   width: 60,
                                      //   height: 50,
                                      // );
                                      return ValueListenableBuilder(
                                        valueListenable: selectedColor,
                                        builder: (context, brand, _) {
                                          return DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: respModel.data?.carModels?[index].modelId != null && selectedColor.value ? Colors.grey[300] : null,
                                              border: respModel.data?.carModels?[index].modelId != null && selectedColor.value
                                                  ? Border.all(color: Colors.purple[500]!)
                                                  : Border.all(color: Colors.grey[300]!),
                                              // borderRadius: respModel.data.carModels[index].modelId != null && selectedBrand.value ? BorderRadius.circular(10) : null,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 5),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                    // color:
                                                    //     Color(int.parse('0xFF${carColorHexCode(colorName: respModel.data.carColors[index].carTitle.toLowerCase())?.substring(1)}')),
                                                    color: Color(int.parse('0xFF${carColorHexCode(colorName: colorsList.value[index].toLowerCase())?.substring(1)}')),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  // width: 60,
                                                  width: largeDev ? 18 : 30,
                                                  height: largeDev ? 18 : 30,
                                                  // color: Color(0xFFFF5733),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(colorsList.value[index], style: TextStyle(fontSize: largeDev ? 9 : 12, color: Colors.black)),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ).ripple(context, () async {
                            bloc.colorStream.add(colorsList.value[index]);
                            bloc.colorIdStream.add(colorsIdsList?[index]);
                            Navigator.pop(context);
                          }),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _searchingDriver(
    BuildContext context, {
    required ActionsResponseModel respModel,
  }) {
    final bloc = Provider.of<ParkedBloc>(context, listen: false);

    final dashBloc = Provider.of<DashboardBloc>(context, listen: false);

    final driversList = ValueNotifier<List<String>>(
      respModel.data?.cvas?.map((e) => e.departmentName ?? '').toList() ?? [],
    );

    var driversIdsList = respModel.data?.cvas?.map((e) => e.departmentId).toList();

    // For Ipad
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final largeDev = (screenHeight > 1100) && (screenWidth > 800);
    // For Ipad

    // //print(driverList.length);

    return showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(
      //     20.r,
      //   ),
      // ),
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (value) {
                      if (value == '') {
                        // driversList = sampleDriversList;
                        driversList.value = respModel.data?.cvas?.map((e) => e.departmentName ?? '').toList() ?? [];
                        driversList.notifyListeners();

                        driversIdsList = respModel.data?.cvas?.map((e) => e.departmentId).toList();
                      } else {
                        // driversList = sampleDriversList.where((elem) {
                        //   return elem
                        //       .toLowerCase()
                        //       .trim()
                        //       .contains(value.toLowerCase().trim());
                        // }).toList();
                        driversList.value = respModel.data?.cvas
                                ?.map((e) => e.departmentName ?? '')
                                .where(
                                  (element) => element.toLowerCase().trim().contains(value.toLowerCase().trim()),
                                )
                                .toList() ??
                            [];
                        driversList.notifyListeners();

                        driversIdsList = respModel.data?.cvas?.map((e) => e.departmentId).toList();
                      }
                    },
                    cursorColor: Colors.grey[700],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15),
                      hintText: 'Searching Driver ...',
                      hintStyle: GoogleFonts.openSans().copyWith(fontSize: 11, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.purple[800]!, width: .4),
                      ),
                    ),
                  ),
                ),
              ),

              //
              ValueListenableBuilder(
                valueListenable: driversList,
                builder: (context, list, _) {
                  return Column(
                    children: List.generate(
                      driversList.value.length,
                      (index) {
                        return StreamBuilder(
                          stream: bloc.ticketDetailsResponse,
                          builder: (context, tickSnapshot) {
                            TicketDetailsResponseModel? details;
                            if (tickSnapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0),
                                  // padding: const EdgeInsets.symmetric(vertical: 50),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadingAnimationWidget.prograssiveDots(
                                        color: Colors.purple,
                                        size: largeDev ? 20 : 35,
                                      ),
                                      // Text(
                                      //   'Please Wait ...',
                                      //   style: TextStyle(fontSize: 14),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            details = tickSnapshot.data;
                            var selectedDriver = ValueNotifier<bool>(
                              bloc.driverIdStream.valueOrNull != null
                                  ? (respModel.data?.cvas?[index].departmentId ?? 0) == bloc.driverIdStream.value
                                  : (details!.data != null && details.data!.ticketInfo != null && details.data!.ticketInfo!.isEmpty)
                                      ? false
                                      : details?.data?.ticketInfo?[0].cvaIn == (respModel.data?.cvas?[index].departmentId ?? 0),
                            );
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: respModel.data?.cvas?[index].departmentId != null && selectedDriver.value ? Colors.grey[300] : null,
                                border:
                                    respModel.data?.cvas?[index].departmentId != null && selectedDriver.value ? Border.all(color: Colors.purple[500]!) : Border.all(color: Colors.grey[300]!),
                                // borderRadius: respModel.data.carModels[index].modelId != null && selectedBrand.value ? BorderRadius.circular(10) : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: ListTile(
                                  dense: true,
                                  leading: SizedBox(
                                    child: Image.asset(
                                      'assets/images/driver-removebg-preview.png',
                                      width: 30,
                                    ),
                                  ),
                                  title: Text(driversList.value[index], style: TextStyle(fontSize: largeDev ? 9 : 12, color: Colors.black)),
                                  onTap: () {
                                    bloc.driverStream.add(driversList.value[index]);
                                    bloc.driverIdStream.add(driversIdsList?[index]);
                                    //print(driversIdsList[index]);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehiclePlate extends StatelessWidget {
  const _VehiclePlate({
    super.key,
    this.respModel,
  });

  final ActionsResponseModel? respModel;

  @override
  Widget build(BuildContext context) {
    final parkedBloc = Provider.of<ParkedBloc>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [6, 6],
        color: Colors.grey,
        strokeWidth: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          // decoration: BoxDecoration(
          //   border: Border.all()
          // ),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 40,
                child: _DropDown(items: respModel?.data?.vehicleLocations?.map((e) => e).toList() ?? [], field: 'Source'),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 55,
                height: 40,
                child: _PlateTextField(
                  textStream: parkedBloc.codeStream,
                  onTextChanged: parkedBloc.codeStream.add,
                  hintText: 'Code',
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: _PlateTextField(
                    textStream: parkedBloc.vechicleNumberStream,
                    onTextChanged: parkedBloc.vechicleNumberStream.add,
                    hintText: 'Number',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropDown extends StatefulWidget {
  const _DropDown({
    required this.items,
    required this.field,
  });

  final List<VehicleLocations> items;
  final String field;

  @override
  State<_DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<_DropDown> {
  var selectedValue = '';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ParkedBloc>(context, listen: false);
    return StreamBuilder(
        stream: bloc.sourceIdStream,
        builder: (context, snapshot) {
          var selectedValue = snapshot.data;
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Text(
                widget.field,
                style: GoogleFonts.openSans().copyWith(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w900,
                  fontSize: 10.5,
                ),
              ),
              style: GoogleFonts.openSans().copyWith(
                color: Colors.grey[900],
                fontWeight: FontWeight.w900,
                fontSize: 10.5,
              ),
              items: widget.items
                  .map(
                    (VehicleLocations item) => DropdownMenuItem<int>(
                      value: item.vehicleLocationId,
                      child: Align(
                        // alignment: Alignment.center,
                        child: Text(
                          // vehicleLocation??
                          item.vehicleLocationName ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: (int? value) {
                setState(() {
                  selectedValue = value;
                });
                bloc.sourceIdStream.add(value);
                // //print('111111111111111 $selectedValue');
              },
              iconStyleData: const IconStyleData(iconEnabledColor: secondaryColor2, iconDisabledColor: secondaryColor2),
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 160,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(146, 146, 69, 197),
                  ),
                  color: Colors.grey[200],
                  // color: Colors.white,
                ),
                elevation: 2,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              alignment: Alignment.center,
              dropdownStyleData: DropdownStyleData(
                offset: const Offset(-45, 0),
                maxHeight: 200,
                width: 188,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(width: .3, color: Colors.grey),
                  color: Colors.grey[300],
                ),
                // offset: const Offset(-20, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
            ),
          );
        });
  }
}

class _PlateTextField extends StatefulWidget {
  const _PlateTextField({
    required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    required this.keyboardType,
    this.width = 0,
    this.textAlign,
    this.contentPadding,
    this.hintStyle,
  });

  final BehaviorSubject<String> textStream;
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
  final _controller = TextEditingController();
  @override
  void initState() {
    widget.textStream.listen((value) {
      if (value.isEmpty) {
        _controller.clear();
      } else if (_controller.text != value) {
        _controller.text = value;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15 * 6, // Adjust the value as needed
        ),
        controller: _controller,
        onChanged: widget.onTextChanged,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,color: secondaryColor2),
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
              color: Color.fromARGB(255, 80, 19, 121),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllChecinSection extends StatelessWidget {
  const _AllChecinSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: const IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter
                  _CustomExpansionTile(),

                  // Table
                  _Table()
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
                child: SortablePage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortablePage extends StatefulWidget {
  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  List<CheckInModel> users = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late var timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        timer = Timer.periodic(
          const Duration(seconds: 2),
          (Timer t) {
            setState(() {
              users = List.of(allCheckedInUsers);
            });
          },
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScrollableWidget(child: buildDataTable());

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
      rows: getRows(users),
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
    if (users.isEmpty) {
      return List.generate(
          11,
          (index) => DataCell(Skeletonizer(
                effect: const ShimmerEffect(),
                enabled: users.isEmpty,
                containersColor: Colors.grey[100],
                child: const Text(
                  'data',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              )));
    }
    return cells
        .map((data) => DataCell(
              Text(
                '$data',
                style: const TextStyle(color: Colors.black, fontSize: 12),
                // textAlign: TextAlign.center,
              ),
            ))
        .toList();
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort((user1, user2) => compareString(ascending, user1.ticketNo, user2.ticketNo));
    } else if (columnIndex == 1) {
      users.sort((user1, user2) => compareString(ascending, user1.checkinTime, user2.checkinTime));
    } else if (columnIndex == 2) {
      users.sort((user1, user2) => compareString(ascending, user1.checkinUpdationTime, user2.checkinUpdationTime));
    } else if (columnIndex == 3) {
      users.sort((user1, user2) => compareString(ascending, user1.requestTime, user2.requestTime));
    } else if (columnIndex == 4) {
      users.sort((user1, user2) => compareString(ascending, user1.onTheWayTime, user2.onTheWayTime));
    } else if (columnIndex == 5) {
      users.sort((user1, user2) => compareString(ascending, user1.carBrand, user2.carBrand));
    } else if (columnIndex == 6) {
      users.sort((user1, user2) => compareString(ascending, user1.carColour, user2.carColour));
    } else if (columnIndex == 7) {
      users.sort((user1, user2) => compareString(ascending, user1.cvaIn, user2.cvaIn));
    } else if (columnIndex == 8) {
      users.sort((user1, user2) => compareString(ascending, user1.emirates, user2.emirates));
    } else if (columnIndex == 9) {
      users.sort((user1, user2) => compareString(ascending, user1.plateNo, user2.plateNo));
    } else if (columnIndex == 10) {
      users.sort((user1, user2) => compareString(ascending, user1.status, user2.status));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) => ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class _CustomExpansionTile extends StatefulWidget {
  const _CustomExpansionTile();

  @override
  State<_CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<_CustomExpansionTile> {
  bool showAllIcons = true;

  @override
  Widget build(BuildContext context) {
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
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            // trailing: const SizedBox.shrink(),
            iconColor: secondaryColor2,
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: secondaryColor2,
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
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  children: [
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Select Start Date'),
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Select End Date'),
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Barcode'),
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Plate Number'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Car Brand'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Car Color'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Emirates'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Outlets'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Status'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'CVA IN'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'CVA OUT'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Mobile Number'),

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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTextField extends StatefulWidget {
  const _FilterTextField({
    // required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.errorStream,
  });

  // final BehaviorSubject<String> textStream;
  final void Function(String) onTextChanged;
  final String hintText;
  final TextInputType keyboardType;
  final Stream<String>? errorStream;

  @override
  State<_FilterTextField> createState() => _FilterTextFieldState();
}

class _FilterTextFieldState extends State<_FilterTextField> {
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
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            width: MediaQuery.of(context).size.width / 5,
            child: TextField(
              // controller: _controller,
              onChanged: widget.onTextChanged,
              keyboardType: widget.keyboardType,
              style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
              decoration: InputDecoration(
                hintText: widget.hintText,
                // hintStyle: GoogleFonts.openSans().copyWith(fontSize: 12),
                hintStyle: GoogleFonts.openSans().copyWith(
                  color: Colors.grey[700],
                  fontSize: 10.5,
                ),
                contentPadding: const EdgeInsets.only(left: 15),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  // borderSide: const BorderSide(color: Color.fromARGB(146, 146, 69, 197)),
                  borderSide: const BorderSide(color: secondaryColor2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    // color: Color.fromARGB(255, 80, 19, 121),
                    color: Color.fromARGB(146, 146, 69, 197),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
