import 'package:admin_panel/screens/actions/checkin/custom_action_textfield.dart';
import 'package:admin_panel/screens/actions/widgets/action_top_card.dart';
import 'package:admin_panel/screens/actions/widgets/custom_main_button.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({
    super.key,
  });

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          //
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 160, right: 160),
            child: SingleChildScrollView(
              child: Column(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Wrap(
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      // padding: const EdgeInsets.symmetric( vertical: 30),
                      // shrinkWrap: true,
                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 100),
                      spacing: 15,
                      runSpacing: 5,
                      children:  [
                        CustomMainButton(title: 'CheckIn', bgColor: Colors.green[600]!, icon2: 'assets/icons/key_exchange.svg'),
                        CustomMainButton(title: 'Parked', bgColor: Colors.orange[600]!, icon: Icons.local_parking_rounded),
                        CustomMainButton(title: 'Requested', bgColor: Colors.blue[600]!, icon: FontAwesomeIcons.registered),
                        CustomMainButton(title: 'On The Way', bgColor: Colors.purple[600]!, icon: FontAwesomeIcons.route),
                        CustomMainButton(title: 'Vehivle Arrived', bgColor: Colors.pink[600]!, icon2: 'assets/icons/checkin.svg'),
                        CustomMainButton(title: 'Payment', bgColor: Colors.tealAccent[700]!, icon: FontAwesomeIcons.moneyBillTransfer),
                        CustomMainButton(title: 'CheckOut', bgColor: Colors.red[600]!, icon: FontAwesomeIcons.caravan),
                        CustomMainButton(title: 'Outlet Validator', bgColor: Colors.grey[600]!, icon: FontAwesomeIcons.barcode),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Header
          const Header(),
        ],
      ),
    );
  }
}
