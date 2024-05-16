// ignore_for_file: lines_longer_than_80_chars

// import 'dart:io';

import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/screens/widgets/plate_number_board.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({
    required this.title,
    this.value,
    this.ticketInfo,
    this.haveStatus = false,
    this.isLarge = false,
    this.status = '',
    this.otherValue = false,
    this.otherValue2 = false,
    this.isValueBold = false,
    this.isActionPage = false,
    this.carColor,
    this.carBrand,
    super.key,
  });

  final String title;
  final String? value;
  final bool haveStatus;
  final String status;
  final bool isLarge;
  final bool otherValue;
  final bool otherValue2;
  final TicketInfo? ticketInfo;
  final String? carColor;
  final String? carBrand;
  final bool isValueBold;
  final bool isActionPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          if (!haveStatus)
            Container(
              width: isLarge ? 115 : 100,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: isActionPage ? 14 : 12,
                  fontWeight: isValueBold ? FontWeight.w900 : FontWeight.w500,
                ),
              ),
            )
          else
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  Container(
                    height: 20,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 106, 88, 211),
                      color: ticketInfo == null ? const Color.fromARGB(255, 106, 88, 211) : getTicketStatusColor(tickinfo: ticketInfo!),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      // status.length > 9 ? '${status.substring(0, 9)}...' : status,
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // SizedBox(width: 6),
                ],
              ),
            ),
          // SizedBox(width: 5),
          Padding(
            // padding: EdgeInsets.only(left: haveStatus ? 16 : 0),
            padding: EdgeInsets.only(left: haveStatus ? 0 : 0),
            child: Text(
              ':',
              style: TextStyle(
                color: Colors.black,
                fontSize: isActionPage ? 13 : 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 2),
          if (value != null && !otherValue)
            SizedBox(
              // width: 300,
              child: Text(
                value!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isActionPage ? 15 : 13,
                  fontWeight: isValueBold ? FontWeight.w900 : FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (value == null && otherValue) PlateNumberBoard(ticketInfo: ticketInfo),
          if (otherValue2)
            Row(
              children: [
                // Image.asset(
                //   'assets/images/audi.png',
                //   width: 40,
                // ),
                if (carBrand != null)
                  carBrand!.contains('-1')
                      // ? Image.asset(
                      //    'assets/images/no_car_logo.png',
                      //     width: 40,
                      //   )
                      // ? const SizedBox.shrink()
                      ? Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            ticketInfo?.carBrandName ?? '',
                            style: GoogleFonts.openSans().copyWith(
                              fontSize: isActionPage ? 11 : 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Image.network(
                          carBrand ?? '',
                          width: 40,
                        )
                else
                  const SizedBox(width: 8),
                if (carColor != null)
                  Container(
                    height: 13,
                    width: 13,
                    decoration: BoxDecoration(
                      // color: Color(int.parse('0xFF${carColorHexCode(colorName: 'red')?.substring(1)}')),
                      color: Color(
                        int.parse('0xFF${carColor?.substring(1)}'),
                      ),
                      // color: const Color(0xFF0000FF),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
        ],
      ),
    );
  }

  // Color getTicketStatusColor({
  //   required TicketInfo tickinfo,
  // }) {
  //   // final checkOutStatus = tickinfo.checkoutStatus;
  //   final checkOutStatus = status;
  //   print(checkOutStatus);
  //   if (checkOutStatus == 'N' && tickinfo.dataCheckinTime == null) {
  //     return Colors.green;
  //   } else if (checkOutStatus == 'N' && tickinfo.dataCheckinTime != null) {
  //     return Colors.orange;
  //   } else {
  //     switch (checkOutStatus) {
  //       // case 'N':
  //       //   return 'CheckIn';
  //       case 'Y':
  //         return Colors.red;
  //       case 'R':
  //         return Colors.blue.shade400;
  //       case 'O':
  //         return Colors.purple;
  //       // 'Collect Now' and 'Vehicle Arrived are same
  //       case 'C':
  //         return Colors.pink[400]!;
  //       default:
  //         return Colors.green;
  //     }
  //   }
  // }

  Color getTicketStatusColor({
    required TicketInfo tickinfo,
  }) {
    // final checkOutStatus = tickinfo.checkoutStatus;
    print(status);
    var checkOutStatus = 'N';

    if (status == 'CheckIn') {
      checkOutStatus = 'N';
    } else if (status == 'Parked') {
      checkOutStatus = 'P';
    } else if (status == 'Requested') {
      checkOutStatus = 'R';
    } else if (status == 'On The Way') {
      checkOutStatus = 'O';
    } else if (status == 'Vehicle Arrived') {
      checkOutStatus = 'C';
    } else if (status == 'Checkout') {
      checkOutStatus = 'Y';
    }

    if (checkOutStatus == 'N') {
      return Colors.green;
    } else if (checkOutStatus == 'P') {
      return Colors.orange;
    } else {
      switch (checkOutStatus) {
        // case 'N':
        //   return 'CheckIn';
        case 'Y':
          return Colors.red;
        case 'R':
          return Colors.blue.shade400;
        case 'O':
          return Colors.purple;
        // 'Collect Now' and 'Vehicle Arrived are same
        case 'C':
          return Colors.pink[400]!;
        default:
          return Colors.green;
      }
    }
  }
}
