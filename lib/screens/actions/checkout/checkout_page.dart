import 'package:admin_panel/responsive.dart';
import 'package:admin_panel/screens/actions/widgets/amount_details.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/main/components/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({
    super.key,
  });

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SideMenu(),
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
    return const Stack(
      children: [
        // Payment
        Padding(
          padding: const EdgeInsets.only(top: 120, left: 220, right: 220),
          // padding: EdgeInsets.only(top: 120, left: 50, right: 50),
          // padding: EdgeInsets.only(top: 120),
          child: PaymentOption(ticketNumber: '6565498796'),
        ),

        // Header
        Header(reqBackBtn: true),
      ],
    );
  }
}

class PaymentOption extends StatefulWidget {
  const PaymentOption({
    // required this.respModel,
    required this.ticketNumber,
    // this.ticketDetails,
    this.isPaymentPage = false,
    super.key,
  });

  // final AllCheckOutItemsResponse respModel;
  final String? ticketNumber;
  // final TicketDetailsResponseModel? ticketDetails;
  final bool isPaymentPage;

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> paymentTypes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = TabController(
      length: 4, // Number of tabs
      vsync: this,
      initialIndex: 0, // Initial tab index
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          //   child: widget.ticketDetails?.data?.ticketInfo?[0].payment == null
          //       ? Text(
          //           'Payment Options',
          //           style: AppStyles.openSans.copyWith(
          //             fontSize: 13,
          //             fontWeight: FontWeight.w900,
          //             color: Colors.grey[800],
          //           ),
          //         )
          //       : const SizedBox.shrink(),
          // ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // spacing
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // alignment: Alignment.bottomLeft,
                    // color: Colors.grey,
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: 28,
                    // width:MediaQuery.of(context).size.width / 4,
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
                      onTap: (value) {},
                      tabs: const <Widget>[
                        Tab(text: 'Cash'),
                        Tab(text: 'Stamped'),
                        Tab(text: 'Loyalty Card'),
                        Tab(text: 'Other'),
                        // ...List.generate(paymentTypes.length, (index) => Tab(text: paymentTypes[index])),
                      ],
                    ),
                  ),
                ],
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
                // height: MediaQuery.of(context).size.height - 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Cash
                    SingleChildScrollView(
                      child: DefaultTabController(
                        length: 4,
                        child: Column(
                          children: <Widget>[
                            // spacing
                            const SizedBox(height: 5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // alignment: Alignment.topLeft,
                                  height: 28,
                                  // width:MediaQuery.of(context).size.width / 4,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
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
                                    //   horizontal: 5,
                                    // ),
                                    isScrollable: true,

                                    //  tabAlignment: TabAlignment.fill,
                                    dividerColor: Colors.transparent,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: const [
                                      Text('Regular'),
                                      Text('VIP'),
                                      Text(
                                        'CAR WASH 1',
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'CAR WASH 2',
                                        textAlign: TextAlign.center,
                                      ),
                                      // ...List.generate(cashSubTypes.length, (index) => Tab(text: cashSubTypes[index].title)),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // spacing
                            const SizedBox(height: 5),

                            SizedBox(
                              // height: 565,
                              height: MediaQuery.of(context).size.height - 300,
                              child: const TabBarView(
                                children: [
                                  // Regular
                                  // Container(color: Colors.red),
                                  AmountDetails(ticketNumber: '54489464778'),

                                  // VIP
                                  // Container(color: Colors.green),
                                  AmountDetails(ticketNumber: '54489464778'),

                                  // CAR WASH 1
                                  // Container(color: Colors.blue),
                                  AmountDetails(ticketNumber: '54489464778'),

                                  // CAR WASH 2
                                  // Container(color: Colors.grey),
                                  AmountDetails(ticketNumber: '54489464778'),
                                ],
                              ),
                            ),

                            // SizedBox(height: 120,)
                          ],
                        ),
                      ),
                    ),

                    // Stamped
                    // Container(color: Colors.amber),
                    const AmountDetails(ticketNumber: '58711694649'),

                    // Loyalty Card
                    // Container(color: Colors.purple),
                    const AmountDetails(ticketNumber: '58711694649'),

                    // Other
                    // Container(color: Colors.pink),
                    const AmountDetails(ticketNumber: '58711694649'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
