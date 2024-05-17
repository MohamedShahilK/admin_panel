import 'package:admin_panel/logic/check_out/check_out_bloc.dart';
import 'package:admin_panel/models/new/actions/checkout_form/all_checkout_items.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/screens/actions/widgets/amount_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({
    required this.respModel,
    required this.ticketNumber,
    this.ticketDetails,
    this.isPaymentPage = false,
    super.key,
  });

  final AllCheckOutItemsResponse respModel;
  final String? ticketNumber;
  final TicketDetailsResponseModel? ticketDetails;
  final bool isPaymentPage;

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> paymentTypes = [];
  List<PaymentTypes> cashSubTypes = [];

  CheckOutBloc? bloc;

  @override
  void initState() {
    super.initState();

    paymentTypes = widget.respModel.data?.paymentTypes
            ?.map((e) {
              if (e.paymentTypeName == 'Membership 1') {
                return e.title ?? '';
              } else {
                return e.paymentTypeName ?? '';
              }
            })
            .toSet()
            .toList() ??
        [];

    cashSubTypes = widget.respModel.data?.paymentTypes?.where((e) => e.paymentTypeName == 'Cash').toList() ?? [];
    cashSubTypes.removeWhere((element) => element.title == '');

    var tabIndex = 0;

    if (widget.ticketDetails != null &&
        widget.ticketDetails!.data != null &&
        widget.ticketDetails!.data!.ticketInfo != null &&
        widget.ticketDetails!.data!.ticketInfo!.isNotEmpty &&
        widget.ticketDetails!.data!.ticketInfo![0].payment != null) {
      final payMethodName = widget.respModel.data?.paymentTypes?.firstWhere((e) => e.paymentTypeId == widget.ticketDetails!.data!.ticketInfo![0].paymentMethod).paymentTypeName ?? 'Cash';

      // final index = paymentTypes.indexWhere((e) => e == payMethodName);

      // if (index == -1) {
      //   tabIndex = 0;
      // } else {
      //   tabIndex = index;
      // }
    }

    _tabController = TabController(
      length: paymentTypes.length, // Number of tabs
      vsync: this,
      initialIndex: tabIndex, // Initial tab index
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc ??= Provider.of<CheckOutBloc>(context);
    if (widget.ticketDetails != null &&
        widget.ticketDetails!.data != null &&
        widget.ticketDetails!.data!.ticketInfo != null &&
        widget.ticketDetails!.data!.ticketInfo!.isNotEmpty &&
        widget.ticketDetails!.data!.ticketInfo![0].paymentMethod != null) {
      bloc!.state.paymentIdStream.add(widget.ticketDetails!.data!.ticketInfo![0].paymentMethod);
    }
    // else if (widget.ticketDetails != null &&
    //     widget.ticketDetails!.data != null &&
    //     widget.ticketDetails!.data!.ticketInfo.isNotEmpty &&
    //     widget.ticketDetails!.data!.ticketInfo[0].paymentMethod == null) {
    //   bloc!.state.paymentIdStream.add(widget.respModel.data.paymentTypes.first.paymentTypeId);
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CheckOutBloc>(context);
    final payment = widget.ticketDetails?.data?.ticketInfo?[0].payment == '0.00' ? null : widget.ticketDetails!.data!.ticketInfo?[0].payment;
    // final ios = Platform.isIOS;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: widget.ticketDetails?.data?.ticketInfo?[0].payment == null
              ? Text(
                  'Payment Options',
                  style: GoogleFonts.openSans().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[800],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        ValueListenableBuilder(
          valueListenable: totalForDiscountCalculationNotifier,
          builder: (context, totalForDiscount, _) {
            return ValueListenableBuilder(
              valueListenable: vatValueBeforeDiscountNotifier,
              builder: (context, vat, _) {
                return ValueListenableBuilder(
                  valueListenable: subtTotalForDiscountCalculationNotifier,
                  builder: (context, subTotalForDiscount, _) {
                    // return widget.ticketDetails?.data?.ticketInfo[0].payment != null
                    return (payment != null && payment != '0.00') || widget.ticketDetails!.data!.ticketInfo?[0].paymentCalculatedOn != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Details',
                                style: GoogleFonts.openSans().copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.grey[800],
                                ),
                              ),
                              AmountDetails(
                                ticketNumber: widget.ticketNumber,
                                ticketDetails: widget.ticketDetails,
                                respModel: widget.respModel,
                                isPaymentPage: widget.isPaymentPage,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // spacing
                              const SizedBox(height: 10),

                              Container(
                                alignment: Alignment.bottomLeft,
                                // color: Colors.grey,
                                // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                height: 28,
                                width: MediaQuery.of(context).size.width / 4,
                                child: TabBar(
                                  padding: EdgeInsets.zero,
                                  controller: _tabController,
                                  enableFeedback: true,
                                  indicator: BoxDecoration(
                                    // color: Colors.purple[200],
                                    // color: const Color(0xff015174),
                                    // color: const Color.fromARGB(255, 92, 45, 153),
                                    color: const Color.fromARGB(255, 126, 65, 155),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey[700],
                                  isScrollable: true,
                                  // tabAlignment: TabAlignment.fill,
                                  dividerColor: Colors.transparent,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  onTap: (value) {
                                    // if (paymentTypes[value] != 'Cash') {
                                    //   totalForDiscountCalculationNotifier.value = '0.0';
                                    //   totalForDiscountCalculationNotifier.notifyListeners();
                                    // }

                                    // if (widget.ticketDetails != null &&
                                    //     widget.ticketDetails!.data != null &&
                                    //     widget.ticketDetails!.data!.ticketInfo.isNotEmpty &&
                                    //     widget.ticketDetails!.data!.ticketInfo[0].payment != null) {
                                    //   _tabController.index = 0;
                                    // } else {
                                    // }

                                    if (widget.ticketDetails != null &&
                                        widget.ticketDetails!.data != null &&
                                        widget.ticketDetails!.data!.ticketInfo != null &&
                                        widget.ticketDetails!.data!.ticketInfo!.isNotEmpty &&
                                        widget.ticketDetails!.data!.ticketInfo![0].payment != null) {
                                      final payMethodName =
                                          widget.respModel.data?.paymentTypes?.firstWhere((e) => e.paymentTypeId == widget.ticketDetails!.data!.ticketInfo?[0].paymentMethod).paymentTypeName;

                                      final index = paymentTypes.indexWhere((e) => e == payMethodName);
                                      _tabController.index = index;
                                    } else {
                                      final id = widget.respModel.data?.paymentTypes?.where((e) => e.paymentTypeName == paymentTypes[value]).first.paymentTypeId;
                                      // //print('pooooooooooooooooooooooo $id');
                                      bloc.state.paymentIdStream.add(id);
                                    }
                                  },
                                  tabs: <Widget>[
                                    // Tab(text: 'Cash'),
                                    // Tab(text: 'Stamped'),
                                    // Tab(text: 'Loyalty Card'),
                                    // Tab(text: 'Other'),
                                    ...List.generate(paymentTypes.length, (index) => Tab(text: paymentTypes[index])),
                                  ],
                                ),
                              ),

                              // Divider
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
                                child: Container(height: .5, color: Colors.grey[400]),
                              ),

                              //
                              SizedBox(
                                height: MediaQuery.of(context).size.height - 300,
                                // height: MediaQuery.of(context).size.height,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Cash
                                    SingleChildScrollView(
                                      child: DefaultTabController(
                                        length: cashSubTypes.length,
                                        child: Column(
                                          children: <Widget>[
                                            // spacing
                                            const SizedBox(height: 5),

                                            Container(
                                              alignment: Alignment.topLeft,
                                              height: 28,
                                              width: MediaQuery.of(context).size.width / 4,
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: TabBar(
                                                tabAlignment: TabAlignment.startOffset, // Important, if error happens, remove it
                                                indicator: BoxDecoration(
                                                  // color: Colors.purple[200],
                                                  // color: Colors.red[300],
                                                  // color: const Color.fromARGB(255, 88, 69, 197),
                                                  borderRadius: BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color:
                                                        // const Color.fromARGB(255, 92, 45, 153),
                                                        const Color.fromARGB(255, 126, 65, 155),
                                                  ),
                                                ),
                                                labelColor:
                                                    // const Color.fromARGB(207, 92, 45, 153),
                                                    const Color.fromARGB(255, 126, 65, 155),
                                                unselectedLabelColor: Colors.grey,
                                                // labelPadding: EdgeInsets.symmetric(
                                                //   horizontal: 5.w,
                                                // ),
                                                isScrollable: true,

                                                //  tabAlignment: TabAlignment.fill,
                                                dividerColor: Colors.transparent,
                                                indicatorSize: TabBarIndicatorSize.tab,
                                                tabs: [
                                                  // Text('Regular'),
                                                  // Text('VIP'),
                                                  // Text(
                                                  //   'CAR WASH 1',
                                                  //   textAlign: TextAlign.center,
                                                  // ),
                                                  // Text(
                                                  //   'CAR WASH 2',
                                                  //   textAlign: TextAlign.center,
                                                  // ),
                                                  ...List.generate(cashSubTypes.length, (index) => Tab(text: cashSubTypes[index].title)),
                                                ],
                                              ),
                                            ),

                                            // spacing
                                            const SizedBox(height: 5),

                                            SizedBox(
                                              height: MediaQuery.of(context).size.height - 300,
                                              child: TabBarView(
                                                // children: [
                                                //   // Regular
                                                //   // Container(color: Colors.red),
                                                //   AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),

                                                //   // VIP
                                                //   // Container(color: Colors.green),
                                                //   AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),

                                                //   // CAR WASH 1
                                                //   // Container(color: Colors.blue),
                                                //   AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),

                                                //   // CAR WASH 2
                                                //   // Container(color: Colors.grey),
                                                //   AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),
                                                // ],
                                                children: List.generate(
                                                  cashSubTypes.length,
                                                  (index) {
                                                    return AmountDetails(
                                                      ticketNumber: widget.ticketNumber,
                                                      ticketDetails: widget.ticketDetails,
                                                      respModel: widget.respModel,
                                                      paymentTypeName: widget.respModel.data?.paymentTypes?[index].paymentTypeName,
                                                      paymentSubTypeName: widget.respModel.data?.paymentTypes?[index].title,
                                                      isPaymentPage: widget.isPaymentPage,
                                                    );
                                                    // return Container();
                                                  },
                                                ),
                                              ),
                                            ),

                                            // SizedBox(height: 120,)
                                          ],
                                        ),
                                      ),
                                    ),

                                    // // Stamped
                                    // // Container(color: Colors.amber),
                                    // AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),

                                    // // Loyalty Card
                                    // // Container(color: Colors.purple),
                                    // AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),

                                    // // Other
                                    // // Container(color: Colors.pink),
                                    // AmountDetails(ticketNumber: ticketNumber, ticketDetails: ticketDetails, respModel: respModel),

                                    ...List.generate(
                                      paymentTypes.length,
                                      (index) {
                                        // print('333333333333333 ${paymentTypes}');
                                        if (paymentTypes[index] == 'Other') {
                                          return AmountDetails(
                                            ticketNumber: widget.ticketNumber,
                                            ticketDetails: widget.ticketDetails,
                                            respModel: widget.respModel,
                                            paymentTypeName: paymentTypes[index],
                                            paymentSubTypeName: paymentTypes[index],
                                            isPaymentPage: widget.isPaymentPage,
                                            isOtherPaySection: true,
                                          );
                                        }
                                        return AmountDetails(
                                          ticketNumber: widget.ticketNumber,
                                          ticketDetails: widget.ticketDetails,
                                          respModel: widget.respModel,
                                          paymentTypeName: paymentTypes[index],
                                          paymentSubTypeName: paymentTypes[index],
                                          isPaymentPage: widget.isPaymentPage,
                                        );
                                      },
                                    ).where((e) {
                                      if (e.paymentTypeName == 'Cash') {
                                        return false;
                                      }
                                      return true;
                                    }),
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
      ],
    );
  }
}
