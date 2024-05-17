
import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/check_out/check_out_bloc.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/actions/payment/widgets/payment_option.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({this.ticketNumber, this.id, super.key});

  final String? ticketNumber;
  final int? id;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
  // }

  CheckOutBloc? bloc;
  ActionsBloc? actionBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc ??= Provider.of<CheckOutBloc>(context);
    actionBloc ??= Provider.of<ActionsBloc>(context);
    bloc!.getTicketDetails(ticketNumber: widget.ticketNumber ?? '');
    actionBloc!.getAllCheckOutItems(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const SideMenu(),
        body: Row(
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
              child: _Body(id: widget.id, tickNum: widget.ticketNumber),
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
    this.id,
    this.tickNum,
  });

  final int? id;
  final String? tickNum;

  @override
  Widget build(BuildContext context) {
    final actionsBloc = Provider.of<ActionsBloc>(context);
    final checkOutBloc = Provider.of<CheckOutBloc>(context);
    return Stack(
      children: [
        // Payment
        StreamBuilder(
            stream: actionsBloc.getAllCheckOutItemsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 35), const Text('Please Wait ...', style: TextStyle(fontSize: 16))],
                  ),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                Loader.hide();
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Something went wrong.Please Refresh', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                        decoration: BoxDecoration(border: Border.all(color: Colors.purple[100]!), borderRadius: BorderRadius.circular(15)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.refresh, size: 17), SizedBox(width: 5), Text('Refresh', style: TextStyle(fontSize: 15))],
                        ),
                      ).ripple(
                        context,
                        () async {
                          await actionsBloc.getAllCheckOutItems(id: id);
                        },
                        borderRadius: BorderRadius.circular(15),
                        overlayColor: Colors.purple.withOpacity(.15),
                      ),
                    ],
                  ),
                );
              } else {
                final respModel = snapshot.data;

                return StreamBuilder(
                  stream: checkOutBloc.ticketDetailsResponse,
                  builder: (context, snapshot) {
                    TicketDetailsResponseModel? details;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // return const CircularProgressIndicator();
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 35),
                              const Text('Please Wait ...', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    }
                    details = snapshot.data;
                    return Padding(
                        padding: const EdgeInsets.only(top: 120, left: 220, right: 220),
                        // padding: EdgeInsets.only(top: 120, left: 50, right: 50),
                        // padding: EdgeInsets.only(top: 120),
                        // child: PaymentOption(ticketNumber: '6565498796'),
                        child: PaymentOption(ticketNumber: tickNum, respModel: respModel!, ticketDetails: details, isPaymentPage: true));
                  },
                );
              }
            }),

        // Header
        const Header(reqBackBtn: true),
      ],
    );
  }
}
