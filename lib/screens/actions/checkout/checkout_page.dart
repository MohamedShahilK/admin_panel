import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/check_out/check_out_bloc.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/actions/payment/widgets/payment_option.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key, this.id, this.ticketNumber, this.isAllCheckin = false});

  final String? ticketNumber;
  final bool isAllCheckin;
  final int? id;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
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
    final bloc = Provider.of<CheckOutBloc>(context);    
    final state = bloc.state;
    state.barcodeStream.add(widget.ticketNumber ?? '');
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
              child: _Body(tickNum: widget.ticketNumber),
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
    this.tickNum,
  });

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
              // //////print(snapshot.hasData);
              // print('asdasdasdasdasda ${snapshot.data}');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 35),
                      const Text('Please Wait ...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                Loader.hide();
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Something went wrong', style: TextStyle(fontSize: 16)),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.prograssiveDots(color: Colors.purple, size: 35),
                              const Text('Please Wait ...', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }
                      details = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.only(top: 120, left: 220, right: 220),
                        // padding: EdgeInsets.only(top: 120, left: 50, right: 50),
                        // padding: EdgeInsets.only(top: 120),
                        child: PaymentOption(respModel: respModel!, ticketNumber: tickNum, ticketDetails: details),
                      );
                    });
              }
            }),

        // Header
        const Header(reqBackBtn: true),
      ],
    );
  }
}
