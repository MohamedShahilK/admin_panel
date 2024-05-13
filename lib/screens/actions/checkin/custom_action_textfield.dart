// ignore_for_file: lines_longer_than_80_chars, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomActionTextField extends StatefulWidget {
  const CustomActionTextField({
    // required this.bloc,
    // required this.textStream,
    required this.onTextChanged,
    this.errorStream,
  });

  // final ActionsBloc bloc;
  final void Function(String) onTextChanged;
  final Stream<String>? errorStream;
  // final BehaviorSubject<String> textStream;

  // static final GlobalKey<FormState> _loginScreenFormKey = GlobalKey<FormState>();

  @override
  State<CustomActionTextField> createState() => CustomActionTextFieldState();
}

class CustomActionTextFieldState extends State<CustomActionTextField> {
  final _controller = TextEditingController();

  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   widget.bloc.barcodeStream.listen((value) {
  //     if (value.isEmpty) {
  //       _controller.clear();
  //     } else if (_controller.text != value) {
  //       _controller.text = value;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final actionsBloc = Provider.of<ActionsBloc>(context, listen: false);
    return Form(
      // key: CustomActionTextField._loginScreenFormKey,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          // Text(
          //   'Ticket Number',
          //   style: AppStyles.openSans.copyWith(
          //     color: Colors.black,
          //     fontSize: 15,
          //     fontWeight: FontWeight.w900,
          //   ),
          // ),
          // SizedBox(height: 10.h),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width / 2.15,
            child: TextField(
              controller: _controller,
              // onChanged: widget.onTextChanged,
              // onChanged: (value) {
              //   if (_timer?.isActive ?? false) _timer!.cancel();
              //   _timer = Timer(const Duration(milliseconds: 500), () {
              //     widget.onTextChanged(value);
              //   });
              // },
              // initialValue: '51365468665',
              style: GoogleFonts.openSans().copyWith(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              expands: true,
              maxLines: null,
              decoration: InputDecoration(
                // hintText: 'Ticket Number',
                hintText: 'Eg : 2355xxxx6546',
                hintStyle: GoogleFonts.openSans().copyWith(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
                // contentPadding: const EdgeInsets.only(left: 5),
                contentPadding: const EdgeInsets.only(left: 20),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(146, 146, 69, 197),
                  ),
                  // borderRadius: BorderRadius.circular(50.r),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 80, 19, 121)),
                  // borderRadius: BorderRadius.circular(50.r),
                ),

                // suffixIcon: Container(
                //   // color: Colors.red,
                //   padding: EdgeInsets.symmetric(horizontal: 5),
                //   child: Column(
                //     // mainAxisSize: MainAxisSize.min,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       GestureDetector(
                //         onTap: () async {},
                //         child: Container(
                //           // height: 40,
                //           width: 30,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //             border: Border.all(
                //               color: AppColors.borderColor,
                //             ),
                //           ),

                //           child: Image.asset(
                //             'assets/icons/barcode_icon.png',
                //             fit: BoxFit.fill,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 15, left: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Container(
                      //   height: 40,
                      //   width: 30,
                      //   color: Colors.orange,
                      //   alignment: Alignment.center,
                      // ),

                      // Text(
                      //   'Generate',
                      //   style: AppStyles.generateButtonStyle,
                      // ),
                      Icon(
                        // FontAwesomeIcons.arrowsRotate,
                        Icons.check,
                        size: 20,
                        color: Color.fromARGB(255, 146, 69, 197),
                      ),
                    ],
                  ),
                ),
                prefixIcon: InkWell(
                  onTap: () {
                    // final bloc = Provider.of<ActionsBloc>(context, listen: false);
                    // customLoader(context);
                    // Future.delayed(
                    //   const Duration(seconds: 1),
                    //   () async {
                    //     final minValue = StorageServices.to.getInt(StorageServicesKeys.minValue);
                    //     final maxValue = StorageServices.to.getInt(StorageServicesKeys.maxValue);
                    //     // statusNotifier.value = 'CheckIn';
                    //     // statusNotifier.notifyListeners();
                    //     final rng = Random();
                    //     final code = rng.nextInt(9000000) + rng.nextInt(9999999);
                    //     if (code.toString().length >= minValue && !(code.toString().length > maxValue)) {
                    //       bloc.barcodeStream.add(code.toString());
                    //       bloc.ticketIdStream.add('');
                    //       // //print('111111111111 ${await bloc.checkTicketExists(ticketNumber: code.toString())}');
                    //       await bloc.getTicketDetails(ticketNumber: code.toString());
                    //       // print('222222222222222222222 $code');
                    //       if (await bloc.checkTicketExists(ticketNumber: code.toString())) {
                    //         isExpandedNotifier.value = true;
                    //         isExpandedNotifier.notifyListeners();
                    //       }
                    //     }
                    //     // setState(() {
                    //     //   _controller.text = code.toString();
                    //     // });
                    //     widget.bloc.barcodeStream.add(code.toString());
                    //     Loader.hide();
                    //   },
                    // );

                    final rng = Random();
                    final code = rng.nextInt(9000000) + rng.nextInt(9999999);
                    _controller.text = code.toString();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15, left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Container(
                        //   height: 40,
                        //   width: 30,
                        //   color: Colors.orange,
                        //   alignment: Alignment.center,
                        // ),

                        // Text(
                        //   'Generate',
                        //   style: AppStyles.generateButtonStyle,
                        // ),
                        Icon(
                          // FontAwesomeIcons.arrowsRotate,
                          Icons.refresh,
                          size: 20,
                          color: Color.fromARGB(255, 146, 69, 197),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // StreamBuilder<String>(
          //   stream: widget.errorStream,
          //   builder: (context, snapshot) {
          //     final error = snapshot.data ?? '';
          //     return StreamBuilder<String>(
          //       stream: widget.textStream,
          //       builder: (context, textSnapshot) {
          //         final textData = textSnapshot.data ?? '';
          //         // if (widget.isEmptyError &&
          //         //     textData.isEmpty &&
          //         //     error.isNotEmpty) {
          //         //   return _ErrorTextWidget(errorText: error);
          //         // } else if (!widget.isEmptyError && error.isNotEmpty) {
          //         //   return _ErrorTextWidget(errorText: error);
          //         // } else {
          //         //   return Container();
          //         // }
          //         if (textData.isEmpty && error.isNotEmpty) {
          //           return ErrorTextWidget(errorText: error);
          //         } else if (textData.isNotEmpty && error.isNotEmpty) {
          //           return ErrorTextWidget(errorText: error);
          //         } else {
          //           return Container();
          //         }
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
