// ignore_for_file: lines_longer_than_80_chars, use_build_context_synchronously

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionTopCard extends StatelessWidget {
  const ActionTopCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.isParkedPage = false,
    this.result,
    this.isExists = false,
    super.key,
  });
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final String? result;
  final bool isExists;
  final bool isParkedPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Card(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: const Color.fromARGB(255, 88, 69, 197),
        color: Colors.white,
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  // Image.asset(
                  //   'assets/images/location_logo1.png',
                  //   width: 50,
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: '*************',
                      style: const TextStyle(color: Colors.black,fontSize: 22,letterSpacing: 2),
                      width: 250,
                      height: 110,
                    ),
                  ),

                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(
                          'ARABINFOTEC-DEMO',
                          style: GoogleFonts.openSans().copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(
                        width: 530,
                        child: Text(
                          'Please Provide Barcode (length from 8 to 12) To Get Current Details',
                          style: TextStyle(fontSize: 15,color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}
