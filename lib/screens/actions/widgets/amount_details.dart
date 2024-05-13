// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum PaymentMode { paypal, gpay, visa, cod }

final ValueNotifier<PaymentMode> payModeNotifier = ValueNotifier(PaymentMode.cod);

final ValueNotifier<String> totalForDiscountCalculationNotifier = ValueNotifier('0.0');
final ValueNotifier<String> subtTotalForDiscountCalculationNotifier = ValueNotifier('0.0');
final ValueNotifier<double> vatValueBeforeDiscountNotifier = ValueNotifier(0);

class AmountDetails extends StatelessWidget {
  const AmountDetails({
    required this.ticketNumber,
    // this.ticketDetails,
    // this.respModel,
    this.paymentTypeName,
    this.paymentSubTypeName,
    this.isPaymentPage = false,
    this.isOtherPaySection = false,
    Key? key,
  }) : super(key: key);

  final bool isPaymentPage;
  final bool isOtherPaySection;
  final String? ticketNumber;
  // final TicketDetailsResponseModel? ticketDetails;
  // final AllCheckOutItemsResponse? respModel;
  final String? paymentTypeName;
  final String? paymentSubTypeName;

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 20),
                        // Net Amount
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 10,
                            right: 10,
                            // right: 70,
                            // left: 70,
                          ),
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
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Net Amount: ',
                                          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5),

                                        // ),
                                        Text(
                                          '220 AED',
                                          style: TextStyle(color: Color.fromARGB(255, 126, 65, 155), fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Stack(
                            children: [
                              Column(
                                children: [
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
                                          const _BottomSheetItems2(
                                            field: 'Created Date & Time',
                                            value: '15-06-2023 14:39:00',
                                          ),
                                          // if (ticketInfo[0].requestedTime != null)
                                          const _BottomSheetItems2(
                                            field: 'Request Date & Time',
                                            value: '16-06-2023 13:39:50',
                                            // value: ticketInfo.isEmpty ? 'nill' : ticketInfo[0].requestedTime ?? 'nill',
                                          ),
                                          const _BottomSheetItems2(
                                            field: 'Total Duration',
                                            value: '23 Hr 0 Min 50 Sec',
                                          ),
                                          // if (vatValue() != '0.0%')
                                          const _BottomSheetItems2(
                                            field: 'Sub Total',
                                            // value: subTotal(),
                                            value: '50',
                                          ),
                                          if (paymentTypeName == 'Cash')
                                            const Column(
                                              children: [
                                                // if (vatValue() != '0.0%')
                                                _BottomSheetItems2(
                                                  field: 'VAT',
                                                  // value: vatValue(),
                                                  value: '5 %',
                                                ),
                                              ],
                                            )
                                          else
                                            const _BottomSheetItems2(
                                              field: 'Discount',
                                              value: '10',
                                            ),
                                          const _BottomSheetItems2(
                                            field: 'Total',
                                            value: '120',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Positioned(
                              //   top: 0,
                              //   bottom: 0,
                              //   left: 0,
                              //   right: 0,
                              //   child: DecoratedBox(
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey.withOpacity(.4),
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     child: Center(
                              //       child: Image.asset(
                              //         'assets/images/paid_sign.png',
                              //         width: 180,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        if (!isPaymentPage)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
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
                                          child: Text(
                                            'Select Outlet',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans().copyWith(
                                              color: Colors.grey[700],
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ).ripple(context, () async {}),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
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
                                          child: Text(
                                            'Select Driver',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans().copyWith(
                                              color: Colors.grey[700],
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ).ripple(context, () async {}),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Column(
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
                                      labelStyle: GoogleFonts.openSans().copyWith(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
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
                            // ElevatedButton.icon(
                            //   onPressed: () async {},
                            //   style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 126, 65, 155)),
                            //   label: Text('Confirm', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(.85))),
                            //   // icon: const Icon(Icons.checklist_rounded),
                            //   icon: Icon(
                            //     Icons.check_circle_outline_outlined,
                            //     size: 18,
                            //     color: Colors.white.withOpacity(.8),
                            //   ),
                            // ),

                            if (isPaymentPage) const SizedBox(height: 20),

                            Align(
                              child: Container(
                                margin: const EdgeInsets.only(top: 30, bottom: 30),
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_outlined,
                                          size: 18,
                                          color: Colors.white.withOpacity(.8),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Confirm',
                                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                                          style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
          style: const TextStyle(fontSize: 12),
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
            // color: Colors.red,
            width: 220,
            alignment: Alignment.topLeft,
            // width: MediaQuery.of(context).size.width/2,
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
          Container(
            // color: Colors.red,
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

// class _AmtAdjustTextField extends StatefulWidget {
//   const _AmtAdjustTextField({
//     required this.textStream,
//     required this.onTextChanged,
//     required this.hintText,
//     required this.keyboardType,
//     this.textAlign,
//     this.contentPadding,
//     this.hintStyle,
//   });

//   final BehaviorSubject<String?> textStream;
//   final void Function(String) onTextChanged;
//   final String hintText;
//   final TextInputType keyboardType;
//   final TextAlign? textAlign;
//   final EdgeInsetsGeometry? contentPadding;
//   final TextStyle? hintStyle;

//   @override
//   State<_AmtAdjustTextField> createState() => _AmtAdjustTextFieldState();
// }

// class _AmtAdjustTextFieldState extends State<_AmtAdjustTextField> {
//   final _controller = TextEditingController();
//   @override
//   void initState() {
//     widget.textStream.listen((value) {
//       if (value == null) {
//         _controller.clear();
//       } else if (value.isEmpty) {
//         _controller.clear();
//       } else if (_controller.text != value) {
//         _controller.text = value;
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: _controller,
//       onChanged: widget.onTextChanged,
//       keyboardType: widget.keyboardType,
//       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//       textAlign: widget.textAlign ?? TextAlign.center,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         // hintStyle: TextStyle(fontSize: 12),
//         hintStyle: widget.hintStyle ??
//             AppStyles.openSans.copyWith(
//               color: Colors.grey[700],
//               fontSize: 10.5,
//             ),
//         // contentPadding: EdgeInsets.only(left: 15),
//         contentPadding: widget.contentPadding ?? const EdgeInsets.only(top: 5),
//         border: const OutlineInputBorder(),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color.fromARGB(146, 146, 69, 197),
//           ),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             // color: Color.fromARGB(255, 80, 19, 121),
//             color: Color.fromARGB(146, 146, 69, 197),
//           ),
//         ),
//       ),
//     );
//   }
// }
