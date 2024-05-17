// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/check_out/check_out_bloc.dart';
import 'package:admin_panel/models/new/actions/checkout_form/all_checkout_items.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

enum PaymentMode { paypal, gpay, visa, cod }

final ValueNotifier<PaymentMode> payModeNotifier = ValueNotifier(PaymentMode.cod);

final ValueNotifier<String> totalForDiscountCalculationNotifier = ValueNotifier('0.0');
final ValueNotifier<String> subtTotalForDiscountCalculationNotifier = ValueNotifier('0.0');
final ValueNotifier<double> vatValueBeforeDiscountNotifier = ValueNotifier(0);

class AmountDetails extends StatelessWidget {
  const AmountDetails({
    required this.ticketNumber,
    this.ticketDetails,
    this.respModel,
    this.paymentTypeName,
    this.paymentSubTypeName,
    this.isPaymentPage = false,
    this.isOtherPaySection = false,
    super.key,
  });

  final bool isPaymentPage;
  final bool isOtherPaySection;
  final String? ticketNumber;
  final TicketDetailsResponseModel? ticketDetails;
  final AllCheckOutItemsResponse? respModel;
  final String? paymentTypeName;
  final String? paymentSubTypeName;

  @override
  Widget build(BuildContext context) {
    final checkOutBloc = Provider.of<CheckOutBloc>(context);
    final actionsBloc = Provider.of<ActionsBloc>(context);
    if (paymentTypeName != 'Other') {
      actionsBloc.adjustmentAmtOfOthers.add(null);
      // actionsBloc.adjustmentAmtOfOthers.add('');
    }
    final state = checkOutBloc.state;
    var ticketInfo = <TicketInfo>[];
    if (ticketDetails != null) {
      ticketInfo = ticketDetails?.data?.ticketInfo ?? [];
    }

    final curreny = StorageServices.to.getString('curreny');

    // if (ticketDetails != null && ticketDetails!.data.ticketInfo.isNotEmpty) {
    //   final ticketInfo = ticketDetails!.data.ticketInfo;

    //   if (ticketInfo.isNotEmpty) {
    //     //print('eeeeeeeeeeeeeeeeeeeeeeee ${ticketInfo[0].cvaOut != 0}');
    //     String driverName;
    //     if (ticketInfo[0].cvaOut != 0) {
    //       if (checkOutBloc.state.driverIdStream.hasValue && checkOutBloc.state.driverIdStream.value != null) {
    //         driverName = respModel!.data.cvas.where((e) => e.departmentId == checkOutBloc.state.driverIdStream.value).toList()[0].departmentName;
    //       } else {
    //         driverName = respModel!.data.cvas.where((e) => e.departmentId == ticketInfo[0].cvaOut).toList()[0].departmentName;
    //       }
    //       ////print('eeeeeeeeee $driverName');
    //       checkOutBloc.state.driverStream.add(driverName);
    //     }
    //   }
    // }

    // ////print('wwwwwwwwwww $paymentTypeName');

    final checkBloc = Provider.of<CheckOutBloc>(context);

    if (ticketDetails != null && ticketDetails!.data != null && ticketDetails!.data!.ticketInfo != null && ticketDetails!.data!.ticketInfo!.isNotEmpty) {
      final ticketInfo = ticketDetails!.data!.ticketInfo;
      // if (ticketInfo.isNotEmpty) {
      //   if (ticketInfo[0].cvaOut != 0) {
      //     // final brandName = respModel!.data.cvas.where((e) => e.departmentId == ticketInfo[0].vehicleModel).toList()[0].departmentName;
      //     final list = respModel!.data.cvas.where((e) => e.departmentId == ticketInfo[0].vehicleModel).toList();
      //     var driverName = '';
      //     if (list.isNotEmpty) {
      //       driverName = list[0].departmentName;
      //     }
      //     checkBloc.state.driverStream.add(driverName);
      //   } else {
      //     checkBloc.state.driverStream.add('');
      //   }
      // }
      // checkBloc.state.driverStream.add('');

      // if (ticketInfo.isNotEmpty) {
      //   if (ticketInfo[0].cvaOut != 0 || ticketInfo[0].cvaOut != null) {
      //     // final driverName = respModel!.data.cvas.where((e) => e.departmentId == ticketInfo[0].cvaIn).toList()[0].departmentName;
      //     final list = respModel!.data.cvas.where((e) => e.departmentId == ticketInfo[0].cvaOut).toList();
      //     var driverName = '';
      //     // print('33333333333333333333333333 ${ticketInfo[0].cvaOut}');
      //     if (list.isNotEmpty) {
      //       driverName = list[0].departmentName;
      //       print('33333333333333333333333333 $driverName');
      //       checkBloc.state.driverStream.add(driverName);
      //     }
      //   } else {
      //     checkBloc.state.driverStream.add('');
      //   }
      // }
    }

    // log('Create Date ${ticketDetails}');

    final isPaymentDon = ticketDetails!.data!.ticketInfo?[0].payment == '0.00' ? null : ticketDetails!.data!.ticketInfo?[0].payment;

    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ValueListenableBuilder(
          valueListenable: totalForDiscountCalculationNotifier,
          builder: (context, totalForDiscount, _) {
            // ////print(totalForDiscount);
            return ValueListenableBuilder(
              valueListenable: vatValueBeforeDiscountNotifier,
              builder: (context, vat, _) {
                return ValueListenableBuilder(
                  valueListenable: subtTotalForDiscountCalculationNotifier,
                  builder: (context, subTotalForDiscount, _) {
                    return Column(
                      children: [
                        // Net Amount
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        // color: Colors.red,
                                        color: const Color.fromARGB(255, 92, 45, 153),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Net Amount: ',
                                          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 5),
                                        // Text(
                                        //   // '220 AED',
                                        //   // ticketDetails!.data!.ticketInfo[0].payment != null
                                        //   isPaymentDon != null || ticketDetails!.data!.ticketInfo[0].paymentCalculatedOn != null
                                        //       // ? (ticketDetails!.data!.ticketInfo[0].payment ?? 0.0).toString()
                                        //       // ? '${ticketDetails!.data!.ticketInfo[0].payment ?? 0.0} AED'
                                        //       ? '${ticketDetails!.data!.ticketInfo[0].payment ?? 0.0} $curreny'
                                        //       // : '${paymentTypeName == 'Cash' ? total() : double.parse(discount()) > double.parse(subTotal()) ? '0.0' : (double.parse(subTotal()) - double.parse(discount())).toString()} AED',
                                        //       : '${paymentTypeName == 'Cash' ? total() : double.parse(discount()) > double.parse(subTotal()) ? '0.0' : (double.parse(subTotal()) - double.parse(discount())).toString()} $curreny',
                                        //   style: TextStyle(color: const Color.fromARGB(255, 126, 65, 155), fontSize: 20, fontWeight: FontWeight.bold),
                                        // ),
                                        Text(
                                          // '220 AED',
                                          // ticketDetails!.data!.ticketInfo[0].payment != null
                                          isPaymentDon != null || ticketDetails!.data!.ticketInfo?[0].paymentCalculatedOn != null
                                              // ? (ticketDetails!.data!.ticketInfo[0].payment ?? 0.0).toString()
                                              // ? '${ticketDetails!.data!.ticketInfo[0].payment ?? 0.0} AED'
                                              ? '${ticketDetails!.data!.ticketInfo?[0].payment ?? 0.0} $curreny'
                                              // : '${paymentTypeName == 'Cash' ? total() : double.parse(discount()) > double.parse(subTotal()) ? '0.0' : (double.parse(subTotal()) - double.parse(discount())).toString()} AED',
                                              : '${paymentTypeName == 'Cash' ? total()
                                                  // : double.parse(discount()) > double.parse(subTotal())
                                                  //     ? '0.0'
                                                  //     : (double.parse(subTotal()) - double.parse(discount())).toString(),
                                                  //     isVatInluded: vatValue() == '0.0%',
                                                  : double.parse(
                                                        actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                            ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                            : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                ? '0.0'
                                                                : discount(),
                                                      ) > double.parse(subTotal()) ? '0.0' : (double.parse(subTotal()) - double.parse(
                                                        actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                            ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                            : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                ? '0.0'
                                                                : discount(),
                                                      )).toString()} $curreny',
                                          style: const TextStyle(color: Color.fromARGB(255, 126, 65, 155), fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // if (ticketDetails!.data!.ticketInfo[0].payment != null)
                                  if (isPaymentDon != null || ticketDetails!.data!.ticketInfo?[0].paymentCalculatedOn != null)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.grey,
                                              color: const Color.fromARGB(255, 92, 45, 153),
                                            ),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 0,
                                              // vertical: 15,
                                            ),
                                            child: Column(
                                              children: [
                                                _BottomSheetItems2(
                                                  field: 'Ticket #',
                                                  // value: '223143846523',
                                                  value: ticketDetails!.data!.ticketInfo?[0].barcode ?? '',
                                                ),
                                                _BottomSheetItems2(
                                                  field: 'Created Date & Time',
                                                  // value: '15-06-2023 14:39:00',
                                                  value: ticketDetails!.data!.ticketInfo?[0].initialCheckinTime ?? '',
                                                  // value: resp,
                                                ),
                                                if (ticketDetails!.data!.ticketInfo?[0].requestedTime != null)
                                                  _BottomSheetItems2(
                                                    field: 'Request Date & Time',
                                                    // value: '16-06-2023 13:39:50',
                                                    value: ticketDetails!.data!.ticketInfo?[0].requestedTime ?? '',
                                                  ),
                                                _BottomSheetItems2(
                                                  field: 'Total Duration',
                                                  // value: '23 Hr 0 Min 50 Sec',
                                                  // value: UtilityFunctions.getDurationOf2Times(
                                                  //   startTimeString: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(ticketInfo?[0].initialCheckinTime)),
                                                  //   endTimeString: UtilityFunctions.extractTimeFromDateTime(),
                                                  // ),
                                                  value: UtilityFunctions.getDuration(
                                                    startTimeString: ticketDetails!.data!.ticketInfo![0].initialCheckinTime!,
                                                    endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                                      DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                      // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                      //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                      //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                    ),
                                                    checkoutStatus: 'Y', // in order to stop timer
                                                    checkoutTime: ticketDetails!.data!.ticketInfo?[0].paymentCalculatedOn,
                                                  ),
                                                ),
                                                _BottomSheetItems2(
                                                  field: 'Sub Total',
                                                  value: ticketDetails!.data!.ticketInfo?[0].subTotal.toString() == '0.0'
                                                      ? ticketDetails!.data!.ticketInfo![0].discountAmount ?? '0.0'
                                                      : (ticketDetails!.data!.ticketInfo?[0].subTotal ?? 0.0).toString(),
                                                ),
                                                // if (paymentTypeName == 'Cash')
                                                Column(
                                                  children: [
                                                    _BottomSheetItems2(
                                                      field: 'VAT',
                                                      value: '${ticketDetails!.data!.ticketInfo?[0].vatPercentage ?? 0} %',
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    _BottomSheetItems2(
                                                      field: 'VAT Value',
                                                      value: ticketDetails!.data!.ticketInfo![0].vatAmount == null ? '0' : ticketDetails!.data!.ticketInfo![0].vatAmount.toString(),
                                                    ),
                                                  ],
                                                ),
                                                // else
                                                _BottomSheetItems2(
                                                  field: 'Discount',
                                                  value: ticketDetails!.data!.ticketInfo?[0].discountAmount ?? '0',
                                                  // value: discount(),
                                                ),
                                                _BottomSheetItems2(
                                                  field: 'Total',
                                                  // value: total(),
                                                  // value: (double.parse(subTotal()) - double.parse(discount())).toString(),
                                                  value: ticketDetails!.data!.ticketInfo?[0].payment ?? '0',
                                                  isVatInluded: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              // if (ticketDetails!.data!.ticketInfo?[0].payment != null)
                              if (isPaymentDon != null || ticketDetails!.data!.ticketInfo?[0].paymentCalculatedOn != null)
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // child: Transform.rotate(
                                    //   angle: -45 * (pi / 180),
                                    //   child: Center(
                                    //     child: DecoratedBox(
                                    //       decoration: BoxDecoration(
                                    //         border: Border.all(color: Colors.green[800]!, width: 2),
                                    //         borderRadius: BorderRadius.circular(10),
                                    //       ),
                                    //       child: Container(
                                    //         height: 40,
                                    //         width: 100,
                                    //         decoration: BoxDecoration(
                                    //           border: Border.all(color: Colors.green[800]!, width: 2),
                                    //           borderRadius: BorderRadius.circular(10),
                                    //         ),
                                    //         child: Center(
                                    //           child: Text(
                                    //             'Paid',
                                    //             style: TextStyle(fontSize: 22, color: Colors.green[800], fontWeight: FontWeight.w900),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/paid_sign.png',
                                        width: 180,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),
                        // if (ticketDetails!.data!.ticketInfo[0].payment == null)
                        if (isPaymentDon == null && ticketDetails!.data!.ticketInfo?[0].paymentCalculatedOn == null)
                          // field value pairs
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    if (isOtherPaySection)
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 15),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            // color: Colors.red,
                                            color: const Color.fromARGB(255, 92, 45, 153),
                                          ),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Adjustment Amount: ',
                                              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: StreamBuilder(
                                                stream: actionsBloc.adjustmentAmtOfOthers,
                                                builder: (context, snapshot) {
                                                  return _AmtAdjustTextField(
                                                    textStream: actionsBloc.adjustmentAmtOfOthers,
                                                    onTextChanged: actionsBloc.adjustmentAmtOfOthers.add,
                                                    hintText: '0.0',
                                                    keyboardType: TextInputType.number,
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              // 'AED',
                                              curreny,
                                              style: const TextStyle(color: Color.fromARGB(255, 126, 65, 155), fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          // color: Colors.grey,
                                          color: const Color.fromARGB(255, 92, 45, 153),
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0,
                                          // vertical: 15,
                                        ),
                                        child: Column(
                                          children: [
                                            _BottomSheetItems2(
                                              field: 'Ticket #',
                                              // value: '223143846523',
                                              value: ticketNumber ?? '',
                                            ),
                                            _BottomSheetItems2(
                                              field: 'Created Date & Time',
                                              // value: '15-06-2023 14:39:00',
                                              value: ticketInfo.isEmpty ? 'nill' : ticketInfo[0].initialCheckinTime ?? 'nill',
                                              // value: resp,
                                            ),
                                            if (ticketInfo[0].requestedTime != null)
                                              _BottomSheetItems2(
                                                field: 'Request Date & Time',
                                                // value: '16-06-2023 13:39:50',
                                                value: ticketInfo.isEmpty ? 'nill' : ticketInfo[0].requestedTime ?? 'nill',
                                              ),
                                            _BottomSheetItems2(
                                              field: 'Total Duration',
                                              // value: '23 Hr 0 Min 50 Sec',
                                              // value: UtilityFunctions.getDurationOf2Times(
                                              //   startTimeString: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(ticketInfo[0].initialCheckinTime)),
                                              //   endTimeString: UtilityFunctions.extractTimeFromDateTime(),
                                              // ),
                                              value: UtilityFunctions.getDuration(
                                                startTimeString: ticketInfo[0].initialCheckinTime!,
                                                endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                                  DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                  // UtilityFunctions.convertLocalToDubaiTime().isNegative
                                                  //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                                                  //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                                                ),
                                              ),
                                            ),
                                            if (vatValue() != '0.0%')
                                              _BottomSheetItems2(
                                                field: 'Sub Total',
                                                value: subTotal(),
                                              ),
                                            if (paymentTypeName == 'Cash')
                                              Column(
                                                children: [
                                                  if (vatValue() != '0.0%')
                                                    _BottomSheetItems2(
                                                      field: 'VAT',
                                                      value: vatValue(),
                                                    ),
                                                ],
                                              )
                                            else
                                              _BottomSheetItems2(
                                                field: 'Discount',
                                                value: actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                    ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                    : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                        ? '0.0'
                                                        : double.parse(discount()) > double.parse(subTotal())
                                                            ? subTotal()
                                                            : discount(),
                                                // value: discount(),
                                              ),
                                            _BottomSheetItems2(
                                              field: 'Total',
                                              // value: total(),
                                              // value: (double.parse(subTotal()) - double.parse(discount())).toString(),
                                              value: paymentTypeName == 'Cash'
                                                  ? total()
                                                  // : double.parse(discount()) > double.parse(subTotal())
                                                  //     ? '0.0'
                                                  //     : (double.parse(subTotal()) - double.parse(discount())).toString(),
                                                  //     isVatInluded: vatValue() == '0.0%',
                                                  : double.parse(
                                                            actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                                ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                                : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                    ? '0.0'
                                                                    : discount(),
                                                          ) >
                                                          double.parse(subTotal())
                                                      ? '0.0'
                                                      : (double.parse(subTotal()) -
                                                              double.parse(
                                                                actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                                    ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                                    : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                        ? '0.0'
                                                                        : discount(),
                                                              ))
                                                          .toString(),
                                              isVatInluded: vatValue() == '0.0%',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // if (ticketDetails!.data!.ticketInfo[0].payment != null && !isPaymentPage)
                                // if (ticketDetails!.data!.ticketInfo[0].payment != null)
                                if (isPaymentDon != null)
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // child: Transform.rotate(
                                      //   angle: -45 * (pi / 180),
                                      //   child: Center(
                                      //     child: DecoratedBox(
                                      //       decoration: BoxDecoration(
                                      //         border: Border.all(color: Colors.green[800]!, width: 2),
                                      //         borderRadius: BorderRadius.circular(10),
                                      //       ),
                                      //       child: Container(
                                      //         height: 40,
                                      //         width: 100,
                                      //         decoration: BoxDecoration(
                                      //           border: Border.all(color: Colors.green[800]!, width: 2),
                                      //           borderRadius: BorderRadius.circular(10),
                                      //         ),
                                      //         child: Center(
                                      //           child: Text(
                                      //             'Paid',
                                      //             style: TextStyle(fontSize: 22, color: Colors.green[800], fontWeight: FontWeight.w900),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/paid_sign.png',
                                          width: 180,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        // // Note Textfield
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 20,
                        //   ),
                        //   child: const Align(
                        //     alignment: Alignment.bottomLeft,
                        //     child: Text(
                        //       'Note',
                        //       style: TextStyle(
                        //         color: Colors.grey,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w900,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        if (!isPaymentPage)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                //
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Outlet Selection',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 40,
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
                                            stream: checkBloc.state.outletStream,
                                            builder: (context, snapshot) {
                                              final outlet = snapshot.data;
                                              return Text(
                                                textAlign: TextAlign.center,
                                                outlet == null || outlet == '' ? 'Select Outlet' : outlet,
                                                style: outlet == null || outlet == ''
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
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => const BrandPage(),
                                          //   ),
                                          // );

                                          await _searchingOutlet(context, respModel: respModel!);
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                //

                                const SizedBox(width: 20),

                                //
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Driver Selection',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 40,
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
                                            stream: checkBloc.state.driverStream,
                                            builder: (context, snapshot) {
                                              final driver = snapshot.data;
                                              print('1111111111111111 $driver');
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
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => const BrandPage(),
                                          //   ),
                                          // );

                                          await _searchingDriver(context, respModel: respModel!);
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(
                          height: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!isPaymentPage)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 15, // Adjust the value as needed
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Note If Any',
                                        labelStyle: GoogleFonts.openSans().copyWith(color: Colors.grey[700], fontWeight: FontWeight.w800, fontSize: 18),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 92, 45, 153),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 92, 45, 153),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 92, 45, 153),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              StreamBuilder(
                                stream: checkBloc.state.paymentIdStream,
                                builder: (context, snapshot) {
                                  ////print('122222222222222222222222222 ${vatValueBeforeDiscountNotifier.value}');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
                                    child: StreamBuilder(
                                      stream: checkBloc.state.paymentIdStream,
                                      builder: (context, snapshot) {
                                        return Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(top: 30, bottom: 30),
                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                          decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Confirm',
                                                // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                                                style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                              ),
                                            ],
                                          ),
                                        ).ripple(context, overlayColor: Colors.transparent, () async {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          final totalForOtherPaymentMethodSection = paymentTypeName == 'Cash'
                                              ? total()
                                              // : double.parse(discount()) > double.parse(subTotal())
                                              //     ? '0.0'
                                              //     : (double.parse(subTotal()) - double.parse(discount())).toString(),
                                              //     isVatInluded: vatValue() == '0.0%',
                                              : double.parse(
                                                        actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                            ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                            : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                ? '0.0'
                                                                : discount(),
                                                      ) >
                                                      double.parse(subTotal())
                                                  ? '0.0'
                                                  : (double.parse(subTotal()) -
                                                          double.parse(
                                                            actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                                ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                                : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                    ? '0.0'
                                                                    : discount(),
                                                          ))
                                                      .toString();
                                          if (double.parse(actionsBloc.adjustmentAmtOfOthers.value ?? '0.0') > double.parse(subTotal())) {
                                            await erroMotionToastInfo(context, msg: 'Error: Discount amount cannot exceed the total.');
                                            return;
                                          }
                                          // if (ticketDetails != null && ticketDetails!.data.ticketInfo.isNotEmpty) {
                                          //   final ticketInfo = ticketDetails!.data.ticketInfo[0];
                                          //   //print('5555555555555555555 ${ticketInfo.checkoutStatus}');
                                          //   customLoader(context);
                                          //   await checkBloc.checkOutSubmit(
                                          //     id: ticketInfo.id.toString(),
                                          //     // status: ticketInfo.checkoutStatus,
                                          //     status: 'R',
                                          //     // status: 'Y',
                                          //     ticketNumber: ticketInfo.barcode,
                                          //     // ticketNumber: 'ticketInfo.barcode',
                                          //     cvaOutId: checkBloc.state.driverIdStream.value == null ? ticketInfo.cvaOut : checkBloc.state.driverIdStream.value!,
                                          //     paymentPaidMethod: ticketInfo.paymentPaidMethod,
                                          //     paymentNote: 'paymentNote',
                                          //     discountAmount: paymentTypeName == 'Cash' ? '0' : discount(),
                                          //     vatPercentage: paymentTypeName == 'Cash' ? vatPercentage() * 100 : vatValueBeforeDiscountNotifier.value,
                                          //     // vatAmount: paymentTypeName == 'Cash' ? double.parse(vatValue().replaceAll('%', '')) : vatValueBeforeDiscountNotifier.value,
                                          //     vatAmount: paymentTypeName == 'Cash'
                                          //         ? (double.parse(subTotal()) * vatPercentage())
                                          //         // ? double.parse(vatValue().replaceAll('%', ''))
                                          //         // : (double.parse(subTotal()) * (vatValueBeforeDiscountNotifier.value / 100)),
                                          //         // : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatPercentage()),
                                          //         // : (int.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value ~/ 100),
                                          //         : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value / 100),
                                          //     // grossAmount: double.parse(total()) - (double.tryParse(vatValue()) ?? 0.0),
                                          //     grossAmount: paymentTypeName == 'Cash'
                                          //         // ? double.parse(total()) - (double.parse(vatValue().replaceAll('%', '')))
                                          //         ? (double.parse(total()) - (double.parse(subTotal()) * vatPercentage())).toString()
                                          //         : double.parse(discount()) > double.parse(subTotal())
                                          //             ? '0.0'
                                          //             : (double.parse(subTotal()) -
                                          //                     double.parse(discount()) -
                                          //                     // (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatPercentage()),
                                          //                     (double.parse(subtTotalForDiscountCalculationNotifier.value) * (vatValueBeforeDiscountNotifier.value / 100)))
                                          //                 .toString(),
                                          //     // subTotal: double.parse(total()),
                                          //     // payment: double.parse(total()),
                                          //     subTotal: paymentTypeName == 'Cash'
                                          //         ? double.parse(total())
                                          //         : double.parse(discount()) > double.parse(subTotal())
                                          //             ? 0
                                          //             : (double.parse(subTotal()) - double.parse(discount())),
                                          //     payment: paymentTypeName == 'Cash'
                                          //         ? double.parse(total()).toString()
                                          //         : double.parse(discount()) > double.parse(subTotal())
                                          //             ? '0.0'
                                          //             : (double.parse(subTotal()) - double.parse(discount())).toString(),
                                          //   );
                                          // }

                                          // if (ticketDetails!.data!.ticketInfo[0].checkoutStatus != 'N' || ticketDetails!.data!.ticketInfo[0].dataCheckinTime != null) {

                                          final paymentForZeroPayment = paymentTypeName == 'Cash'
                                              ? double.parse(total()).toString()
                                              : double.parse(
                                                        actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                            ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                            : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                ? '0.0'
                                                                : discount(),
                                                      ) >
                                                      double.parse(subTotal())
                                                  ? '0.0'
                                                  : (double.parse(subTotal()) -
                                                          double.parse(
                                                            actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                                ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                                : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                    ? '0.0'
                                                                    : discount(),
                                                          ))
                                                      .toString();

                                          if (respModel!.data?.cashSetting?.popupStatus == 'A' &&
                                              respModel!.data?.cashSetting?.popupSettingId == 1 &&
                                              // ticketDetails!.data!.ticketInfo[0].payment == null) {
                                              isPaymentDon == null &&
                                              !['0.0', '0'].contains(paymentForZeroPayment)) {
                                            if (isPaymentPage) {
                                              await _customModalSheet(context, isPaymentPage: isPaymentPage);
                                              Loader.hide();
                                            } else {
                                              await _customModalSheet(context);
                                              Loader.hide();
                                            }
                                          } else if (respModel!.data?.cashSetting?.popupStatus == 'A' &&
                                              respModel!.data?.cashSetting?.popupSettingId == 1 &&
                                              // ticketDetails!.data!.ticketInfo[0].payment == null) {
                                              isPaymentDon == null &&
                                              ['0.0', '0'].contains(paymentForZeroPayment)) {
                                            await _customModalSheetForZeroPayment(context);
                                          }
                                          //  else if (respModel!.data?.cashSetting?.popupStatus == 'A' &&
                                          //     respModel!.data?.cashSetting?.popupSettingId == 1 &&
                                          //     // ticketDetails!.data!.ticketInfo[0].payment == null) {
                                          //     isPaymentDon == null &&
                                          //     ['0.0', '0'].contains(paymentForZeroPayment)) {

                                          //   if (ticketDetails != null &&
                                          //       ticketDetails!.data != null &&
                                          //       ticketDetails!.data!.ticketInfo != null &&
                                          //       ticketDetails!.data!.ticketInfo!.isNotEmpty) {
                                          //     final ticketInfo = ticketDetails!.data!.ticketInfo![0];

                                          //     customLoader(context);
                                          //     await checkBloc
                                          //         .checkOutSubmit(
                                          //           id: ticketInfo.id.toString(),
                                          //           status: isPaymentPage ? ticketInfo.checkoutStatus! : 'Y',
                                          //           ticketNumber: ticketInfo.barcode!,
                                          //           cvaOutId: checkBloc.state.driverIdStream.valueOrNull == null
                                          //               ? ticketInfo.cvaOut == 0
                                          //                   ? null
                                          //                   : ticketInfo.cvaOut
                                          //               : checkBloc.state.driverIdStream.value!,
                                          //           outletId: checkBloc.state.outletIdStream.valueOrNull == null
                                          //               ? ticketInfo.outletId == 0
                                          //                   ? null
                                          //                   : ticketInfo.outletId
                                          //               : checkBloc.state.outletIdStream.value!,
                                          //           // paymentPaidMethod: payModeNotifier.value == PaymentMode.cod ? 'CA' : 'CR',
                                          //           paymentPaidMethod: 'CA',
                                          //           paymentMethodId: ticketInfo.paymentMethod == null ? checkBloc.state.paymentIdStream.valueOrNull ?? 1 : ticketInfo.paymentMethod ?? 1,
                                          //           paymentNote: 'paymentNote',
                                          //           discountAmount: paymentTypeName == 'Cash'
                                          //               ? '0'
                                          //               : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                          //                   ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                          //                   : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                          //                       ? '0.0'
                                          //                       : double.parse(discount()) > double.parse(subTotal())
                                          //                           ? subTotal()
                                          //                           : discount(),
                                          //           vatPercentage: paymentTypeName == 'Cash' ? vatPercentage() * 100 : vatValueBeforeDiscountNotifier.value,
                                          //           vatAmount: paymentTypeName == 'Cash'
                                          //               ? (double.parse(subTotal()) * vatPercentage())
                                          //               : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value / 100),
                                          //           grossAmount: paymentTypeName == 'Cash'
                                          //               ? (double.parse(total()) - (double.parse(subTotal()) * vatPercentage())).toString()
                                          //               : double.parse(discount()) > double.parse(subTotal())
                                          //                   ? '0.0'
                                          //                   : (double.parse(subTotal()) -
                                          //                           double.parse(discount()) -
                                          //                           (double.parse(subtTotalForDiscountCalculationNotifier.value) * (vatValueBeforeDiscountNotifier.value / 100)))
                                          //                       .toString(),
                                          //           subTotal: double.parse(subTotal()),
                                          //           payment: paymentTypeName == 'Cash'
                                          //               ? double.parse(total()).toString()
                                          //               : double.parse(
                                          //                         actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                          //                             ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                          //                             : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                          //                                 ? '0.0'
                                          //                                 : discount(),
                                          //                       ) >
                                          //                       double.parse(subTotal())
                                          //                   ? '0.0'
                                          //                   : (double.parse(subTotal()) -
                                          //                           double.parse(
                                          //                             actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                          //                                 ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                          //                                 : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                          //                                     ? '0.0'
                                          //                                     : discount(),
                                          //                           ))
                                          //                       .toString(),
                                          //         )
                                          //         .then((value) async {});
                                          //     checkBloc.state.driverStream.add('');
                                          //     checkBloc.state.driverIdStream.add(null);
                                          //     checkBloc.state.outletStream.add('');
                                          //     checkBloc.state.outletIdStream.add(null);
                                          //     Loader.hide();
                                          //     Navigator.pop(context);
                                          //     actionsBloc.barcodeStream.add(ticketNumber ?? '');
                                          //     actionsBloc.ticketIdStream.add(ticketInfo.id.toString());
                                          //     successMotionToastInfo(context, msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done');
                                          //     actionsBloc.getTicketDetails(ticketNumber: ticketNumber ?? '');
                                          //   }
                                          //   Loader.hide();

                                          // }
                                          else if (respModel!.data?.cashSetting?.popupStatus == 'A' &&
                                              respModel!.data?.cashSetting?.popupSettingId == 1 &&
                                              // ticketDetails!.data!.ticketInfo[0].payment != null &&
                                              isPaymentDon != null &&
                                              isPaymentPage) {
                                            if (isPaymentPage) {
                                              await erroMotionToastInfo(context, msg: 'Payment Already Done');
                                            }
                                            // return;
                                          } else {
                                            //print('rrrrrrrrrrrrrrrrrrrrrrrrrrr :$paymentTypeName ${checkBloc.state.paymentIdStream.value}');
                                            if (ticketDetails != null &&
                                                ticketDetails!.data != null &&
                                                ticketDetails!.data!.ticketInfo != null &&
                                                ticketDetails!.data!.ticketInfo!.isNotEmpty) {
                                              final ticketInfo = ticketDetails!.data!.ticketInfo![0];
                                              //print('5555555555555555555 ${ticketInfo.checkoutStatus}');
                                              customLoader(context);
                                              await checkBloc
                                                  .checkOutSubmit(
                                                id: ticketInfo.id.toString(),
                                                // status: ticketInfo.checkoutStatus,
                                                // status: 'R',
                                                status: isPaymentPage ? ticketInfo.checkoutStatus! : 'Y',
                                                ticketNumber: ticketInfo.barcode!,
                                                // ticketNumber: 'ticketInfo.barcode',
                                                cvaOutId: checkBloc.state.driverIdStream.valueOrNull == null
                                                    ? ticketInfo.cvaOut == 0
                                                        ? null
                                                        : ticketInfo.cvaOut
                                                    : checkBloc.state.driverIdStream.value!,

                                                outletId: checkBloc.state.outletIdStream.valueOrNull == null
                                                    ? ticketInfo.outletId == 0
                                                        ? null
                                                        : ticketInfo.outletId
                                                    : checkBloc.state.outletIdStream.value!,
                                                // paymentPaidMethod: ticketInfo.paymentPaidMethod,
                                                // paymentPaidMethod: 'CA',
                                                paymentPaidMethod: ticketInfo.paymentPaidMethod == null
                                                    ? payModeNotifier.value == PaymentMode.cod
                                                        ? 'CA'
                                                        : 'CR'
                                                    : ticketInfo.paymentPaidMethod ?? 'CA',
                                                paymentMethodId: ticketInfo.paymentMethod == null ? checkBloc.state.paymentIdStream.value ?? 1 : ticketInfo.paymentMethod ?? 1,
                                                paymentNote: 'paymentNote',
                                                // discountAmount: paymentTypeName == 'Cash' ? '0' : discount(),
                                                // discountAmount: paymentTypeName == 'Cash' ? '0' :actionsBloc.adjustmentAmtOfOthers.value !=null  ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'  : double.parse(discount()) > double.parse(subTotal()) ? subTotal() :  discount(),
                                                discountAmount: paymentTypeName == 'Cash'
                                                    ? '0'
                                                    : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                        ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                        : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                            ? '0.0'
                                                            : double.parse(discount()) > double.parse(subTotal())
                                                                ? subTotal()
                                                                : discount(),

                                                vatPercentage: ticketInfo.vatPercentage == null
                                                    ? paymentTypeName == 'Cash'
                                                        ? vatPercentage() * 100
                                                        : vatValueBeforeDiscountNotifier.value
                                                    : ticketInfo.vatPercentage ?? 0.0,
                                                // vatAmount: paymentTypeName == 'Cash' ? double.parse(vatValue().replaceAll('%', '')) : vatValueBeforeDiscountNotifier.value,
                                                vatAmount: ticketInfo.vatAmount == null
                                                    ? paymentTypeName == 'Cash'
                                                        ? (double.parse(subTotal()) * vatPercentage())
                                                        // ? double.parse(vatValue().replaceAll('%', ''))
                                                        // : (double.parse(subTotal()) * (vatValueBeforeDiscountNotifier.value / 100)),
                                                        // : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatPercentage()),
                                                        // : (int.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value ~/ 100),
                                                        : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value / 100)
                                                    : ticketInfo.vatAmount ?? 0,
                                                // grossAmount: double.parse(total()) - (double.tryParse(vatValue()) ?? 0.0),
                                                grossAmount: ticketInfo.grossAmount == null
                                                    ? paymentTypeName == 'Cash'
                                                        // ? double.parse(total()) - (double.parse(vatValue().replaceAll('%', '')))
                                                        ? (double.parse(total()) - (double.parse(subTotal()) * vatPercentage())).toString()
                                                        : double.parse(discount()) > double.parse(subTotal())
                                                            ? '0.0'
                                                            : (double.parse(subTotal()) -
                                                                    double.parse(discount()) -
                                                                    // (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatPercentage()),
                                                                    (double.parse(subtTotalForDiscountCalculationNotifier.value) * (vatValueBeforeDiscountNotifier.value / 100)))
                                                                .toString()
                                                    : ticketInfo.grossAmount ?? '',
                                                // subTotal: double.parse(total()),
                                                // payment: double.parse(total()),
                                                subTotal: ticketInfo.subTotal == null
                                                    ? paymentTypeName == 'Cash'
                                                        ? double.parse(total())
                                                        : double.parse(discount()) > double.parse(subTotal())
                                                            ? 0
                                                            : (double.parse(subTotal()) - double.parse(discount()))
                                                    : ticketInfo.subTotal ?? 0,

                                                // payment: ticketInfo.payment == null
                                                //     ? paymentTypeName == 'Cash'
                                                //         ? double.parse(total()).toString()
                                                //         : double.parse(discount()) > double.parse(subTotal())
                                                //             ? '0.0'
                                                //             : (double.parse(subTotal()) - double.parse(discount())).toString()
                                                //     : ticketInfo.payment ?? '',

                                                payment: ticketInfo.payment == null
                                                    ? paymentTypeName == 'Cash'
                                                        ? total()
                                                        // : double.parse(discount()) > double.parse(subTotal())
                                                        //     ? '0.0'
                                                        //     : (double.parse(subTotal()) - double.parse(discount())).toString(),
                                                        //     isVatInluded: vatValue() == '0.0%',
                                                        : double.parse(
                                                                  actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                                      ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                                      : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                          ? '0.0'
                                                                          : discount(),
                                                                ) >
                                                                double.parse(subTotal())
                                                            ? '0.0'
                                                            : (double.parse(subTotal()) -
                                                                    double.parse(
                                                                      actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                                          ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                                          : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                                              ? '0.0'
                                                                              : discount(),
                                                                    ))
                                                                .toString()
                                                    : ticketInfo.payment ?? '',
                                              )
                                                  .then((value) async {
                                                // await toastInfo(
                                                //   msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done',
                                                //   gravity: ToastGravity.BOTTOM,
                                                //   backgroundColor: Colors.green[500]!,
                                                // );

                                                checkBloc.state.driverStream.add('');
                                                checkBloc.state.driverIdStream.add(null);
                                                checkBloc.state.outletStream.add('');
                                                checkBloc.state.outletIdStream.add(null);
                                              });
                                              Loader.hide();
                                              Navigator.pop(context);
                                              actionsBloc.barcodeStream.add(ticketNumber ?? '');
                                              actionsBloc.ticketIdStream.add(ticketInfo.id.toString());
                                              successMotionToastInfo(context, msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done');
                                              actionsBloc.getTicketDetails(ticketNumber: ticketNumber ?? '');
                                            }
                                            Loader.hide();
                                          }
                                          // } else {
                                          //   await Fluttertoast.cancel();
                                          //   await toastInfo(
                                          //     msg: 'Please Change CheckIn Status',
                                          //     gravity: ToastGravity.BOTTOM,
                                          //     backgroundColor: Colors.red[500]!,
                                          //   );
                                          // }

                                          // state.amountToBePaidStream.add('220 AED');
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  String vatValue() {
    double vat = 0;
    if (respModel != null) {
      var paymentTypes = <PaymentTypes>[];
      if (paymentTypeName == 'Cash') {
        paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName && e.title == paymentSubTypeName).toList() ?? [];
      } else {
        paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName || e.title == paymentSubTypeName).toList() ?? [];
      }
      final vatSetting = respModel?.data?.vatSetting;

      if (vatSetting?.vatStatus == 'A' && paymentTypes.isNotEmpty && paymentTypes[0].includeVat == 'Y') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Your code here that triggers a rebuild.

          vatValueBeforeDiscountNotifier.value = vat;
          vatValueBeforeDiscountNotifier.notifyListeners();
        });
      } else {
        vat = vatSetting?.vatValue?.toDouble() ?? 0.0;
        // vatValueBeforeDiscountNotifier.value = vat/100;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Your code here that triggers a rebuild.

          vatValueBeforeDiscountNotifier.value = vat;
          vatValueBeforeDiscountNotifier.notifyListeners();
        });
      }
      ////print(vat);
    }
    return '$vat%';
  }

  double vatPercentage() {
    var vatPercentage = 0.0;
    if (respModel != null) {
      var paymentTypes = <PaymentTypes>[];
      if (paymentTypeName == 'Cash') {
        paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName && e.title == paymentSubTypeName).toList() ?? [];
      } else {
        paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName || e.title == paymentSubTypeName).toList() ?? [];
      }
      final vatSetting = respModel?.data?.vatSetting;
      var vatValue = 0;
      // if (vatSetting.vatStatus == 'A' && paymentTypes.isNotEmpty && paymentTypes[0].includeVat == 'Y') {
      //   vatValue = vatSetting.vatValue;
      // }

      // if (vatValue == 0) {
      //   vatPercentage = 0;
      // } else {
      //   vatPercentage = vatValue / 100;
      // }

      vatValue = vatSetting?.vatValue ?? 0;

      if (vatValue == 0) {
        vatPercentage = 0;
      } else {
        vatPercentage = vatValue / 100;
      }
    }
    return vatPercentage;
  }

  String discount() {
    var discount = '0';
    if (respModel != null) {
      final paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName || e.title == paymentSubTypeName).toList();
      // if (paymentTypes[0].payType == 'F' || paymentTypes[0].payType == 'L' || paymentTypes[0].payType == 'I') {}
      // ////print('wwwwwwwwww $paymentTypes');
      if (paymentTypes != null && paymentTypes.isNotEmpty) {
        final startingHours = paymentTypes[0].startingHours ?? 0;
        final startingHourRate = paymentTypes[0].startingHourRate ?? 0;
        final balanceHourRate = paymentTypes[0].balanceHourRate ?? 0;
        var ticketInfo = <TicketInfo>[];
        if (ticketDetails != null) {
          ticketInfo = ticketDetails?.data?.ticketInfo ?? [];
        }

        final totalHours = UtilityFunctions.getHoursInDuration(
          startTimeString: ticketInfo[0].initialCheckinTime!,
          endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
            // UtilityFunctions.convertLocalToDubaiTime().isNegative
            //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
            //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
          ),
          checkoutStatus: ticketInfo[0].checkoutStatus ?? 'N',
          checkoutTime: ticketInfo[0].checkoutTime,
        );

        // print('3333333333333333333333 $totalHours');

        if (paymentTypes[0].payType == 'F') {
          discount = subTotal();
        } else if (totalHours > startingHours) {
          // print('11111111111111111111111111');
          final extraCharge = balanceHourRate * (totalHours - startingHours);
          discount = (startingHourRate + extraCharge).toString();
        } else {
          // print('222222222222222222222222222222');
          discount = startingHourRate.toString();
        }
      }
    }
    return discount;
  }

  String total() {
    if (respModel != null) {
      final paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName && e.title == paymentSubTypeName).toList();
      final vatSetting = respModel?.data?.vatSetting;
      var vatValue = 0;
      if (vatSetting?.vatStatus == 'A') {
        vatValue = vatSetting?.vatValue ?? 0;
      }

      var vatPercentage = 0.0;

      if (vatValue == 0) {
        vatPercentage = 1;
      } else {
        vatPercentage = vatValue / 100;
      }

      // ignore: omit_local_variable_types
      double subTotal = 0;
      if (paymentTypes != null && paymentTypes.isNotEmpty) {
        if (paymentTypes[0].payType == 'F' && paymentTypes[0].includeVat == 'Y' && vatValue != 0 ||
            paymentTypes[0].payType == 'L' && paymentTypes[0].includeVat == 'Y' && vatValue != 0 ||
            paymentTypes[0].payType == 'I' && paymentTypes[0].includeVat == 'Y' && vatValue != 0) {
          final startingHours = paymentTypes[0].startingHours ?? 0;
          final startingHourRate = paymentTypes[0].startingHourRate ?? 0;
          final balanceHourRate = paymentTypes[0].balanceHourRate ?? 0;
          // final vatPercentage = ;

          var ticketInfo = <TicketInfo>[];
          if (ticketDetails != null) {
            ticketInfo = ticketDetails?.data?.ticketInfo ?? [];
          }

          var totalHours = 0;
          if (ticketInfo.isNotEmpty) {
            // final totalHours = UtilityFunctions.getHoursInDuration(
            //   startTimeString: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(ticketInfo[0].initialCheckinTime)),
            //   endTimeString: UtilityFunctions.extractTimeFromDateTime(),
            // );
            totalHours = UtilityFunctions.getHours2(
              startTimeString: ticketInfo[0].initialCheckinTime!,
              endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                // UtilityFunctions.convertLocalToDubaiTime().isNegative
                //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
              ),
            );

            print(totalHours);
          }

          if (totalHours > startingHours) {
            final extraCharge = balanceHourRate * (totalHours - startingHours);
            subTotal = (startingHourRate + extraCharge).floorToDouble();
          } else {
            subTotal = startingHourRate.toDouble();
          }
        } else if (paymentTypes[0].payType == 'F' && paymentTypes[0].includeVat == 'N' ||
            paymentTypes[0].payType == 'L' && paymentTypes[0].includeVat == 'N' ||
            paymentTypes[0].payType == 'I' && paymentTypes[0].includeVat == 'N') {
          final startingHours = paymentTypes[0].startingHours ?? 0;
          final startingHourRate = paymentTypes[0].startingHourRate ?? 0;
          final balanceHourRate = paymentTypes[0].balanceHourRate ?? 0;
          // final vatPercentage = ;

          var ticketInfo = <TicketInfo>[];
          if (ticketDetails != null) {
            ticketInfo = ticketDetails?.data?.ticketInfo ?? [];
          }

          var totalHours = 0;
          if (ticketInfo.isNotEmpty) {
            // final totalHours = UtilityFunctions.getHoursInDuration(
            //   startTimeString: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(ticketInfo[0].initialCheckinTime)),
            //   endTimeString: UtilityFunctions.extractTimeFromDateTime(),
            // );
            totalHours = UtilityFunctions.getHours2(
              startTimeString: ticketInfo[0].initialCheckinTime!,
              endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
                DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
                // UtilityFunctions.convertLocalToDubaiTime().isNegative
                //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
                //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
              ),
            );

            print('totalHours: $totalHours');

            //print(totalHours);
          }

          if (totalHours > startingHours) {
            final extraCharge = balanceHourRate * (totalHours - startingHours);
            subTotal = (startingHourRate + extraCharge) + ((startingHourRate + extraCharge) * vatPercentage);
            // ////print('wwwwwwwwwww ${(startingHourRate + extraCharge) * vatPercentage}');
            // ////print('wwwwwwwwwww $subTotal');
          } else {
            subTotal = startingHourRate + (startingHourRate * vatPercentage);
          }
        }
      }
      // if (paymentTypeName == 'Cash') {
      //   totalForDiscountCalculationNotifier.value = subTotal.toString();
      //   totalForDiscountCalculationNotifier.notifyListeners();
      // }
      // return totalForDiscountCalculationNotifier.value == '0.0' ? subTotal.toString() : totalForDiscountCalculationNotifier.value;

      if (paymentTypeName == 'Cash') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Your code here that triggers a rebuild.

          totalForDiscountCalculationNotifier.value = subTotal.toString();
          totalForDiscountCalculationNotifier.notifyListeners();
        });
      }
      return subTotal.toString();
    } else {
      return 'Not Found';
    }
  }

  String subTotal() {
    if (respModel != null) {
      final paymentTypes = respModel?.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypeName && e.title == paymentSubTypeName).toList();

      // ignore: omit_local_variable_types
      int subTotal = 0;
      if (paymentTypes != null && paymentTypes.isNotEmpty) {
        final startingHours = paymentTypes[0].startingHours ?? 0;
        final startingHourRate = paymentTypes[0].startingHourRate ?? 0;
        final balanceHourRate = paymentTypes[0].balanceHourRate ?? 0;
        // final vatPercentage = ;

        var ticketInfo = <TicketInfo>[];
        if (ticketDetails != null) {
          ticketInfo = ticketDetails?.data?.ticketInfo ?? [];
        }

        var totalHours = 0;
        if (ticketInfo.isNotEmpty) {
          // final totalHours = UtilityFunctions.getHoursInDuration(
          //   startTimeString: UtilityFunctions.extractTimeFromDateTime(datetime: DateTime.parse(ticketInfo[0].initialCheckinTime)),
          //   endTimeString: UtilityFunctions.extractTimeFromDateTime(),
          // );
          totalHours = UtilityFunctions.getHours2(
            startTimeString: ticketInfo[0].initialCheckinTime!,
            endTimeString: DateFormat('yyyy-MM-dd HH:mm:ss').format(
              DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
              // UtilityFunctions.convertLocalToDubaiTime().isNegative
              //     ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
              //     : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime()),
            ),
          );

          //print(totalHours);
        }

        if (totalHours > startingHours) {
          final extraCharge = balanceHourRate * (totalHours - startingHours);
          subTotal = startingHourRate + extraCharge;
          // ////print('wwwwwwwwwww ${(startingHourRate + extraCharge) * vatPercentage}');
          // ////print('wwwwwwwwwww $subTotal');
        } else {
          subTotal = startingHourRate;
        }
      }

      if (paymentTypeName == 'Cash') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Your code here that triggers a rebuild.

          subtTotalForDiscountCalculationNotifier.value = subTotal.toString();
          subtTotalForDiscountCalculationNotifier.notifyListeners();
        });
      }

      return paymentTypeName == 'Cash'
          ? subTotal.toString()
          : totalForDiscountCalculationNotifier.value == '0.0'
              ? subTotal.toString()
              : totalForDiscountCalculationNotifier.value;
    } else {
      return '';
    }
  }

  Future<dynamic> _searchingDriver(
    BuildContext context, {
    required AllCheckOutItemsResponse respModel,
  }) {
    // var driversList = sampleDriversList;

    final bloc = Provider.of<CheckOutBloc>(context, listen: false);

    final driversList = ValueNotifier<List<String>>(
      respModel.data?.cvas?.map((e) => e.departmentName ?? '').toList() ?? [],
    );

    var driversIdsList = respModel.data?.cvas?.map((e) => e.departmentId).toList();

    return showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(
      //     30.r,
      //   ),
      // ),
      context: context,
      builder: (context) => DecoratedBox(
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
                      driversList.value = respModel?.data?.cvas?.map((e) => e.departmentName ?? '').toList() ?? [];
                      driversList.notifyListeners();

                      driversIdsList = respModel.data?.cvas?.map((e) => e.departmentId).toList();
                    } else {
                      // setState(() {
                      //   driversList = sampleDriversList.where((elem) {
                      //     return elem
                      //         .toLowerCase()
                      //         .trim()
                      //         .contains(value.toLowerCase().trim());
                      //   }).toList();
                      // });
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
                    hintStyle: const TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          dense: true,
                          leading: SizedBox(
                            child: Image.asset(
                              'assets/images/driver-removebg-preview.png',
                              width: 30,
                            ),
                          ),
                          title: Text(driversList.value[index]),
                          onTap: () {
                            bloc.state.driverStream.add(driversList.value[index]);
                            bloc.state.driverIdStream.add(driversIdsList?[index]);
                            // print(driversIdsList[index]);
                            // print(driversIdsList[index]);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _searchingOutlet(
    BuildContext context, {
    required AllCheckOutItemsResponse respModel,
  }) {
    // var outletList = sampleOultetList;

    final bloc = Provider.of<CheckOutBloc>(context, listen: false);

    final outletsList = ValueNotifier<List<String>>(
      respModel.data?.outlets?.map((e) => e.outletPostName ?? '').toList() ?? [],
    );

    var outletsIdsList = respModel.data?.outlets?.map((e) => e.outletId).toList();

    return showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(
      //     20.r,
      //   ),
      // ),
      context: context,
      builder: (context) => DecoratedBox(
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
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return TextField(
                      onChanged: (value) {
                        if (value == '') {
                          outletsList.value = respModel.data?.outlets?.map((e) => e.outletPostName ?? '').toList() ?? [];
                          outletsList.notifyListeners();
                        } else {
                          // setState(() {
                          //   outletsList = sampleoutletsList.where((elem) {
                          //     return elem
                          //         .toLowerCase()
                          //         .trim()
                          //         .contains(value.toLowerCase().trim());
                          //   }).toList();
                          // });
                          outletsList.value = respModel.data?.outlets
                                  ?.map((e) => e.outletPostName ?? '')
                                  .where(
                                    (element) => element.toLowerCase().trim().contains(value.toLowerCase().trim()),
                                  )
                                  .toList() ??
                              [];
                          outletsList.notifyListeners();

                          outletsIdsList = respModel.data?.outlets?.map((e) => e.outletId).toList();
                        }
                      },
                      cursorColor: Colors.grey[700],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 15),
                        hintText: 'Searching brand ...',
                        hintStyle: const TextStyle(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            //

            ValueListenableBuilder(
              valueListenable: outletsList,
              builder: (context, list, _) {
                return Column(
                  children: List.generate(
                    outletsList.value.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          dense: true,
                          leading: SizedBox(
                            child: Image.asset(
                              'assets/images/store.png',
                              width: 30,
                            ),
                          ),
                          title: Text(outletsList.value[index]),
                          onTap: () {
                            bloc.state.outletStream.add(outletsList.value[index]);
                            bloc.state.outletIdStream.add(outletsIdsList?[index]);
                            ////print(driversIdsList[index]);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _customModalSheet(BuildContext context, {bool isPaymentPage = false}) {
    final checkBloc = Provider.of<CheckOutBloc>(context, listen: false);
    final actionsBloc = Provider.of<ActionsBloc>(context, listen: false);
    return showModalBottomSheet(
      backgroundColor: Colors.grey[300],
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => Container(
        // height: 390,
        height: 250,
        // decoration: BoxDecoration(
        //   // color: Colors.grey[300],
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(15),
        //     topRight: Radius.circular(15),
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Payment Mode',
                  style: GoogleFonts.openSans().copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Center(
                child: Text(
                  // 'Total Payment : ${ticketDetails != null && ticketDetails!.data != null && ticketDetails!.data!.ticketInfo != null && ticketDetails!.data!.ticketInfo!.isEmpty ? 0 : ticketDetails?.data?.ticketInfo?[0].payment}',
                  // 'Total Payment : ${total()}',
                  'Total Payment : ${paymentTypeName == 'Cash' ? total()
                      // : double.parse(discount()) > double.parse(subTotal())
                      //     ? '0.0'
                      //     : (double.parse(subTotal()) - double.parse(discount())).toString(),
                      //     isVatInluded: vatValue() == '0.0%',
                      : double.parse(
                            actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                    ? '0.0'
                                    : discount(),
                          ) > double.parse(subTotal()) ? '0.0' : (double.parse(subTotal()) - double.parse(
                            actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                    ? '0.0'
                                    : discount(),
                          )).toString()}',
                  style: GoogleFonts.openSans().copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            // const PayModes(
            //   iconUrl: 'assets/images/paypal.png',
            //   upiOrNumber: '***09@paypal.com',
            //   radioValue: PaymentMode.paypal,
            // ),
            // const PayModes(
            //   iconUrl: 'assets/images/gpay.png',
            //   upiOrNumber: '***09@okhdfc.com',
            //   radioValue: PaymentMode.gpay,
            // ),
            const PayModes(
              iconUrl: 'assets/images/card.png',
              upiOrNumber: 'Debit or Credit Card',
              radioValue: PaymentMode.visa,
            ),
            const PayModes(
              iconUrl: 'assets/images/cod.png',
              upiOrNumber: 'Pay in Cash',
              radioValue: PaymentMode.cod,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 25,
                right: 25,
              ),
              child: SizedBox(
                height: 32,
                width: 80,
                child: StreamBuilder(
                  stream: checkBloc.state.paymentIdStream,
                  builder: (context, snapshot) {
                    return ElevatedButton(
                      onPressed: () async {
                        // if (checkOutProgressNotifier.value == CheckOutProgress.paymentSection) {
                        //   checkOutProgressNotifier.value = CheckOutProgress.driverSection;
                        //   checkOutProgressNotifier.notifyListeners();
                        //   Navigator.pop(context);
                        // }
                        if (ticketDetails != null && ticketDetails!.data != null && ticketDetails!.data!.ticketInfo != null && ticketDetails!.data!.ticketInfo!.isNotEmpty) {
                          final ticketInfo = ticketDetails!.data!.ticketInfo![0];
                          // //print('5555555555555555555 ${ticketInfo.checkoutStatus}');
                          // //print('typeeeeeeeeeeeeeee :$paymentTypeName ${checkBloc.state.paymentIdStream.value}');
                          customLoader(context);
                          await checkBloc
                              .checkOutSubmit(
                            id: ticketInfo.id.toString(),
                            // status: ticketInfo.checkoutStatus,
                            // status: 'R',
                            // status: isPaymentPage ? ticketInfo.checkoutStatus ?? 'N' : 'Y',
                            status: isPaymentPage ? ticketInfo.checkoutStatus! : 'Y',
                            ticketNumber: ticketInfo.barcode!,
                            // ticketNumber: 'ticketInfo.barcode',
                            cvaOutId: checkBloc.state.driverIdStream.valueOrNull == null
                                ? ticketInfo.cvaOut == 0
                                    ? null
                                    : ticketInfo.cvaOut
                                : checkBloc.state.driverIdStream.value!,

                            outletId: checkBloc.state.outletIdStream.valueOrNull == null
                                ? ticketInfo.outletId == 0
                                    ? null
                                    : ticketInfo.outletId
                                : checkBloc.state.outletIdStream.value!,
                            // paymentPaidMethod: ticketInfo.paymentPaidMethod,
                            paymentPaidMethod: payModeNotifier.value == PaymentMode.cod ? 'CA' : 'CR',
                            // paymentMethodId: checkBloc.state.paymentIdStream.value ?? 0,
                            paymentMethodId: ticketInfo.paymentMethod == null ? checkBloc.state.paymentIdStream.valueOrNull ?? 1 : ticketInfo.paymentMethod ?? 1,
                            paymentNote: 'paymentNote',
                            // discountAmount: paymentTypeName == 'Cash' ? '0' : discount(),
                            //  discountAmount: paymentTypeName == 'Cash' ? '0' :actionsBloc.adjustmentAmtOfOthers.value !=null  ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'  : double.parse(discount()) > double.parse(subTotal()) ? subTotal() :  discount(),
                            discountAmount: paymentTypeName == 'Cash'
                                ? '0'
                                : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                    ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                    : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                        ? '0.0'
                                        : double.parse(discount()) > double.parse(subTotal())
                                            ? subTotal()
                                            : discount(),
                            vatPercentage: paymentTypeName == 'Cash' ? vatPercentage() * 100 : vatValueBeforeDiscountNotifier.value,
                            // vatAmount: paymentTypeName == 'Cash' ? double.parse(vatValue().replaceAll('%', '')) : vatValueBeforeDiscountNotifier.value,
                            vatAmount: paymentTypeName == 'Cash'
                                ? (double.parse(subTotal()) * vatPercentage())
                                // ? double.parse(vatValue().replaceAll('%', ''))
                                // : (double.parse(subTotal()) * (vatValueBeforeDiscountNotifier.value / 100)),
                                // : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatPercentage()),
                                // : (int.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value ~/ 100),
                                : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value / 100),
                            // grossAmount: double.parse(total()) - (double.tryParse(vatValue()) ?? 0.0),
                            grossAmount: paymentTypeName == 'Cash'
                                // ? double.parse(total()) - (double.parse(vatValue().replaceAll('%', '')))
                                ? (double.parse(total()) - (double.parse(subTotal()) * vatPercentage())).toString()
                                : double.parse(discount()) > double.parse(subTotal())
                                    ? '0.0'
                                    : (double.parse(subTotal()) -
                                            double.parse(discount()) -
                                            // (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatPercentage()),
                                            (double.parse(subtTotalForDiscountCalculationNotifier.value) * (vatValueBeforeDiscountNotifier.value / 100)))
                                        .toString(),
                            // subTotal: double.parse(total()),
                            // payment: double.parse(total()),

                            // subTotal: paymentTypeName == 'Cash'
                            //     ? double.parse(total())
                            //     : double.parse(discount()) > double.parse(subTotal())
                            //         ? 0
                            //         : (double.parse(subTotal()) - double.parse(discount())),
                            subTotal: double.parse(subTotal()),

                            // payment: paymentTypeName == 'Cash'
                            //     ? double.parse(total()).toString()
                            //     : double.parse(discount()) > double.parse(subTotal())
                            //         ? '0.0'
                            //         : (double.parse(subTotal()) - double.parse(discount())).toString(),

                            payment: paymentTypeName == 'Cash'
                                ? double.parse(total()).toString()
                                : double.parse(
                                          actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                              ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                              : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                  ? '0.0'
                                                  : discount(),
                                        ) >
                                        double.parse(subTotal())
                                    ? '0.0'
                                    : (double.parse(subTotal()) -
                                            double.parse(
                                              actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                  ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                  : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                      ? '0.0'
                                                      : discount(),
                                            ))
                                        .toString(),
                          )
                              .then((value) async {
                            // await toastInfo(
                            //   msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done',
                            //   gravity: ToastGravity.BOTTOM,
                            //   backgroundColor: Colors.green[500]!,
                            // );
                          });
                          checkBloc.state.driverStream.add('');
                          checkBloc.state.driverIdStream.add(null);
                          checkBloc.state.outletStream.add('');
                          checkBloc.state.outletIdStream.add(null);
                          Loader.hide();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          actionsBloc.barcodeStream.add(ticketNumber ?? '');
                          actionsBloc.ticketIdStream.add(ticketInfo.id.toString());
                          successMotionToastInfo(context, msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done');
                          actionsBloc.getTicketDetails(ticketNumber: ticketNumber ?? '');
                        }
                        Loader.hide();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 88, 69, 197),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Pay', style: TextStyle(color: Colors.white, fontSize: 12)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _customModalSheetForZeroPayment(BuildContext context, {bool isPaymentPage = false}) {
    final checkBloc = Provider.of<CheckOutBloc>(context, listen: false);
    final actionsBloc = Provider.of<ActionsBloc>(context, listen: false);
    return showModalBottomSheet(
      backgroundColor: Colors.grey[300],
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => Container(
        // height: 390,
        height: 120,
        // decoration: BoxDecoration(
        //   // color: Colors.grey[300],
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(15),
        //     topRight: Radius.circular(15),
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Text(
                'Payment Confirm',
                style: GoogleFonts.openSans().copyWith(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Text(
                // 'Total Payment : ${ticketDetails != null && ticketDetails!.data != null && ticketDetails!.data!.ticketInfo != null && ticketDetails!.data!.ticketInfo!.isEmpty ? 0 : ticketDetails?.data?.ticketInfo?[0].payment}',
                // 'Total Payment : ${total()}',
                'Total Payment : ${paymentTypeName == 'Cash' ? total()
                    // : double.parse(discount()) > double.parse(subTotal())
                    //     ? '0.0'
                    //     : (double.parse(subTotal()) - double.parse(discount())).toString(),
                    //     isVatInluded: vatValue() == '0.0%',
                    : double.parse(
                          actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                              ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                              : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                  ? '0.0'
                                  : discount(),
                        ) > double.parse(subTotal()) ? '0.0' : (double.parse(subTotal()) - double.parse(
                          actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                              ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                              : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                  ? '0.0'
                                  : discount(),
                        )).toString()}',
                style: GoogleFonts.openSans().copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 32,
                  width: 80,
                  child: StreamBuilder(
                    stream: checkBloc.state.paymentIdStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (ticketDetails != null && ticketDetails!.data != null && ticketDetails!.data!.ticketInfo != null && ticketDetails!.data!.ticketInfo!.isNotEmpty) {
                            final ticketInfo = ticketDetails!.data!.ticketInfo![0];

                            customLoader(context);
                            await checkBloc
                                .checkOutSubmit(
                                  id: ticketInfo.id.toString(),
                                  status: isPaymentPage ? ticketInfo.checkoutStatus! : 'Y',
                                  ticketNumber: ticketInfo.barcode!,
                                  cvaOutId: checkBloc.state.driverIdStream.valueOrNull == null
                                      ? ticketInfo.cvaOut == 0
                                          ? null
                                          : ticketInfo.cvaOut
                                      : checkBloc.state.driverIdStream.value!,
                                  outletId: checkBloc.state.outletIdStream.valueOrNull == null
                                      ? ticketInfo.outletId == 0
                                          ? null
                                          : ticketInfo.outletId
                                      : checkBloc.state.outletIdStream.value!,
                                  // paymentPaidMethod: payModeNotifier.value == PaymentMode.cod ? 'CA' : 'CR',
                                  paymentPaidMethod: 'CA',
                                  paymentMethodId: ticketInfo.paymentMethod == null ? checkBloc.state.paymentIdStream.valueOrNull ?? 1 : ticketInfo.paymentMethod ?? 1,
                                  paymentNote: 'paymentNote',
                                  discountAmount: paymentTypeName == 'Cash'
                                      ? '0'
                                      : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                          ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                          : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                              ? '0.0'
                                              : double.parse(discount()) > double.parse(subTotal())
                                                  ? subTotal()
                                                  : discount(),
                                  vatPercentage: paymentTypeName == 'Cash' ? vatPercentage() * 100 : vatValueBeforeDiscountNotifier.value,
                                  vatAmount: paymentTypeName == 'Cash'
                                      ? (double.parse(subTotal()) * vatPercentage())
                                      : (double.parse(subtTotalForDiscountCalculationNotifier.value) * vatValueBeforeDiscountNotifier.value / 100),
                                  grossAmount: paymentTypeName == 'Cash'
                                      ? (double.parse(total()) - (double.parse(subTotal()) * vatPercentage())).toString()
                                      : double.parse(discount()) > double.parse(subTotal())
                                          ? '0.0'
                                          : (double.parse(subTotal()) -
                                                  double.parse(discount()) -
                                                  (double.parse(subtTotalForDiscountCalculationNotifier.value) * (vatValueBeforeDiscountNotifier.value / 100)))
                                              .toString(),
                                  subTotal: double.parse(subTotal()),
                                  payment: paymentTypeName == 'Cash'
                                      ? double.parse(total()).toString()
                                      : double.parse(
                                                actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                    ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                    : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                        ? '0.0'
                                                        : discount(),
                                              ) >
                                              double.parse(subTotal())
                                          ? '0.0'
                                          : (double.parse(subTotal()) -
                                                  double.parse(
                                                    actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isNotEmpty
                                                        ? actionsBloc.adjustmentAmtOfOthers.value ?? '0.0'
                                                        : actionsBloc.adjustmentAmtOfOthers.value != null && actionsBloc.adjustmentAmtOfOthers.value!.isEmpty
                                                            ? '0.0'
                                                            : discount(),
                                                  ))
                                              .toString(),
                                )
                                .then((value) async {});
                            checkBloc.state.driverStream.add('');
                            checkBloc.state.driverIdStream.add(null);
                            checkBloc.state.outletStream.add('');
                            checkBloc.state.outletIdStream.add(null);
                            Loader.hide();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            actionsBloc.barcodeStream.add(ticketNumber ?? '');
                            actionsBloc.ticketIdStream.add(ticketInfo.id.toString());
                            successMotionToastInfo(context, msg: '${isPaymentPage ? 'Payment' : 'CheckOut'} Sucessfully Done');
                            actionsBloc.getTicketDetails(ticketNumber: ticketNumber ?? '');
                          }
                          Loader.hide();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 88, 69, 197),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Pay', style: TextStyle(color: Colors.white, fontSize: 12)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayModes extends StatelessWidget {
  const PayModes({
    required this.iconUrl,
    required this.upiOrNumber,
    required this.radioValue,
    super.key,
  });

  final String iconUrl;
  final String upiOrNumber;
  final PaymentMode radioValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 25,
        left: 25,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        dense: true,
        tileColor: Colors.white,
        leading: SizedBox(
          width: 25,
          child: Image.asset(
            iconUrl,
          ),
        ),
        horizontalTitleGap: 22,
        title: Text(
          upiOrNumber,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: ValueListenableBuilder(
          valueListenable: payModeNotifier,
          builder: (context, payMode, _) {
            return Radio<PaymentMode>(
              activeColor: const Color.fromARGB(255, 88, 69, 197),
              value: radioValue,
              groupValue: payModeNotifier.value,
              onChanged: (value) {
                payModeNotifier.value = value ?? PaymentMode.paypal;
                payModeNotifier.notifyListeners();
              },
            );
          },
        ),
      ),
    );
  }
}

class _BottomSheetItems2 extends StatelessWidget {
  const _BottomSheetItems2({
    required this.field,
    required this.value,
    this.isVatInluded = false,
  });
  final String field;
  final String value;
  final bool isVatInluded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: 220,
            child: Text(
              textAlign: TextAlign.right,
              field,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Text(
            ' :',
            style: TextStyle(
              color: Colors.grey,
              // fontSize: 18,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 220,
            child: Text(
              textAlign: TextAlign.start,
              isVatInluded ? '$value (VAT included)' : value,
              style: const TextStyle(
                color: Colors.grey,
                // fontSize: 18,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _bottomSheetItems extends StatelessWidget {
  const _bottomSheetItems({
    required this.field,
    required this.value,
  });
  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        top: 15,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                // color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              field,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmtAdjustTextField extends StatefulWidget {
  const _AmtAdjustTextField({
    required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    required this.keyboardType,
    this.textAlign,
    this.contentPadding,
    this.hintStyle,
  });

  final BehaviorSubject<String?> textStream;
  final void Function(String) onTextChanged;
  final String hintText;
  final TextInputType keyboardType;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;

  @override
  State<_AmtAdjustTextField> createState() => _AmtAdjustTextFieldState();
}

class _AmtAdjustTextFieldState extends State<_AmtAdjustTextField> {
  final _controller = TextEditingController();
  @override
  void initState() {
    widget.textStream.listen((value) {
      if (value == null) {
        _controller.clear();
      } else if (value.isEmpty) {
        _controller.clear();
      } else if (_controller.text != value) {
        _controller.text = value;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onTextChanged,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      textAlign: widget.textAlign ?? TextAlign.center,
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
    );
  }
}
