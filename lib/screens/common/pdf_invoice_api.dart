// // ignore_for_file: cascade_invocations, lines_longer_than_80_chars

// import 'dart:io';

// // import 'package:cr_file_saver/file_saver.dart';
// // import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:valet_parking/models/print/printing_header_model.dart';
// import 'package:valet_parking/utils/internal_services/storage_services.dart';

// class PdfInvoiceApi {
//   static Future<File?> generate({
//     required PrintingHeadingModel? printingModel,
//     required bool isCheckout,
//     required String ticketId,
//     required String barcode,
//     required String slNo,
//     required String checkInDate,
//     required String checkInTime,
//     required String checkoutDate,
//     required String checkoutTime,
//     required String duration,
//     required String amount,
//     required double vatAmount,
//     required double vatPercentage,
//     required String netAmount,
//     required String carBrand,
//     required String carColor,
//     required String country,
//     required String vehicleNumber,
//     String discount = '0',
//   }) async {
//     final userType = StorageServices.to.getString('userType');
//     var myTheme = pw.ThemeData.withFont(
//       base: Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf')),
//       bold: Font.ttf(await rootBundle.load('assets/OpenSans-Bold.ttf')),
//       italic: Font.ttf(await rootBundle.load('assets/OpenSans-Italic.ttf')),
//       boldItalic: Font.ttf(await rootBundle.load('assets/OpenSans-BoldItalic.ttf')),
//     );
//     final pdf = pw.Document(theme: myTheme);

//     // final barcodeImage = (await rootBundle.load('assets/images/barcode.jpg')).buffer.asUint8List();

//     pdf.addPage(
//       Page(
//         pageFormat: PdfPageFormat.roll80,
//         build: (context) => pw.Center(
//           child: pw.Padding(
//             // padding: EdgeInsets.symmetric(horizontal: 12.w),
//             padding: EdgeInsets.symmetric(horizontal: 0.w),
//             child: pw.Column(
//               // crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.SizedBox(width: 1 * PdfPageFormat.mm),
//                 pw.Column(
//                   // mainAxisSize: pw.MainAxisSize.min,
//                   // crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   // mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text(
//                       // 'VALET PARKING SERVICE',
//                       printingModel?.data?.printSettings?.printsettingsHeader ?? '',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 11,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       // 'HOTEL-ARABINFOTECH',
//                       printingModel?.data?.printSettings?.printsettingsTitle1 ?? '', 
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 1 * PdfPageFormat.mm),

//                 pw.Text(
//                   // 'Business Bay, Dubai',
//                   printingModel?.data?.printSettings?.printsettingsTitle2 ?? '',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 9,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                 pw.Text(
//                   // 'TRN : 100279842665225',
//                   printingModel?.data?.printSettings?.printsettingsTrnNo ?? '',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 9,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                 // pw.Image(pw.MemoryImage(barcodeImage),width: 120.w),

//                 BarcodeWidget(
//                   // barcode: Barcode.code93(),
//                   barcode: Barcode.code128(),
//                   // data: tickinfo[0].barcode!.split('').join(' '),
//                   data: barcode,
//                   textStyle: TextStyle(fontSize: 1.w),
//                   width: 100.w,
//                   height: 40.h,
//                 ),

//                 // pw.BarcodeWidget(
//                 //   // color: PdfColor.fromHex('#000000'),
//                 //   barcode: pw.Barcode.qrCode(),
//                 //   data: barcode,
//                 // ),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),

//                 // Contents
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       'Ticket No. : $barcode',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       'Serial No. : $slNo',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       'CheckIn Date : $checkInDate',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       'CheckIn Time : $checkInTime',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (country != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Country : $country',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     if (vehicleNumber != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Vehicle Number : $vehicleNumber',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     if (carBrand != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Car Brand : $carBrand',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     if (carColor != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Car Color : $carColor',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     if (isCheckout)
//                       pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             'Delivery Date : $checkoutDate',
//                             style: const TextStyle(
//                               fontSize: 9,
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                           pw.Text(
//                             'Delivery Time : $checkoutTime',
//                             style: const TextStyle(
//                               fontSize: 9,
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                           pw.Text(
//                             'Duration : $duration',
//                             style: const TextStyle(
//                               fontSize: 9,
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                         ],
//                       ),
//                     if (amount != '' && amount != '0') ...[
//                       pw.Text(
//                         'Amount : $amount',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       if (vatAmount > 0.00)
//                         pw.Text(
//                           'VAT Amount ($vatPercentage% ) : $vatAmount',
//                           style: const TextStyle(
//                             fontSize: 9,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       if (discount != '' && discount != '0.0')
//                         pw.Text(
//                           'Discount $discount',
//                           style: const TextStyle(
//                             fontSize: 9,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Net Amount : $netAmount',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     ],
//                   ],
//                 ),
//                 pw.Column(
//                   // crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.SizedBox(height: 2 * PdfPageFormat.mm),
//                     pw.Text(
//                       'Thank You',
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 2 * PdfPageFormat.mm),
//                     pw.Text(
//                       '© ${DateTime.now().year} Powered by: Arabinfotech',
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 2 * PdfPageFormat.mm),

//                 // pw.Text(
//                 //   'Request Check Out',
//                 //   style: const pw.TextStyle(
//                 //     fontSize: 9,
//                 //     decoration: TextDecoration.underline,
//                 //     decorationColor: PdfColors.blue,
//                 //     color: PdfColors.blue700,
//                 //   ),
//                 // ),

//                 // pw.UrlLink(
//                 //   child: pw.Text('Click here to visit Google'),
//                 //   destination: 'https://www.google.com',
//                 // ),

//                 if (!['A', 'ADMIN'].contains(userType))
//                   pw.UrlLink(
//                     child: pw.Text(
//                       'Request Checkout',
//                       style: TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                         color: PdfColors.blue700,
//                         decorationColor: PdfColors.blue700,
//                       ),
//                     ),
//                     destination: '${StorageServices.to.getString('companyUrl')}/${StorageServices.to.getInt('locationId')}_$ticketId.html',
//                   ),
//                 if (!['A', 'ADMIN'].contains(userType))
//                   pw.Text(
//                     '(Please Use Pdf Reader like Adobe Acrobat, WPS)',
//                     style: TextStyle(
//                       fontSize: 7,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     // pdf.addPage(
//     //   pw.MultiPage(
//     //     build: (context) {
//     //       return [
//     //         pw.SizedBox(width: 1 * PdfPageFormat.mm),
//     //         pw.Column(
//     //           mainAxisSize: pw.MainAxisSize.min,
//     //           crossAxisAlignment: pw.CrossAxisAlignment.start,
//     //           children: [
//     //             pw.Text(
//     //               // 'VALET PARKING SERVICE',
//     //               printingModel?.data?.printSettings?.printsettingsHeader ?? '',
//     //               style: TextStyle(
//     //                 fontWeight: FontWeight.bold,
//     //                 fontSize: 20,
//     //               ),
//     //             ),
//     //             pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //             pw.Text(
//     //               // 'HOTEL-ARABINFOTECH',
//     //               printingModel?.data?.printSettings?.printsettingsTitle1 ?? '',
//     //               style: TextStyle(
//     //                 fontWeight: FontWeight.bold,
//     //                 fontSize: 20.h,
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //         pw.SizedBox(height: 4 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           // 'Business Bay, Dubai',
//     //           printingModel?.data?.printSettings?.printsettingsTitle2 ?? '',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           // 'TRN : 100279842665225',
//     //           printingModel?.data?.printSettings?.printsettingsTrnNo ?? '',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 8 * PdfPageFormat.mm),
//     //         // pw.Image(pw.MemoryImage(barcodeImage)),
//     //         pw.BarcodeWidget(
//     //           color: PdfColor.fromHex('#000000'),
//     //           barcode: pw.Barcode.qrCode(),
//     //           data: barcode,
//     //         ),
//     //         pw.SizedBox(height: 8 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           'Ticket No. : $barcode',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           'Sl. No. : $slNo',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           'CheckIn Date : $checkInDate',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         Text(
//     //           'CheckIn Time : $checkInTime',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         if (isCheckout)
//     //           pw.Column(
//     //             children: [
//     //               pw.Text(
//     //                 'Delivery Date : $checkoutDate',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Delivery Time : $checkoutTime',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Duration : $duration',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Amount : $amount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'VAT Amount ($vatPercentage% ) : $vatAmount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Discount $discount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Net Amount : $netAmount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //             ],
//     //           ),
//     //         pw.Text(
//     //           'Thank You',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           '© 2019 Powered by: Arabinfotech',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //       ];
//     //     },
//     //   ),
//     // );

//     // PermissionStatus status;

//     // final deviceInfo = await DeviceInfoPlugin().androidInfo;

//     // if (deviceInfo.version.sdkInt <= 30) {
//     //   status = await Permission.storage.request();
//     // } else {
//     //   status = await Permission.manageExternalStorage.request();
//     // }

//     final status = await Permission.storage.request();

//     final folder = await getTemporaryDirectory();
//     folder.listSync();
//     // final filePath = '${folder.path}/invoice_$barcode.pdf';
//     final filePath = '${folder.path}/varlet_parking_ticket_$barcode.pdf';
//     // try {
//     //   final file = await CRFileSaver.saveFile(
//     //     filePath,
//     //     destinationFileName: 'TestFile.pdf',
//     //   );
//     //   log('Saved to $file');
//     // } on PlatformException catch (e) {
//     //   log('file saving error: ${e.code}');
//     // }

//     final bytes = await pdf.save();
//     final file = File(filePath);
//     await file.writeAsBytes(bytes);

//     return file;

//     // if (status.isGranted) {
//     //   // Access the file here
//     // return FileHandleApi.saveDocument(name: 'invoice_$barcode.pdf', pdf: pdf);
//     // } else {
//     //   await openAppSettings();
//     //   return null;
//     // }
//   }
//   //
//   //

//   static Future<Document?> generateWithoutSave({
//     required PrintingHeadingModel? printingModel,
//     required String ticketId,
//     required bool isCheckout,
//     required String barcode,
//     required String slNo,
//     required String checkInDate,
//     required String checkInTime,
//     required String checkoutDate,
//     required String checkoutTime,
//     required String duration,
//     required String amount,
//     required double vatAmount,
//     required double vatPercentage,
//     required String netAmount,
//     required String carBrand,
//     required String carColor,
//     required String country,
//     required String vehicleNumber,
//     String discount = '0',
//   }) async {
//     final userType = StorageServices.to.getString('userType');
//     var myTheme = pw.ThemeData.withFont(
//       base: Font.ttf(await rootBundle.load('assets/OpenSans-Regular.ttf')),
//       bold: Font.ttf(await rootBundle.load('assets/OpenSans-Bold.ttf')),
//       italic: Font.ttf(await rootBundle.load('assets/OpenSans-Italic.ttf')),
//       boldItalic: Font.ttf(await rootBundle.load('assets/OpenSans-BoldItalic.ttf')),
//     );
//     final pdf = pw.Document(theme: myTheme);

//     // final barcodeImage = (await rootBundle.load('assets/images/barcode.jpg')).buffer.asUint8List();

//     pdf.addPage(
//       Page(
//         pageFormat: PdfPageFormat.roll80,
//         build: (context) => pw.Center(
//           child: pw.Padding(
//             // padding: EdgeInsets.symmetric(horizontal: 12.w),
//             padding: EdgeInsets.symmetric(horizontal: 0.w),
//             child: pw.Column(
//               // crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.SizedBox(width: 1 * PdfPageFormat.mm),
//                 pw.Column(
//                   // mainAxisSize: pw.MainAxisSize.min,
//                   // crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   // mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text(
//                       // 'VALET PARKING SERVICE',
//                       printingModel?.data?.printSettings?.printsettingsHeader ?? '',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 11,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       // 'HOTEL-ARABINFOTECH',
//                       printingModel?.data?.printSettings?.printsettingsTitle1 ?? '',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 1 * PdfPageFormat.mm),

//                 pw.Text(
//                   // 'Business Bay, Dubai',
//                   printingModel?.data?.printSettings?.printsettingsTitle2 ?? '',
//                   style: const TextStyle(
//                     fontSize: 9,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                 pw.Text(
//                   // 'TRN : 100279842665225',
//                   printingModel?.data?.printSettings?.printsettingsTrnNo ?? '',
//                   style: TextStyle(
//                     fontSize: 9,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                 // pw.Image(pw.MemoryImage(barcodeImage),width: 120.w),

//                 BarcodeWidget(
//                   barcode: Barcode.code93(),
//                   // data: tickinfo[0].barcode!.split('').join(' '),
//                   data: barcode,
//                   textStyle: TextStyle(fontSize: 1.w),
//                   width: 100.w,
//                   height: 40.h,
//                 ),

//                 // pw.BarcodeWidget(
//                 //   // color: PdfColor.fromHex('#000000'),
//                 //   barcode: pw.Barcode.qrCode(),
//                 //   data: barcode,
//                 // ),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),

//                 // Contents
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       'Ticket No. : $barcode',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       'Serial No. : $slNo',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       'CheckIn Date : $checkInDate',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     pw.Text(
//                       'CheckIn Time : $checkInTime',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (country != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Country : $country',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     if (vehicleNumber != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Vehicle Number : $vehicleNumber',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     if (carBrand != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Car Brand : $carBrand',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     if (carColor != '') ...[
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Car Color : $carColor',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                     pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     if (isCheckout)
//                       pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                             'Delivery Date : $checkoutDate',
//                             style: const TextStyle(
//                               fontSize: 9,
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                           pw.Text(
//                             'Delivery Time : $checkoutTime',
//                             style: const TextStyle(
//                               fontSize: 9,
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                           pw.Text(
//                             'Duration : $duration',
//                             style: const TextStyle(
//                               fontSize: 9,
//                               // fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                         ],
//                       ),
//                     if (amount != '' && amount != '0') ...[
//                       pw.Text(
//                         'Amount : $amount',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       if (vatAmount > 0.00)
//                         pw.Text(
//                           'VAT Amount ($vatPercentage% ) : $vatAmount',
//                           style: const TextStyle(
//                             fontSize: 9,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       if (discount != '' && discount != '0.0')
//                         pw.Text(
//                           'Discount $discount',
//                           style: const TextStyle(
//                             fontSize: 9,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                       pw.Text(
//                         'Net Amount : $netAmount',
//                         style: const TextStyle(
//                           fontSize: 9,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 1 * PdfPageFormat.mm),
//                     ],
//                   ],
//                 ),
//                 pw.Column(
//                   // crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.SizedBox(height: 2 * PdfPageFormat.mm),
//                     pw.Text(
//                       'Thank You',
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 2 * PdfPageFormat.mm),
//                     pw.Text(
//                       '© ${DateTime.now().year} Powered by: Arabinfotech',
//                       style: TextStyle(
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 2 * PdfPageFormat.mm),

//                 // pw.Text(
//                 //   'Request Check Out',
//                 //   style: const pw.TextStyle(
//                 //     fontSize: 9,
//                 //     decoration: TextDecoration.underline,
//                 //     decorationColor: PdfColors.blue,
//                 //     color: PdfColors.blue700,
//                 //   ),
//                 // ),

//                 if (!['A', 'ADMIN'].contains(userType))
//                   pw.UrlLink(
//                     child: pw.Text(
//                       'Request Checkout',
//                       style: TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                         color: PdfColors.blue700,
//                         decorationColor: PdfColors.blue700,
//                       ),
//                     ),
//                     destination: '${StorageServices.to.getString('companyUrl')}/${StorageServices.to.getInt('locationId')}_$ticketId.html',
//                   ),
//                 if (!['A', 'ADMIN'].contains(userType))
//                   pw.Text(
//                     '(Please Use Pdf Reader like Adobe Acrobat, WPS)',
//                     style: TextStyle(
//                       fontSize: 7,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     return pdf;

//     // pdf.addPage(
//     //   pw.MultiPage(
//     //     build: (context) {
//     //       return [
//     //         pw.SizedBox(width: 1 * PdfPageFormat.mm),
//     //         pw.Column(
//     //           mainAxisSize: pw.MainAxisSize.min,
//     //           crossAxisAlignment: pw.CrossAxisAlignment.start,
//     //           children: [
//     //             pw.Text(
//     //               // 'VALET PARKING SERVICE',
//     //               printingModel?.data?.printSettings?.printsettingsHeader ?? '',
//     //               style: TextStyle(
//     //                 fontWeight: FontWeight.bold,
//     //                 fontSize: 20,
//     //               ),
//     //             ),
//     //             pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //             pw.Text(
//     //               // 'HOTEL-ARABINFOTECH',
//     //               printingModel?.data?.printSettings?.printsettingsTitle1 ?? '',
//     //               style: TextStyle(
//     //                 fontWeight: FontWeight.bold,
//     //                 fontSize: 20.h,
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //         pw.SizedBox(height: 4 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           // 'Business Bay, Dubai',
//     //           printingModel?.data?.printSettings?.printsettingsTitle2 ?? '',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           // 'TRN : 100279842665225',
//     //           printingModel?.data?.printSettings?.printsettingsTrnNo ?? '',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 8 * PdfPageFormat.mm),
//     //         // pw.Image(pw.MemoryImage(barcodeImage)),
//     //         pw.BarcodeWidget(
//     //           color: PdfColor.fromHex('#000000'),
//     //           barcode: pw.Barcode.qrCode(),
//     //           data: barcode,
//     //         ),
//     //         pw.SizedBox(height: 8 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           'Ticket No. : $barcode',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           'Sl. No. : $slNo',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           'CheckIn Date : $checkInDate',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         Text(
//     //           'CheckIn Time : $checkInTime',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         if (isCheckout)
//     //           pw.Column(
//     //             children: [
//     //               pw.Text(
//     //                 'Delivery Date : $checkoutDate',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Delivery Time : $checkoutTime',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Duration : $duration',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Amount : $amount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'VAT Amount ($vatPercentage% ) : $vatAmount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Discount $discount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //               Text(
//     //                 'Net Amount : $netAmount',
//     //                 style: TextStyle(
//     //                   fontSize: 19.h,
//     //                   // fontWeight: FontWeight.bold,
//     //                 ),
//     //               ),
//     //               pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //             ],
//     //           ),
//     //         pw.Text(
//     //           'Thank You',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //         pw.Text(
//     //           '© 2019 Powered by: Arabinfotech',
//     //           style: TextStyle(
//     //             fontSize: 19.h,
//     //             // fontWeight: FontWeight.bold,
//     //           ),
//     //         ),
//     //         pw.SizedBox(height: 2 * PdfPageFormat.mm),
//     //       ];
//     //     },
//     //   ),
//     // );

//     // PermissionStatus status;

//     // final deviceInfo = await DeviceInfoPlugin().androidInfo;

//     // if (deviceInfo.version.sdkInt <= 30) {
//     //   status = await Permission.storage.request();
//     // } else {
//     //   status = await Permission.manageExternalStorage.request();
//     // }

//     // final status = await Permission.storage.request();

//     // final folder = await getTemporaryDirectory();
//     // folder.listSync();
//     // // final filePath = '${folder.path}/invoice_$barcode.pdf';
//     // final filePath = '${folder.path}/varlet_parking_ticket_$barcode.pdf';
//     // // try {
//     // //   final file = await CRFileSaver.saveFile(
//     // //     filePath,
//     // //     destinationFileName: 'TestFile.pdf',
//     // //   );
//     // //   log('Saved to $file');
//     // // } on PlatformException catch (e) {
//     // //   log('file saving error: ${e.code}');
//     // // }

//     // final bytes = await pdf.save();
//     // final file = File(filePath);
//     // await file.writeAsBytes(bytes);

//     // return file;

//     // if (status.isGranted) {
//     //   // Access the file here
//     // return FileHandleApi.saveDocument(name: 'invoice_$barcode.pdf', pdf: pdf);
//     // } else {
//     //   await openAppSettings();
//     //   return null;
//     // }
//   }
// }
