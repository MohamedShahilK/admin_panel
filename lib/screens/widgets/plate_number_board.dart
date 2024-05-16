// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/models/new/all_checkin/all_checkin_response_model.dart';
import 'package:admin_panel/models/new/all_checkout/all_checkout_response_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/dashboard/dashboard_resp_model.dart';
import 'package:admin_panel/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlateNumberBoard extends StatelessWidget {
  const PlateNumberBoard({
    this.isLarge = false,
    this.ticketInfo,
    this.item,
    this.item2,
    this.item3,
    this.item4,
    super.key,
  });

  final bool isLarge;
  final TicketInfo? ticketInfo;
  final ActiveTickets? item;
  final TicketsList? item2;
  final CheckinList? item3;
  final CheckOutList? item4;

  @override
  Widget build(BuildContext context) {
    // //print('22222222222222 ${item?.emiratesName ?? 'none'}');

    // For Ipad
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final largeDev = (screenHeight > 1100) && (screenWidth > 800);
    // For Ipad

    return Container(
      // height: 45,
      height: largeDev ? 45 : 35,
      width: isLarge ? 120 : 100,
      // width: isLarge ? 110.w : 100,
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: Colors.grey, width: .5),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        // vertical: 2,
      ),
      child: (item != null && item!.dataCheckinTime != null && ((item!.vehicleNumber != null && item!.vehicleNumber != '') || (item!.emiratesName != null && item!.emiratesName != ''))) ||
              (ticketInfo != null && ticketInfo!.dataCheckinTime != null && ((ticketInfo!.vehicleNumber != null && ticketInfo!.vehicleNumber != '') || (ticketInfo!.emiratesName != null && ticketInfo!.emiratesName != ''))) ||
              (item2 != null && item2!.dataCheckinTime != null&& ((item2!.vehicleNumber != null && item2!.vehicleNumber != '') || (item2!.emiratesName != null && item2!.emiratesName != ''))) ||
              (item3 != null && item3!.dataCheckinTime != null && ((item3!.vehicleNumber != null && item3!.vehicleNumber != '') || (item3!.emiratesName != null && item3!.emiratesName != ''))) ||
              (item4 != null && item4!.dataCheckinTime != null && ((item4!.vehicleNumber != null && item4!.vehicleNumber != '') || (item4!.emiratesName != null && item4!.emiratesName != '')))
          // child: (item != null && item!.dataCheckinTime != null) ||
          //       (ticketInfo != null && ticketInfo!.dataCheckinTime != null ) ||
          //       (item2 != null && item2!.dataCheckinTime != null ) ||
          //       (item3 != null && item3!.dataCheckinTime != null) ||
          //       (item4 != null && item4!.dataCheckinTime != null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // ticketInfo == null
                      //     ? (item != null && item!.emiratesName != null ? (item!.emiratesName!.length > 10 ? item!.emiratesName!.substring(0, 9) : item!.emiratesName!) : 'none')
                      //     : (ticketInfo!.emiratesName != null
                      //         ? (ticketInfo!.emiratesName!.length > 10 ? ticketInfo!.emiratesName!.substring(0, 9) : ticketInfo!.emiratesName!)
                      //         : 'none'),
                      // ticketInfo == null
                      //     ? (item != null && item!.emiratesName != null
                      //         ? (item!.emiratesName!.length > 10 ? item!.emiratesName!.substring(0, 9) : item!.emiratesName!)
                      //         : item2 != null && item2!.emiratesName != null
                      //             ? (item2!.emiratesName!.length > 10 ? item2!.emiratesName!.substring(0, 9) : item2!.emiratesName!)
                      //             : 'none')
                      //     : (ticketInfo!.emiratesName != null
                      //         ? (ticketInfo!.emiratesName!.length > 10 ? ticketInfo!.emiratesName!.substring(0, 9) : ticketInfo!.emiratesName!)
                      //         : 'none'),
                      ticketInfo == null
                          ? (item != null && item!.emiratesName != null
                              ? (item!.emiratesName!.length > 10 ? item!.emiratesName!.substring(0, 9) : item!.emiratesName!)
                              : item2 != null && item2!.emiratesName != null
                                  ? (item2!.emiratesName!.length > 10 ? item2!.emiratesName!.substring(0, 9) : item2!.emiratesName!)
                                  : item3 != null && item3!.emiratesName != null
                                      ? (item3!.emiratesName!.length > 10 ? item3!.emiratesName!.substring(0, 9) : item3!.emiratesName!)
                                      : item4 != null && item4!.emiratesName != null
                                          ? (item4!.emiratesName!.length > 10 ? item4!.emiratesName!.substring(0, 9) : item4!.emiratesName!)
                                          : '')
                          : (ticketInfo!.emiratesName != null ? (ticketInfo!.emiratesName!.length > 10 ? ticketInfo!.emiratesName!.substring(0, 9) : ticketInfo!.emiratesName!) : ''),

                      style: GoogleFonts.dosis(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      // ticketInfo == null
                      //     ? (item != null && item!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item!.vehicleNumber!) != ''
                      //         ? UtilityFunctions.extractAlphabets(item!.vehicleNumber!)
                      //         : 'none')
                      //     : (ticketInfo!.vehicleNumber != null && UtilityFunctions.extractAlphabets(ticketInfo!.vehicleNumber!) != ''
                      //         ? UtilityFunctions.extractAlphabets(ticketInfo!.vehicleNumber!)
                      //         : 'none'),
                      // ticketInfo == null
                      //     ? (item != null && item!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item!.vehicleNumber!) != ''
                      //         ? UtilityFunctions.extractAlphabets(item!.vehicleNumber!)
                      //         : item2 != null && item2!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item2!.vehicleNumber!) != ''
                      //             ? UtilityFunctions.extractAlphabets(item2!.vehicleNumber!)
                      //             : 'none')
                      //     : (ticketInfo!.vehicleNumber != null && UtilityFunctions.extractAlphabets(ticketInfo!.vehicleNumber!) != ''
                      //         ? UtilityFunctions.extractAlphabets(ticketInfo!.vehicleNumber!)
                      //         : 'none'),
                      ticketInfo == null
                          ? (item != null && item!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item!.vehicleNumber!) != ''
                              ? UtilityFunctions.extractAlphabets(item!.vehicleNumber!)
                              : item2 != null && item2!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item2!.vehicleNumber!) != ''
                                  ? UtilityFunctions.extractAlphabets(item2!.vehicleNumber!)
                                  : item3 != null && item3!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item3!.vehicleNumber!) != ''
                                      ? UtilityFunctions.extractAlphabets(item3!.vehicleNumber!)
                                      : item4 != null && item4!.vehicleNumber != null && UtilityFunctions.extractAlphabets(item4!.vehicleNumber!) != ''
                                          ? UtilityFunctions.extractAlphabets(item4!.vehicleNumber!)
                                          : '')
                          : (ticketInfo!.vehicleNumber != null && UtilityFunctions.extractAlphabets(ticketInfo!.vehicleNumber!) != ''
                              ? UtilityFunctions.extractAlphabets(ticketInfo!.vehicleNumber!)
                              : ''),
                      style: GoogleFonts.dosis(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                // SizedBox(width: 30.w),
                Text(
                  // '13515',
                  // ticketInfo == null ? 'none' : UtilityFunctions.extractNumbers(ticketInfo!.vehicleNumber!),
                  // ticketInfo == null
                  //     ? (item != null && item!.vehicleNumber != null && UtilityFunctions.extractNumbers(item!.vehicleNumber!) != ''
                  //         ? UtilityFunctions.extractNumbers(item!.vehicleNumber!)
                  //         : item2 != null && item2!.vehicleNumber != null && UtilityFunctions.extractNumbers(item2!.vehicleNumber!) != ''
                  //             ? UtilityFunctions.extractNumbers(item2!.vehicleNumber!)
                  //             : 'none')
                  //     : (ticketInfo!.vehicleNumber != null && UtilityFunctions.extractNumbers(ticketInfo!.vehicleNumber!) != ''
                  //         ? UtilityFunctions.extractNumbers(ticketInfo!.vehicleNumber!)
                  //         : 'none'),
                  ticketInfo == null
                      ? (item != null && item!.vehicleNumber != null && UtilityFunctions.extractNumbers(item!.vehicleNumber!) != ''
                          ? UtilityFunctions.extractNumbers(item!.vehicleNumber!)
                          : item2 != null && item2!.vehicleNumber != null && UtilityFunctions.extractNumbers(item2!.vehicleNumber!) != ''
                              ? UtilityFunctions.extractNumbers(item2!.vehicleNumber!)
                              : item3 != null && item3!.vehicleNumber != null && UtilityFunctions.extractNumbers(item3!.vehicleNumber!) != ''
                                  ? UtilityFunctions.extractNumbers(item3!.vehicleNumber!)
                                  : item4 != null && item4!.vehicleNumber != null && UtilityFunctions.extractNumbers(item4!.vehicleNumber!) != ''
                                      ? UtilityFunctions.extractNumbers(item4!.vehicleNumber!)
                                      : '')
                      : (ticketInfo!.vehicleNumber != null && UtilityFunctions.extractNumbers(ticketInfo!.vehicleNumber!) != ''
                          ? UtilityFunctions.extractNumbers(ticketInfo!.vehicleNumber!)
                          : ''),
                  style: GoogleFonts.dosis(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'N/A',
                style: TextStyle(fontSize: 12),
              ),
            ),
    );
  }
}
