// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:admin_panel/screens/actions/checkin/checkin_page.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMainButton extends StatefulWidget {
  const CustomMainButton({
    required this.title,
    // required this.result,
    // required this.color,
    // required this.isFeeCollectionAllowed,
    required this.bgColor,
    // this.status,
    this.icon,
    this.icon2,
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

  @override
  State<CustomMainButton> createState() => _CustomMainButtonState();
}

class _CustomMainButtonState extends State<CustomMainButton> {
  @override
  Widget build(BuildContext context) {
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
              // backgroundColor: bgColor(),
              backgroundColor: widget.bgColor,
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
            label: Text(widget.title, style: const TextStyle(fontSize: 17, color: Colors.white)),
          ),

          //
          // Positioned(
          //   right: 5,
          //   top: 4,
          //   child: Icon(doneIcon(), color: doneIconColor(), size: 22),
          // )
        ],
      ).ripple(context, () {
        if (widget.title == 'Parked') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckInScreen(),
              ));
        }
      }),
    );
  }
}
