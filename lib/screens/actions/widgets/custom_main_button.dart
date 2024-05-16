// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/check_out/check_out_bloc.dart';
import 'package:admin_panel/logic/notification/notification_bloc.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/models/new/permission/permssion_model.dart';
import 'package:admin_panel/models/new/settings/settings_model.dart';
import 'package:admin_panel/screens/actions/actions_page.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomMainButton extends StatefulWidget {
  const CustomMainButton({
    required this.title,
    // required this.result,
    // required this.color,
    // required this.isFeeCollectionAllowed,
    required this.bgColor,
    required this.result,
    required this.tickinFo,
    required this.settings,
    required this.isFeeCollectionAllowed,
    this.allPermissions,
    this.status,
    this.icon,
    this.icon2,
    this.isFullWidth = false,
    this.child,
    this.isPaymentPage = false,
    // this.status,
    // this.isFullWidth = false,
    // this.child,
    // this.isPaymentPage = false,
    super.key,
  });

  final String title;
  // final bool isFullWidth;
  // final String? result;
  // final Widget? child;
  // final Color color;
  final IconData? icon;
  final String? icon2;
  // final String? status;
  // final bool isPaymentPage;
  // final bool isFeeCollectionAllowed;
  final Color bgColor;

  final bool isFullWidth;
  final String? result;
  final Widget? child;
  final String? status;
  final List<TicketInfo> tickinFo;
  final GetAllPermissions? allPermissions;
  final bool isPaymentPage;
  final GetSettingsModel? settings;
  final bool isFeeCollectionAllowed;

  @override
  State<CustomMainButton> createState() => _CustomMainButtonState();
}

class _CustomMainButtonState extends State<CustomMainButton> {
  final userName = StorageServices.to.getString('userName');
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ActionsBloc>(context);
    final checkoutBloc = Provider.of<CheckOutBloc>(context);
    final notificationBloc = Provider.of<NotificationBloc>(context);

    final isOnthwayNotificationOn = widget.settings?.data?.oNTHEWAYNOTIFICATION == 'ON';
    final isReqNotificationOn = widget.settings?.data?.rEQUESTEDNOTIFICATION == 'ON';

    String totalDuration = '';

    if (widget.tickinFo.isNotEmpty) {
      // needed to implement somewhere. now it commented due to some unknown bugs.It needs for updating UI when fee collection is enabled or not
      // bloc.getAllCheckOutItems(id: widget.tickinFo[0].id);

      totalDuration = UtilityFunctions.getDurationOf2TimesIsNegative(
        startTimeString: widget.tickinFo[0].initialCheckinTime!,
        endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
          // UtilityFunctions.convertLocalToDubaiTime().isNegative
          //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
          //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
        ),
        checkoutStatus: widget.tickinFo[0].checkoutStatus ?? 'N',
        checkoutTime: widget.tickinFo[0].checkoutTime,
      );
    }

    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Stack(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Padding(
                padding: const EdgeInsets.only(right: 2),
                // child: Icon(icon),
                child: widget.icon == null
                    ? SvgPicture.asset(
                        widget.icon2 ?? '',
                        // color: index != 2 ? Colors.white24 : Colors.white70,
                        color: Colors.white,
                        width: 22,
                        fit: BoxFit.fill,
                      )
                    : Icon(widget.icon, size: 22, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor(),
                // backgroundColor: widget.bgColor,
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                fixedSize: Size(
                  // MediaQuery.of(context).size.width / 4,
                  MediaQuery.of(context).size.width / 9,
                  60,
                ),
              ),
              label: Text(widget.title, style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),

            //
            // Positioned(
            //   right: 5,
            //   top: 4,
            //   child: Icon(doneIcon(), color: doneIconColor(), size: 22),
            // )
          ],
          // ).ripple(context, () {
          //   if (widget.title == 'Parked') {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInScreen()));
          //     Navigator.pushNamed(context, '/parked');
          //   } else if (widget.title == 'CheckOut') {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckOutPage()));
          //     Navigator.pushNamed(context, '/checkout');
          //   } else if (widget.title == 'Payment') {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentPage()));
          //     Navigator.pushNamed(context, '/payment');
          //   }
          // }),
        ).ripple(context, () async {
          customLoader(context);
          // await InternetConnectionChecker().hasConnection.then((isOnline) async {
          //   if (!isOnline) {
          //     // MotionToast.error(
          //     //   title: const Text('No Internet Connection', style: TextStyle(fontWeight: FontWeight.w900)),
          //     //   description: const Text('Please check your network connection and try again'),
          //     // ).show(context);
          //     Loader.hide();
          //     await erroMotionToastInfo(context, msg: 'No Internet Connection.');
          //   } else {
          // Navigator.pop(context);
          final bloc = Provider.of<ActionsBloc>(context, listen: false);
          // await bloc.ticketGenerationSettings();
          if (widget.result == 'nill') {
            Loader.hide();
            return;
          }

          if (!await bloc.checkTicketExists(ticketNumber: widget.result!) &&
              ['CheckIn', 'Parked'].contains(widget.title) &&
              widget.tickinFo.isNotEmpty &&
              widget.tickinFo[0].checkoutStatus == 'Y') {
            bloc.ticketIdStream.add('');
          }

          // if (await bloc.checkTicketExists(ticketNumber: widget.result!) && ['CheckIn', 'Parked'].contains(widget.title)) {
          if (await bloc.checkTicketExists(ticketNumber: widget.result!) && widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'Y') {
            await erroMotionToastInfo(context, msg: 'Vehicle Ticket Already In Use');
            Loader.hide();
            return;
          } else if (!['CheckIn', 'Parked'].contains(widget.title) && widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'Y') {
            // print('99999999999999999999999999999999999999999999999999999999');
            await erroMotionToastInfo(context, msg: 'Please CheckIn or Park the Vehicle');
            Loader.hide();
            return;
          }
          if (widget.child != null && widget.result != '') {
            if (await bloc.checkTicketExists(ticketNumber: widget.result!) &&
                widget.allPermissions != null &&
                widget.allPermissions!.data != null &&
                widget.allPermissions!.data!.isNotEmpty &&
                widget.allPermissions!.data![0].ticketCheckin == 'Y') {
              final payment = widget.tickinFo[0].payment == '0.00' ? null : widget.tickinFo[0].payment;
              if ((widget.title == 'Payment' && payment != null) || (widget.title == 'Payment' && widget.tickinFo[0].paymentCalculatedOn != null)) {
                // //await Fluttertoast.cancel();
                await erroMotionToastInfo(
                  context,
                  msg: 'Payment Is Already Done.',
                );
                Loader.hide();
                return;
              }

              if (widget.title == 'Payment' && !widget.isFeeCollectionAllowed) {
                await erroMotionToastInfo(
                  context,
                  msg: 'No Access For Fee Collection',
                );
                Loader.hide();
                ////print('rrrrrrrrrrrrrrrrrrrrrrrrrrr :$paymentTypeName ${checkBloc.state.paymentIdStream.value}');
                return;
              }

              if ((widget.title == 'Payment' || widget.title == 'CheckOut') && totalDuration.contains('-')) {
                await erroMotionToastInfo(
                  context,
                  msg: 'Duration is negative.Please contact Admin or Developer',
                );
                Loader.hide();
                ////print('rrrrrrrrrrrrrrrrrrrrrrrrrrr :$paymentTypeName ${checkBloc.state.paymentIdStream.value}');
                return;
              }

              if (widget.title == 'CheckOut' &&
                  widget.allPermissions != null &&
                  widget.allPermissions!.data != null &&
                  widget.allPermissions!.data!.isNotEmpty &&
                  widget.allPermissions!.data![0].ticketCheckout == 'N') {
                await erroMotionToastInfo(
                  context,
                  msg: 'No Permission to Checkout',
                );
                Loader.hide();
                ////print('rrrrrrrrrrrrrrrrrrrrrrrrrrr :$paymentTypeName ${checkBloc.state.paymentIdStream.value}');
                return;
              }

              if (widget.title == 'Payment' &&
                  widget.isFeeCollectionAllowed &&
                  widget.allPermissions != null &&
                  widget.allPermissions!.data != null &&
                  widget.allPermissions!.data!.isNotEmpty &&
                  widget.allPermissions!.data![0].feeCollection == 'N') {
                await erroMotionToastInfo(
                  context,
                  msg: 'No Permission to Fee Collection',
                );
                Loader.hide();
                ////print('rrrrrrrrrrrrrrrrrrrrrrrrrrr :$paymentTypeName ${checkBloc.state.paymentIdStream.value}');
                return;
              }

              if (widget.title == 'CheckOut' && !widget.isFeeCollectionAllowed) {
                // await erroMotionToastInfo(
                //   context,
                //   msg: 'No Access For Fee Collection',
                // );
                // Loader.hide();
                if (widget.tickinFo.isNotEmpty) {
                  final ticketInfo = widget.tickinFo.first;
                  ////print('5555555555555555555 ${ticketInfo.checkoutStatus}');
                  ///
                  ///
                  ///Here the loading first given
                  customLoader(context);

                  await checkoutBloc
                      .checkOutSubmit(
                    id: ticketInfo.id.toString(),
                    status: 'Y',
                    ticketNumber: ticketInfo.barcode!,
                    cvaOutId: null,
                    outletId: null,
                    paymentPaidMethod: 'CA',
                    paymentMethodId: 0,
                    paymentNote: '',
                    discountAmount: '',
                    vatPercentage: 0,
                    vatAmount: 0,
                    grossAmount: '',
                    subTotal: 0,
                    payment: '',
                  )
                      .then((value) async {
                    // await toastInfo(
                    //   msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done',
                    //   gravity: ToastGravity.BOTTOM,
                    //   backgroundColor: Colors.green[500]!,
                    // );
                  });
                  Loader.hide();
                  // Navigator.pop(context);
                  bloc.barcodeStream.add(widget.result ?? '');
                  bloc.ticketIdStream.add(ticketInfo.id.toString());
                  successMotionToastInfo(context, msg: 'CheckOut Sucessfully Done');
                  bloc.getTicketDetails(ticketNumber: widget.result ?? '');
                }
                Loader.hide();
                return;
              }

              // if (widget.tickinFo[0].checkoutStatus == 'N' && widget.isPaymentPage) {
              //   // //await Fluttertoast.cancel();
              //   await erroMotionToastInfo(
              //     context,
              //     msg: 'Change CheckIn Status.',
              //   );
              //   Loader.hide();
              //   return;
              // }
              Loader.hide();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.child!,
                ),
              );
            } else if (widget.allPermissions != null &&
                widget.allPermissions!.data != null &&
                widget.allPermissions!.data!.isNotEmpty &&
                widget.allPermissions!.data![0].ticketCheckin == 'N') {
              Loader.hide();
              await erroMotionToastInfo(context, msg: 'No ${widget.title} Permission.');
            } else {
              if (widget.title == 'Parked') {
                Loader.hide();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.child!,
                  ),
                );
                return;
              }

              // await toastInfo(
              //   msg: 'Please CheckIn the Ticket',
              //   gravity: ToastGravity.BOTTOM,
              // );
              Loader.hide();
              await erroMotionToastInfo(
                context,
                msg: 'Please CheckIn the Ticket.',
              );
            }
          } else if (widget.result == '') {
            // await toastInfo(
            //   msg: 'Scan or Enter Barcode on the Provided Field',
            //   gravity: ToastGravity.BOTTOM,
            // );
            Loader.hide();
            await erroMotionToastInfo(context, msg: 'Scan or Enter Barcode on the Provided Field.');
          } else {
            customLoader(context);

            final minValue = StorageServices.to.getInt(StorageServicesKeys.minValue);
            final maxValue = StorageServices.to.getInt(StorageServicesKeys.maxValue);

            if (widget.title == 'Outlet Validator') {
              // //await Fluttertoast.cancel();
              await erroMotionToastInfo(
                context,
                msg: 'No Access',
              );
              Loader.hide();
              return;
            }

            // if (widget.title == 'Payment') {
            // //await Fluttertoast.cancel();
            //   await erroMotionToastInfo(
            //     context,
            //     msg: 'Payment Is Already Done',
            //   );
            //   Loader.hide();
            //   return;
            // }

            if (widget.result != null) {
              if (widget.result!.length < minValue) {
                // //await Fluttertoast.cancel();
                // await toastInfo(
                //   msg: 'Barcode Must Have Aleast $minValue Long',
                //   gravity: ToastGravity.BOTTOM,
                // );
                await erroMotionToastInfo(
                  context,
                  msg: 'Barcode Must Have Aleast $minValue Long.',
                );
                Loader.hide();
              } else if (widget.result!.length > maxValue) {
                // //await Fluttertoast.cancel();
                // await toastInfo(
                //   msg: 'Barcode could not be exceed $maxValue in length',
                //   gravity: ToastGravity.BOTTOM,
                // );
                await erroMotionToastInfo(
                  context,
                  msg: 'Barcode could not be exceed $maxValue in length.',
                  height: 50,
                );
                Loader.hide();
              } else {
                if (!await bloc.checkTicketExists(ticketNumber: widget.result!) && widget.status == 'N') {
                  if (widget.allPermissions != null &&
                      widget.allPermissions!.data != null &&
                      widget.allPermissions!.data!.isNotEmpty &&
                      widget.allPermissions!.data![0].ticketCheckin == 'Y') {
                    // CheckIn
                    await bloc.checkInSubmit(ticketNumber: widget.result!);
                    final respmodel = bloc.checkInSubmitResponse.value;
                    if (respmodel != null && respmodel.status == 'OK' && respmodel.message == 'success') {
                      await bloc.getTicketDetails(ticketNumber: widget.result!);
                      await bloc.checkTicketExists(ticketNumber: widget.result!);
                      await bloc.getAllPermissions().then((value) => null);
                      statusNotifier.value = widget.title;
                      statusNotifier.notifyListeners();
                      // isExpandedNotifier.value = true;
                      // isExpandedNotifier.notifyListeners();
                      // //await Fluttertoast.cancel();
                      // await toastInfo(
                      //   msg: '$title Successfully',
                      //   gravity: ToastGravity.BOTTOM,
                      //   backgroundColor: Colors.green[500]!,
                      // );
                      // ShowMToast(context).successToast(
                      //   alignment: Alignment.topCenter,
                      //   message: '$title Successfully',
                      //   backgroundColor: Colors.green[200],
                      // );
                      // MotionToast.success(
                      //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                      //   description: const Text(''),
                      //   height: 40.h,
                      //   width: 300.w,
                      //   iconSize: 23.w,
                      //   // animationCurve: Curves.easeInExpo,
                      //   animationType: AnimationType.fromLeft,
                      //   animationDuration: const Duration(milliseconds: 800),
                      // ).show(context);

                      // await successMotionToastInfo(context, msg: '${widget.title} Successfully');
                      await successMotionToastInfo(context, msg: 'Vehicle Checked In Successfully.');
                      Loader.hide();
                    }
                  } else if (widget.allPermissions != null &&
                      widget.allPermissions!.data != null &&
                      widget.allPermissions!.data!.isNotEmpty &&
                      widget.allPermissions!.data![0].ticketCheckin == 'N') {
                    await erroMotionToastInfo(context, msg: 'No ${widget.title} Permission.');
                    Loader.hide();
                  }
                  Loader.hide();
                } else if (await bloc.isStatusTrue(ticketNumber: widget.result!, status: 'N')) {
                  // If status is CheckIn(N) then change it into Requested(R)
                  if (widget.status == 'N') {
                    // //await Fluttertoast.cancel();
                    // await toastInfo(
                    //   msg: 'Vehicle Already $title',
                    //   // msg: 'Vehicle Already Exists (Status : $title)',
                    //   gravity: ToastGravity.BOTTOM,
                    //   backgroundColor: Colors.red[500]!,
                    // );
                    // MotionToast.error(
                    //   title: Text('Vehicle Already $title', style: TextStyle(fontSize: 12.w)),
                    //   description: const Text(''),
                    //   height: 40.h,
                    //   width: 300.w,
                    //   iconSize: 23.w,
                    //   animationType: AnimationType.fromLeft,
                    //   animationDuration: const Duration(milliseconds: 800),
                    // ).show(context);

                    await erroMotionToastInfo(context, msg: 'Vehicle Already ${widget.title}.');
                    Loader.hide();
                  } else if (widget.status == 'R') {
                    await bloc.ticketGenerationSettings();
                    if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketRequest == 'Y') {
                      final respModel = await bloc.changeTicketStatus(id: bloc.ticketDetailsResponse.value!.data!.ticketInfo![0].id!, status: widget.status!);
                      if (respModel != null && respModel.status == 'OK' && respModel.message == 'status updation success') {
                        // if (respModel != null) {
                        // if (respModel['status'] == 'OK' && respModel['message'] == 'status updation success') {
                        statusNotifier.value = widget.title;
                        statusNotifier.notifyListeners();
                        await bloc.getTicketDetails(ticketNumber: widget.result!);
                        // //await Fluttertoast.cancel();
                        await notificationBloc.getRequestedTickets(orderBy: 'id');
                        // await Api.sendPushNotification(title: title, msg: 'Ticket no: ${result!}\n$title Successfully Done');
                        final userType = StorageServices.to.getString('userType');
                        if (userType == 'L' || userType == 'C') {
                          // await StorageServices.to.remove('checkoutStatus');
                          // await StorageServices.to.setString('checkoutStatus', widget.title);
                          // await Api.sendPushNotification(
                          //   title: widget.title,
                          //   msg: widget.tickinFo[0].checkoutStatus == 'R'
                          //       ? '${widget.result!} is requested by $userName'
                          //       : widget.tickinFo[0].checkoutStatus == 'O'
                          //           ? '${widget.result!} is on the way.please wait'
                          //           : 'none',
                          // );

                          print('shahil');
                          if (widget.tickinFo[0].checkoutStatus == 'R') {
                            // await Api.sendPushNotification(
                            //   title: widget.title,
                            //   msg: '${widget.result!} is requested by $userName',
                            // );
                            final countryName = widget.tickinFo[0].emiratesName ?? '';
                            final carNumber = widget.tickinFo[0].vehicleNumber ?? '';
                            final modelName = widget.tickinFo[0].carBrandName ?? '';
                            final carColor = widget.tickinFo[0].carColorName ?? '';

                            final barcode = widget.result;
                            final method = widget.title;

                            final vehicleNo = (carNumber == '' && modelName == '')
                                ? ''
                                : 'Vehicle No: ${UtilityFunctions.extractAlphabets(carNumber)} ${UtilityFunctions.extractNumbers(carNumber)} $countryName';

                            final carDetails = (modelName != '' && carNumber != '') ? 'Vehicle Info: $modelName $carColor Color' : '';

                            // await Api.sendPushNotification(title: '$method Notifitication', msg: '$countryName $carNumber\n$modelName $carColor\n$barcode is $method by $userName'.trim());

                            await successMotionToastInfo(context, msg: 'Vehicle Requested Successfully.');

                            Loader.hide();

                            if (isReqNotificationOn) {
                              await Api.sendPushNotification(
                                title: '$method Alert',
                                msg: '$vehicleNo\n$carDetails\nValet Ticket No: $barcode is $method by $userName'.trim(),
                              );
                            }
                          } else if (widget.tickinFo[0].checkoutStatus == 'O') {
                            // await Api.sendPushNotification(title: widget.title, msg: '${widget.result!} is on the way.please wait');

                            final countryName = widget.tickinFo[0].emiratesName ?? '';
                            final carNumber = widget.tickinFo[0].vehicleNumber ?? '';
                            final modelName = widget.tickinFo[0].carBrandName ?? '';
                            final carColor = widget.tickinFo[0].carColorName ?? '';

                            final barcode = widget.result;
                            final method = widget.title;

                            final vehicleNo = (carNumber == '' && modelName == '')
                                ? ''
                                : 'Vehicle No: ${UtilityFunctions.extractAlphabets(carNumber)} ${UtilityFunctions.extractNumbers(carNumber)} $countryName';

                            final carDetails = (modelName != '' && carNumber != '') ? 'Vehicle Info: $modelName $carColor Color' : '';

                            await successMotionToastInfo(context, msg: 'Vehicle Is On The Way.');

                            if (isOnthwayNotificationOn) {
                              await Api.sendPushNotification(
                                title: '$method Alert',
                                msg: '$vehicleNo\n$carDetails\nValet Ticket No: $barcode is $method ($userName)'.trim(),
                              );
                            }
                            Loader.hide();
                          }
                          Loader.hide();
                        }
                        // await AwesomeNotifications().createNotification(
                        //   content: NotificationContent(
                        //     largeIcon: 'assets/images/52114.jpg',
                        //     id: 10,
                        //     channelKey: 'basic_channel',
                        //     // actionType: ActionType.Default,
                        //     title: '$title Successfully Done',
                        //     body: 'Ticket No:- ${result!} is $title',
                        //   ),
                        // );
                        // await toastInfo(
                        //   msg: '$title Successfully',
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.green[500]!,
                        // );
                        // MotionToast.success(
                        //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                        //   description: const Text(''),
                        //   height: 40.h,
                        //   width: 300.w,
                        //   iconSize: 23.w,
                        //   animationType: AnimationType.fromLeft,
                        //   animationDuration: const Duration(milliseconds: 800),
                        // ).show(context);

                        // await successMotionToastInfo(context, msg: '${widget.title} Successfully');
                      }
                      //  else {
                      //await Fluttertoast.cancel();
                      //   await toastInfo(
                      //     msg: 'Something Wrong On Changing Status to $title',
                      //     gravity: ToastGravity.BOTTOM,
                      //     backgroundColor: Colors.red[500]!,
                      //   );
                      // }
                      Loader.hide();
                    } else if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketRequest == 'N') {
                      //print('33333333333333333333333333333');
                      await erroMotionToastInfo(context, msg: 'No Permission to ${widget.title}.');
                      Loader.hide();
                    }
                    // else {
                    //   await erroMotionToastInfo(context, msg: 'No $title Permission');
                    // }
                    Loader.hide();
                  } else if (widget.status == 'O') {
                    await bloc.ticketGenerationSettings();
                    if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketOntheway == 'Y') {
                      // If status is CheckIn(N) then change it into OntheWay(O)
                      final respModel = await bloc.changeTicketStatus(id: bloc.ticketDetailsResponse.value!.data!.ticketInfo![0].id!, status: widget.status!);
                      if (respModel != null && respModel.status == 'OK' && respModel.message == 'status updation success') {
                        // if (respModel != null) {
                        // if (respModel['status'] == 'OK' && respModel['message'] == 'status updation success') {
                        statusNotifier.value = widget.title;
                        statusNotifier.notifyListeners();
                        await bloc.getTicketDetails(ticketNumber: widget.result!);
                        // //await Fluttertoast.cancel();
                        await notificationBloc.getOntheWayTickets(orderBy: 'id');
                        // await Api.sendPushNotification(title: title, msg: 'Ticket no: ${result!}\n$title Successfully Done');
                        final userType = StorageServices.to.getString('userType');
                        if (userType == 'L' || userType == 'C') {
                          // await StorageServices.to.remove('checkoutStatus');

                          // await StorageServices.to.setString('checkoutStatus', widget.title);
                          // await Api.sendPushNotification(title: widget.title, msg: 'Ticket no: ${widget.result!}\n${widget.title} Successfully Done');
                          final countryName = widget.tickinFo[0].emiratesName ?? '';
                          final carNumber = widget.tickinFo[0].vehicleNumber ?? '';
                          final modelName = widget.tickinFo[0].carBrandName ?? '';
                          final carColor = widget.tickinFo[0].carColorName ?? '';

                          final barcode = widget.result;
                          final method = widget.title;

                          final vehicleNo = (carNumber == '' && modelName == '')
                              ? ''
                              : 'Vehicle No: ${UtilityFunctions.extractAlphabets(carNumber)} ${UtilityFunctions.extractNumbers(carNumber)} $countryName';

                          final carDetails = (modelName != '' && carNumber != '') ? 'Vehicle Info: $modelName $carColor Color' : '';

                          if (isOnthwayNotificationOn) {
                            await Api.sendPushNotification(
                              title: '$method Alert',
                              msg: '$vehicleNo\n$carDetails\nValet Ticket No: $barcode is $method ($userName)'.trim(),
                            );
                            Loader.hide();
                          }
                          Loader.hide();
                          //  '${UtilityFunctions.extractAlphabets(carNumber)} ${UtilityFunctions.extractNumbers(carNumber)} $countryName\n$modelName $carColor Color\nValet Ticket No: $barcode is $method by $userName'
                          //             .trim()
                        }
                        // await AwesomeNotifications().createNotification(
                        //   content: NotificationContent(
                        //     largeIcon: 'assets/images/52114.jpg',
                        //     id: 10,
                        //     channelKey: 'basic_channel',
                        //     // actionType: ActionType.Default,
                        //     title: '$title Successfully Done',
                        //     body: 'Ticket No:- ${result!} is $title',
                        //   ),
                        // );
                        // await toastInfo(
                        //   msg: '$title Successfully',
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.green[500]!,
                        // );
                        // MotionToast.success(
                        //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                        //   description: const Text(''),
                        //   height: 40.h,
                        //   width: 300.w,
                        //   iconSize: 23.w,
                        //   animationType: AnimationType.fromLeft,
                        //   animationDuration: const Duration(milliseconds: 800),
                        // ).show(context);
                        Loader.hide();
                        await successMotionToastInfo(context, msg: 'Vehicle Is On The Way.');
                      }
                      //  else {
                      //await Fluttertoast.cancel();
                      //   await toastInfo(
                      //     msg: 'Something Wrong On Changing Status to $title',
                      //     gravity: ToastGravity.BOTTOM,
                      //     backgroundColor: Colors.red[500]!,
                      //   );
                      // }
                      Loader.hide();
                    } else if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketOntheway == 'N') {
                      //print('222222222222222222222222222');
                      await erroMotionToastInfo(context, msg: 'No Permission to ${widget.title}.');
                      Loader.hide();
                    }

                    Loader.hide();
                  } else if (widget.status == 'C') {
                    //print('1111111111111111111111');
                    //print('222222222222222222222222222222');
                    await bloc.ticketGenerationSettings();
                    if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketCollectnow == 'Y') {
                      // If status is CheckIn(N) then change it into OntheWay(O)
                      final respModel = await bloc.changeTicketStatus(id: bloc.ticketDetailsResponse.value!.data!.ticketInfo![0].id!, status: widget.status!);
                      if (respModel != null && respModel.status == 'OK' && respModel.message == 'status updation success') {
                        // if (respModel != null) {
                        // if (respModel['status'] == 'OK' && respModel['message'] == 'status updation success') {
                        statusNotifier.value = widget.title;
                        statusNotifier.notifyListeners();
                        await bloc.getTicketDetails(ticketNumber: widget.result!);
                        // //await Fluttertoast.cancel();
                        // await toastInfo(
                        //   msg: '$title Successfully',
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.green[500]!,
                        // );
                        // MotionToast.success(
                        //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                        //   description: const Text(''),
                        //   height: 40.h,
                        //   width: 300.w,
                        //   iconSize: 23.w,
                        //   animationType: AnimationType.fromLeft,
                        //   animationDuration: const Duration(milliseconds: 800),
                        // ).show(context);
                        Loader.hide();
                        await successMotionToastInfo(context, msg: 'Vehicle Arrrived Successfully.');
                      }
                      //  else {
                      //await Fluttertoast.cancel();
                      //   await toastInfo(
                      //     msg: 'Something Wrong On Changing Status to $title',
                      //     gravity: ToastGravity.BOTTOM,
                      //     backgroundColor: Colors.red[500]!,
                      //   );
                      // }
                      Loader.hide();
                    } else if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketCollectnow == 'N') {
                      await erroMotionToastInfo(context, msg: 'No Permission to ${widget.title}.');
                      Loader.hide();
                    }
                    Loader.hide();
                  }
                  Loader.hide();
                } else if (await bloc.isStatusTrue(ticketNumber: widget.result!, status: 'R')) {
                  if (widget.status == 'N' || widget.status == 'R') {
                    // //await Fluttertoast.cancel();
                    // await toastInfo(
                    //   msg: 'Vehicle Already $title',
                    //   // msg: 'Vehicle Already Exists (Status : $title)',
                    //   gravity: ToastGravity.BOTTOM,
                    //   backgroundColor: Colors.red[500]!,
                    // );
                    // MotionToast.error(
                    //   title: Text('Vehicle Already $title', style: TextStyle(fontSize: 12.w)),
                    //   description: const Text(''),
                    //   height: 40.h,
                    //   width: 300.w,
                    //   iconSize: 23.w,
                    //   animationType: AnimationType.fromLeft,
                    //   animationDuration: const Duration(milliseconds: 800),
                    // ).show(context);

                    await erroMotionToastInfo(context, msg: 'Vehicle Already ${widget.title}.');
                    Loader.hide();
                  } else if (widget.status == 'O') {
                    await bloc.ticketGenerationSettings();
                    if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketOntheway == 'Y') {
                      // If status is Requested(R) then change it into On the way(O)
                      final respModel = await bloc.changeTicketStatus(id: bloc.ticketDetailsResponse.value!.data!.ticketInfo![0].id!, status: widget.status!);
                      if (respModel != null && respModel.status == 'OK' && respModel.message == 'status updation success') {
                        // if (respModel['status'] == 'OK' && respModel['message'] == 'status updation success')
                        // if (respModel != null) {
                        statusNotifier.value = widget.title;
                        statusNotifier.notifyListeners();
                        await bloc.getTicketDetails(ticketNumber: widget.result!);
                        // //await Fluttertoast.cancel();
                        await notificationBloc.getOntheWayTickets(orderBy: 'id');
                        final userType = StorageServices.to.getString('userType');
                        // print('sadsad45a45sd5as $userType');
                        if (userType == 'L' || userType == 'C') {
                          // await StorageServices.to.remove('checkoutStatus');
                          // await StorageServices.to.setString('checkoutStatus', widget.title);

                          // await Api.sendPushNotification(title: widget.title, msg: 'Ticket no: ${widget.result!}\n${widget.title} Successfully Done');

                          final countryName = widget.tickinFo[0].emiratesName ?? '';
                          final carNumber = widget.tickinFo[0].vehicleNumber ?? '';
                          final modelName = widget.tickinFo[0].carBrandName ?? '';
                          final carColor = widget.tickinFo[0].carColorName ?? '';

                          final barcode = widget.result;
                          final method = widget.title;

                          final vehicleNo = (carNumber == '' && modelName == '')
                              ? ''
                              : 'Vehicle No: ${UtilityFunctions.extractAlphabets(carNumber)} ${UtilityFunctions.extractNumbers(carNumber)} $countryName';

                          final carDetails = (modelName != '' && carNumber != '') ? 'Vehicle Info: $modelName $carColor Color' : '';

                          if (isOnthwayNotificationOn) {
                            await Api.sendPushNotification(
                              title: '$method Alert',
                              msg: '$vehicleNo\n$carDetails\nValet Ticket No: $barcode is $method ($userName)'.trim(),
                            );
                          }
                          Loader.hide();
                        }
                        // await AwesomeNotifications().createNotification(
                        //   content: NotificationContent(
                        //     largeIcon: 'assets/images/52114.jpg',
                        //     id: 10,
                        //     channelKey: 'basic_channel',
                        //     // actionType: ActionType.Default,
                        //     title: '$title Successfully Done',
                        //     body: 'Ticket No:- ${result!} is $title',
                        //   ),
                        // );
                        // await toastInfo(
                        //   msg: '$title Successfully',
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.green[500]!,
                        // );
                        // MotionToast.success(
                        //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                        //   description: const Text(''),
                        //   height: 40.h,
                        //   width: 300.w,
                        //   iconSize: 23.w,
                        //   animationType: AnimationType.fromLeft,
                        //   animationDuration: const Duration(milliseconds: 800),
                        // ).show(context);
                        await successMotionToastInfo(context, msg: 'Vehicle Is On The Way.');
                        Loader.hide();
                      }
                      // else {
                      //await Fluttertoast.cancel();
                      //   await toastInfo(
                      //     msg: 'Something Wrong On Changing Status to $title',
                      //     gravity: ToastGravity.BOTTOM,
                      //     backgroundColor: Colors.red[500]!,
                      //   );
                      // }
                      Loader.hide();
                    } else if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketOntheway == 'N') {
                      await erroMotionToastInfo(context, msg: 'No Permission to ${widget.title}.');
                      Loader.hide();
                    }
                    Loader.hide();
                  } else if (widget.status == 'C') {
                    await bloc.ticketGenerationSettings();
                    if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketCollectnow == 'Y') {
                      // If status is CheckIn(N) then change it into OntheWay(O)
                      final respModel = await bloc.changeTicketStatus(id: bloc.ticketDetailsResponse.value!.data!.ticketInfo![0].id!, status: widget.status!);
                      if (respModel != null && respModel.status == 'OK' && respModel.message == 'status updation success') {
                        // if (respModel != null) {
                        // if (respModel['status'] == 'OK' && respModel['message'] == 'status updation success') {
                        statusNotifier.value = widget.title;
                        statusNotifier.notifyListeners();
                        await bloc.getTicketDetails(ticketNumber: widget.result!);
                        // //await Fluttertoast.cancel();
                        // await toastInfo(
                        //   msg: '$title Successfully',
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.green[500]!,
                        // );
                        // MotionToast.success(
                        //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                        //   description: const Text(''),
                        //   height: 40.h,
                        //   width: 300.w,
                        //   iconSize: 23.w,
                        //   animationType: AnimationType.fromLeft,
                        //   animationDuration: const Duration(milliseconds: 800),
                        // ).show(context);

                        await successMotionToastInfo(context, msg: 'Vehicle Arrived Successfully.');
                        Loader.hide();
                      }
                      //  else {
                      //await Fluttertoast.cancel();
                      //   await toastInfo(
                      //     msg: 'Something Wrong On Changing Status to $title',
                      //     gravity: ToastGravity.BOTTOM,
                      //     backgroundColor: Colors.red[500]!,
                      //   );
                      // }
                      Loader.hide();
                    } else if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketCollectnow == 'N') {
                      //print('44444444444444444444444444444444');
                      await erroMotionToastInfo(context, msg: 'No Permission to ${widget.title}.');
                      Loader.hide();
                    }
                    Loader.hide();
                  }
                  Loader.hide();
                } else if (await bloc.isStatusTrue(ticketNumber: widget.result!, status: 'O')) {
                  if (widget.status == 'N' || widget.status == 'R' || widget.status == 'O') {
                    // //await Fluttertoast.cancel();
                    // await toastInfo(
                    //   msg: 'Vehicle Already $title',
                    //   // msg: 'Vehicle Already Exists (Status : $title)',
                    //   gravity: ToastGravity.BOTTOM,
                    //   backgroundColor: Colors.red[500]!,
                    // );
                    // MotionToast.error(
                    //   title: Text('Vehicle Already $title', style: TextStyle(fontSize: 12.w)),
                    //   description: const Text(''),
                    //   height: 40.h,
                    //   width: 300.w,
                    //   iconSize: 23.w,
                    //   animationType: AnimationType.fromLeft,
                    //   animationDuration: const Duration(milliseconds: 800),
                    // ).show(context);

                    await erroMotionToastInfo(context, msg: 'Vehicle Already ${widget.title}');
                    Loader.hide();
                  } else if (widget.status == 'C') {
                    // print('222222222222222222222222222222');
                    if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketCollectnow == 'Y') {
                      await bloc.ticketGenerationSettings();
                      // If status is On the way(O) then change it into Collect Now(C)
                      final respModel = await bloc.changeTicketStatus(id: bloc.ticketDetailsResponse.value!.data!.ticketInfo![0].id!, status: widget.status!);
                      if (respModel != null && respModel.status == 'OK' && respModel.message == 'status updation success') {
                        // if (respModel['status'] == 'OK' && respModel['message'] == 'status updation success')
                        // if (respModel != null) {
                        statusNotifier.value = widget.title;
                        statusNotifier.notifyListeners();
                        await bloc.getTicketDetails(ticketNumber: widget.result!);
                        // //await Fluttertoast.cancel();
                        // await toastInfo(
                        //   msg: '$title Successfully',
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.green[500]!,
                        // );
                        // MotionToast.success(
                        //   title: Text('$title Successfully', style: TextStyle(fontSize: 12.w)),
                        //   description: const Text(''),
                        //   height: 40.h,
                        //   width: 300.w,
                        //   iconSize: 23.w,
                        //   animationType: AnimationType.fromLeft,
                        //   animationDuration: const Duration(milliseconds: 800),
                        // ).show(context);

                        await successMotionToastInfo(context, msg: 'Vehicle Arrived Successfully.');
                      }
                      //  else {
                      //await Fluttertoast.cancel();
                      //   await toastInfo(
                      //     msg: 'Something Wrong On Changing Status to $title',
                      //     gravity: ToastGravity.BOTTOM,
                      //     backgroundColor: Colors.red[500]!,
                      //   );
                      // }
                      Loader.hide();
                    } else if (widget.allPermissions != null &&
                        widget.allPermissions!.data != null &&
                        widget.allPermissions!.data!.isNotEmpty &&
                        widget.allPermissions!.data![0].ticketCollectnow == 'N') {
                      await erroMotionToastInfo(context, msg: 'No Permission to ${widget.title}.');
                      Loader.hide();
                    }
                  }

                  Loader.hide();
                } else {
                  // } else if (await bloc.isStatusTrue(ticketNumber: result!, status: 'R')) {

                  if (await bloc.checkTicketExists(ticketNumber: widget.result!)) {
                    // //await Fluttertoast.cancel();
                    // await toastInfo(
                    //   msg: 'Vehicle Already ${title != 'Vehicle Arrived' ? title: 'Arrived'}',
                    //   // msg: 'Vehicle Already Exists (Status : $title)',
                    //   gravity: ToastGravity.BOTTOM,
                    //   backgroundColor: Colors.red[500]!,
                    // );
                    // MotionToast.error(
                    //   title: Text('Vehicle Already ${title != 'Vehicle Arrived' ? title : 'Arrived'}', style: TextStyle(fontSize: 12.w)),
                    //   description: const Text(''),
                    //   height: 40.h,
                    //   width: 300.w,
                    //   iconSize: 23.w,
                    //   animationType: AnimationType.fromLeft,
                    //   animationDuration: const Duration(milliseconds: 800),
                    // ).show(context);
                    await erroMotionToastInfo(context, msg: 'Vehicle Already ${widget.title != 'Vehicle Arrived' ? widget.title : 'Arrived'}.');
                    Loader.hide();
                  } else {
                    // await toastInfo(
                    //   msg: 'Please CheckIn the Ticket',
                    //   gravity: ToastGravity.BOTTOM,
                    // );
                    await erroMotionToastInfo(
                      context,
                      msg: 'Please CheckIn the Ticket',
                    );
                  }
                }
                Loader.hide();
              }
            }
          }
          Loader.hide();
          // }
          // });
        }));
  }

  Color bgColor() {
    // if (widget.title == 'Outlet Validator' || (widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'Y' && widget.title != 'CheckIn')) {
    if (widget.title == 'Outlet Validator' || (widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'Y' && !['CheckIn', 'Parked'].contains(widget.title))) {
      return Colors.grey;
    }
    if (widget.title == 'Payment' && !widget.isFeeCollectionAllowed) {
      return Colors.grey;
    }
    var bgclr = widget.bgColor;
    if (widget.result == '') {
      bgclr = widget.bgColor;
      // } else if (widget.tickinFo.isEmpty && widget.title != 'CheckIn') {
    } else if (widget.tickinFo.isEmpty && !['CheckIn', 'Parked'].contains(widget.title)) {
      bgclr = Colors.grey;
    } else if (widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'N' && widget.title == 'CheckIn') {
      bgclr = Colors.grey;
    }
    //  else if (tickinFo.isNotEmpty && tickinFo[0].checkoutStatus == 'N' && (title == 'CheckIn' || title == 'Parked') && tickinFo[0].dataCheckinTime != '0000-00-00 00:00:00') {
    //   bgclr = Colors.grey;
    // }
    // else if (tickinFo.isNotEmpty && tickinFo[0].checkoutStatus == 'R' && (title == 'CheckIn' || title == 'Parked' || title == 'Requested')) {
    else if (widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'R' && (widget.title == 'CheckIn' || widget.title == 'Requested')) {
      bgclr = Colors.grey;
      // } else if (tickinFo.isNotEmpty && tickinFo[0].checkoutStatus == 'O' && (title == 'CheckIn' || title == 'Parked' || title == 'Requested' || title == 'On The Way')) {
    } else if (widget.tickinFo.isNotEmpty && widget.tickinFo[0].checkoutStatus == 'O' && (widget.title == 'CheckIn' || widget.title == 'Requested' || widget.title == 'On The Way')) {
      bgclr = Colors.grey;
      // } else if (tickinFo.isNotEmpty &&
      //     tickinFo[0].checkoutStatus == 'C' &&
      //     (title == 'CheckIn' || title == 'Parked' || title == 'Requested' || title == 'On The Way' || title == 'Vehicle Arrived')) {
    } else if (widget.tickinFo.isNotEmpty &&
        widget.tickinFo[0].checkoutStatus == 'C' &&
        (widget.title == 'CheckIn' || widget.title == 'Requested' || widget.title == 'On The Way' || widget.title == 'Vehicle Arrived')) {
      bgclr = Colors.grey;
    }
    return bgclr;
  }
}
