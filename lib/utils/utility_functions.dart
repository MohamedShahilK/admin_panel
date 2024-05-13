// ignore_for_file: lines_longer_than_80_chars, avoid_print, cascade_invocations

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/utils/storage_services.dart';
// import 'package:jiffy/jiffy.dart';

// DateTime localTime = DateTime.now();
// final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Dubai'));
// final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Kuwait'));
// final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Riyadh'));
// final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Kolkata'));

// final timezoneRegion = StorageServices.to.getString('timezone');

// final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Riyadh'));

class UtilityFunctions {
  static Duration convertLocalToDubaiTime() {
    final localTime = DateTime.now();
    final timezoneRegion = StorageServices.to.getString('timezone');
    final dubaiTime = TZDateTime.from(localTime, getLocation(timezoneRegion));
    // Example India
    // final detroitTime = new TZDateTime.from(localTime, getLocation('America/Detroit'));
    // final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Dubai'));
    // print('Dubai Time: $dubaiTime');
    // print('Local Time: ${DateTime.parse(convertIntoNormalDateTimeStringFromDateTimeStringForTimezone(localTime.toString()))}');
    // print('Dubai Time: ${DateTime.parse(convertIntoNormalDateTimeStringFromDateTimeStringForTimezone(dubaiTime.toString()))}');
    // final b = DateTime.parse(convertIntoNormalDateTimeStringFromDateTimeStringForTimezone(dubaiTime.toString()));
    // print('difference: ${dubaiTime.difference(localTime)}');
    // print('difference: ${a.difference(a)}');

    // DateTime localTime = DateTime.now(); //Emulator time is India time
    // final dubaiTime = TZDateTime.from(localTime, getLocation('Asia/Singapore'));
    // print('Local Time: $localTime');
    // print('Dubai Time: ${DateTime(dubaiTime.year, dubaiTime.month, dubaiTime.day, dubaiTime.hour, dubaiTime.minute, dubaiTime.second)}');
    final a = DateTime.parse(convertIntoNormalDateTimeStringFromDateTimeStringForTimezone(localTime.toString()));
    final b = DateTime(dubaiTime.year, dubaiTime.month, dubaiTime.day, dubaiTime.hour, dubaiTime.minute, dubaiTime.second);
    // print(dubaiTime.timeZone);
    // print('difference: ${a.difference(b)}');
    final timeDifference = a.difference(b);
    // print('is Negative when compare to Dubai ::  ${timeDifference.isNegative}');
    return timeDifference;
  }

  static String extractTimeFromDateTime({DateTime? datetime}) {
    DateTime date;
    if (datetime != null) {
      date = datetime;
    } else {
      date = UtilityFunctions.convertLocalToDubaiTime().isNegative
          ? DateTime.now().add(UtilityFunctions.convertLocalToDubaiTime())
          : DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime());
    }
    final formattedTime = '${date.hour}:${date.minute}:${date.second}';
    return formattedTime;
  }

  // static Duration _parseDateTime(String dateTimeString) {
  //   final parts = dateTimeString.split(' ');
  //   // //print('Sample : $parts');
  //   final date = parts[0];
  //   final time = parts[1];

  //   // //print('Sample Date : $date');

  //   final dateParts = date.split('-');
  //   final year = int.parse(dateParts[0]);
  //   final month = int.parse(dateParts[1]);
  //   final day = int.parse(dateParts[2]);

  //   final timeParts = time.split(':');
  //   final hours = int.parse(timeParts[0]);
  //   final minutes = int.parse(timeParts[1]);
  //   final seconds = int.parse(timeParts[2]);

  //   return Duration(
  //     days: day - 1, // Subtract 1 to account for the day itself
  //     hours: hours,
  //     minutes: minutes,
  //     seconds: seconds,
  //   );
  // }

  static String getDuration({required String startTimeString, required String endTimeString, String checkoutStatus = 'N', String? checkoutTime}) {
    // final duration = _parseDateTime(endTimeString) - _parseDateTime(startTimeString);

    Duration duration;

    // print('checkoutTime : $checkoutTime');
    // print('endTimeString : $endTimeString');

    if (checkoutTime != null && checkoutStatus == 'Y') {
      duration = _parseDateTime2(checkoutTime).difference(_parseDateTime2(startTimeString));
    } else {
      duration = _parseDateTime2(endTimeString).difference(_parseDateTime2(startTimeString));
    }

    // duration = _parseDateTime2(endTimeString).difference(_parseDateTime2(startTimeString));

    // print('Years : ${Jiffy.parse('2023/10/04').from(Jiffy.parse('2023/11/9'))}');
    // print('Days in current month: ${Jiffy.now().daysInMonth}');
    // print('Days in a specific month: ${Jiffy.parseFromList([2023, 10]).daysInMonth}');
    // print('Days in a specific month: ${Jiffy.parse('2023/10/9').daysInMonth}');
    // print(
    //   'Total Duration Inc. Month: ${Jiffy.parse('2023/09/04').from(Jiffy.parse(endTimeString), withPrefixAndSuffix: false)} ${(duration.inDays) - (Jiffy.parse(endTimeString).daysInMonth)} days'
    //       .replaceAll('a month', '1 month'),
    // );

    // print('days b/w a month and its next month : ${daysBetweenDateAndNextMonth('2023/09/04')}');

    // print('get 1 st date of next month ${getFirstDateOfNextMonth('2023/09/04')}');

    // String getTotalDurationInclMonth() {
    //   // final totalMonth = Jiffy.parse('2023/09/04').from(Jiffy.parse(endTimeString), withPrefixAndSuffix: false);
    //   final totalMonth = Jiffy.parse(startTimeString).from(Jiffy.parse(endTimeString), withPrefixAndSuffix: false);
    //   num totalDays = 0;
    //   var nextMonth = '';
    //   for (var i = 0; i < int.parse(totalMonth.replaceAll('months', '').replaceAll('a month', '1').trim()); i++) {
    //     if (i == 0) {
    //       // final days = daysBetweenDateAndNextMonth('2023/09/04');
    //       final days = daysBetweenDateAndNextMonth(startTimeString);
    //       totalDays = totalDays + days;
    //       // nextMonth = getFirstDateOfNextMonth('2023/09/04');
    //       nextMonth = getFirstDateOfNextMonth(startTimeString);
    //     } else {
    //       final days = daysBetweenDateAndNextMonth(nextMonth);
    //       final currentMonth = nextMonth;
    //       totalDays = totalDays + days;
    //       nextMonth = getFirstDateOfNextMonth(currentMonth);
    //     }
    //   }
    //   final total = totalMonth.replaceAll('months', '').replaceAll('a month', '1').trim();
    //   return '${total == '1' ? '$total month' : '$total months'} : $totalDays days';
    // }

    // bool isDifferentMonth(String firstDateString, String secondDateString) {
    //   final firstDate = Jiffy.parse(firstDateString);
    //   final secondDate = Jiffy.parse(secondDateString);

    //   return firstDate.month != secondDate.month;
    // }

    // 223163632638

    // print('Is Different Months : ${isDifferentMonth('2023/09/04','2023/11/09')}');

    if (duration.inSeconds.isNegative) {
      // return ;
    }

    if (duration.inDays == 0 && duration.inHours != 0 && duration.inMinutes != 0 && duration.inSeconds != 0) {
      return ' ${duration.inHours.remainder(24)} hr : ${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    } else if (duration.inHours == 0 && duration.inDays == 0 && duration.inMinutes == 0) {
      return '${duration.inSeconds.remainder(60)} s';
    } else if (duration.inHours == 0 && duration.inDays == 0) {
      return '${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    }
    //  else if (isDifferentMonth(startTimeString, endTimeString)) {
    //   return getTotalDurationInclMonth();
    //   // print(getTotalDurationInclMonth());
    //   // return '';
    // }
    else {
      return '${duration.inDays} days: ${duration.inHours.remainder(24)} hr : ${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    }
  }

  static String getDurationForBlutoothPrint({required String startTimeString, required String endTimeString, String checkoutStatus = 'N', String? checkoutTime}) {
    // final duration = _parseDateTime(endTimeString) - _parseDateTime(startTimeString);

    Duration duration;

    if (checkoutTime != null && checkoutStatus == 'Y') {
      duration = _parseDateTime2(checkoutTime).difference(_parseDateTime2(startTimeString));
    } else {
      duration = _parseDateTime2(endTimeString).difference(_parseDateTime2(startTimeString));
    }

    if (duration.inDays == 0 && duration.inHours != 0 && duration.inMinutes != 0 && duration.inSeconds != 0) {
      return ' ${duration.inHours.remainder(24)} hr : ${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    } else if (duration.inHours == 0 && duration.inDays == 0 && duration.inMinutes == 0) {
      return '${duration.inSeconds.remainder(60)} s';
    } else if (duration.inHours == 0 && duration.inDays == 0) {
      return '${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    } else {
      return '${duration.inDays}D:${duration.inHours.remainder(24)}H:${duration.inMinutes.remainder(60)}m:${duration.inSeconds.remainder(60)}s';
    }
  }

  // static num daysBetweenDateAndNextMonth(String dateString) {
  //   // final date = Jiffy.parse('2023/09/04');
  //   final date = Jiffy.parse(dateString);
  //   final firstDayOfNextMonth = date.endOf(Unit.month).add(days: 1);

  //   final daysDifference = firstDayOfNextMonth.diff(date, unit: Unit.day);

  //   return daysDifference;
  // }

  // static String getFirstDateOfNextMonth(String dateString) {
  //   final currentDate = Jiffy.parse(dateString);
  //   final firstDateOfNextMonth = currentDate.endOf(Unit.month).add(days: 1);

  //   return firstDateOfNextMonth.format(pattern: 'yyyy/MM/dd');
  // }

  // static int getHours({required String startTimeString, required String endTimeString}) {
  //   final duration = _parseDateTime(endTimeString) - _parseDateTime(startTimeString);
  //   if (duration.inDays != 0) {
  //     final totalHrsForDays = duration.inDays * 24;
  //     return totalHrsForDays + duration.inHours;
  //   } else {
  //     return duration.inHours;
  //   }
  // }

  static int getHours2({required String startTimeString, required String endTimeString}) {
    final startTime = _parseDateTime2(startTimeString);
    final endTime = _parseDateTime2(endTimeString);

    if (endTime.isBefore(startTime)) {
      throw ArgumentError('endTime must be later than startTime');
    }

    var totalHours = 0;
    var currentDate = startTime;

    while (currentDate.isBefore(endTime)) {
      final endOfCurrentMonth = DateTime(currentDate.year, currentDate.month + 1, 1).subtract(const Duration(days: 1));
      final nextMonthStart = endOfCurrentMonth.add(const Duration(days: 1));

      if (nextMonthStart.isBefore(endTime)) {
        // Calculate hours in the current month
        final durationInMonth = nextMonthStart.difference(currentDate);
        totalHours += durationInMonth.inHours;
        currentDate = nextMonthStart;
      } else {
        // Calculate hours in the last month
        final durationInLastMonth = endTime.difference(currentDate);
        totalHours += durationInLastMonth.inHours;
        break;
      }
    }

    return totalHours;
  }

  static DateTime _parseDateTime2(String dateTimeString) {
    // You can implement your own DateTime parsing logic here.
    // For example, you can use the `DateTime.parse()` method.
    return DateTime.parse(dateTimeString);
  }

  static String getDurationOf2Times({required String startTimeString, required String endTimeString}) {
// Parse the start and end time strings
    final startTime = _parseTime(startTimeString);
    final endTime = _parseTime(endTimeString);

    // Calculate the duration
    final duration = endTime - startTime;

    // Convert the duration to a formatted string
    final formattedDuration = _formatDuration(duration);
    return formattedDuration;
  }

  static String getDurationOf2TimesIsNegative({required String startTimeString, required String endTimeString, String checkoutStatus = 'N', String? checkoutTime}) {
    Duration duration;
// Parse the start and end time strings
    if (checkoutTime != null && checkoutStatus == 'Y') {
      duration = _parseDateTime2(checkoutTime).difference(_parseDateTime2(startTimeString));
    } else {
      duration = _parseDateTime2(endTimeString).difference(_parseDateTime2(startTimeString));
    }

    // duration = _parseDateTime2(endTimeString).difference(_parseDateTime2(startTimeString));

    if (duration.inDays == 0 && duration.inHours != 0 && duration.inMinutes != 0 && duration.inSeconds != 0) {
      return ' ${duration.inHours.remainder(24)} hr : ${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    } else if (duration.inHours == 0 && duration.inDays == 0 && duration.inMinutes == 0) {
      return '${duration.inSeconds.remainder(60)} s';
    } else if (duration.inHours == 0 && duration.inDays == 0) {
      return '${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    }
    //  else if (isDifferentMonth(startTimeString, endTimeString)) {
    //   return getTotalDurationInclMonth();
    //   // print(getTotalDurationInclMonth());
    //   // return '';
    // }
    else {
      return '${duration.inDays} days: ${duration.inHours.remainder(24)} hr : ${duration.inMinutes.remainder(60)} m : ${duration.inSeconds.remainder(60)} s';
    }
    // return duration;
  }

  // static int getHoursInDuration({required String startTimeString, required String endTimeString}) {
  //   // Parse the start and end time strings
  //   final startTime = _parseTime(startTimeString);
  //   final endTime = _parseTime(endTimeString);

  //   // Calculate the duration
  //   final duration = endTime - startTime;

  //   // Extract the number of hours from the duration
  //   final hours = duration.inHours;

  //   return hours;
  // }

  static int getHoursInDuration({required String startTimeString, required String endTimeString, String checkoutStatus = 'N', String? checkoutTime}) {
    Duration duration;
    if (checkoutTime != null && checkoutStatus == 'Y') {
      duration = _parseDateTime2(checkoutTime).difference(_parseDateTime2(startTimeString));
    } else {
      duration = _parseDateTime2(endTimeString).difference(_parseDateTime2(startTimeString));
    }

    return duration.inHours;
  }

  static String extractAlphabets(String inputString) {
    // final regex = RegExp(r'[a-zA-Z]');
    final regex = RegExp('[a-zA-Z]');
    final matches = regex.allMatches(inputString);
    var result = '';

    for (final match in matches) {
      result += match.group(0)!;
    }

    return result;
  }

  static String extractNumbers(String inputString) {
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(inputString);
    var result = '';

    for (var match in matches) {
      result += match.group(0)!;
    }

    return result;
  }

  static String calculateTimeDifference(String givenTime) {
    final currentDateTime = DateTime.now().toLocal();
    final givenDateTime = DateTime.parse(givenTime);

    // Calculate the time difference
    final difference = currentDateTime.difference(givenDateTime);

    // Add the time difference to the given time
    final resultDateTime = givenDateTime.add(difference);

    // Format the result as a string in "yyyy-MM-dd HH:mm:ss" format
    final resultString = resultDateTime.toLocal().toString();

    return resultString;
  }

// Function to convert an image from one format to another
  // static Future<File?> convertImageToJpg(File inputFile) async {
  //   try {
  //     // Load the input image
  //     // final inputImageBytes = inputFile.readAsBytesSync();
  //     final tempDirectoryPath = await getTemporaryDirectoryPath();

  //     final outputFile = await FlutterImageCompress.compressAndGetFile(
  //       inputFile.absolute.path,
  //       '$tempDirectoryPath.jpeg',
  //       format: CompressFormat.jpeg,
  //       quality: 85, // Adjust the quality as needed (0 to 100)
  //     );

  //     // Create an output file with the same name but a different extension (JPG)
  //     // final outputFilePath = inputFile.path.replaceAll(RegExp(r'\.[^\.]*$'), '.jpeg');
  //     final jpgFile = File('${outputFile!.path}');

  //     // await outputFile.writeAsBytes(compressedImageBytes!.toList());

  //     // Save the image in JPG format

  //     //print('Conversion completed: ${outputFile.path}');
  //     return jpgFile;
  //   } catch (e) {
  //     //print('Error: $e');
  //     return null;
  //   }
  // }

  // static Future<String> getTemporaryDirectoryPath() async {
  //   try {
  //     final tempDir = await getTemporaryDirectory();
  //     return tempDir.path;
  //   } catch (e) {
  //     //print('Error getting temporary directory path: $e');
  //     return '';
  //   }
  // }

  static Future<File> compressAndResizeImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      '${imageFile.path}_compressed.jpg',
      quality: 90, // Adjust quality as needed (0 to 100).
    );

    return File(result!.path);
  }

  static String splitDateFromString(String dateString) {
    // print('date : ${dateString}');
    // final date =dateString.replaceAll(' ', 'T');
    if (dateString != '') {
      final dateTime = DateTime.parse(dateString);
      // print('object : ${d}');

      final year = dateTime.year;
      final month = dateTime.month;
      final day = dateTime.day;
      print('$day-$month-$year');
      return '$day-$month-$year';
    } else {
      return '';
    }
  }

  static String splitTimeFromString(String dateString) {
    // print('date : ${dateString}');
    // final date =dateString.replaceAll(' ', 'T');
    if (dateString != '') {
      final dateTime = DateTime.parse(dateString);
      // print('object : ${dateTime}');

      final hour = dateTime.hour;
      final min = dateTime.minute;
      final sec = dateTime.second;
      print('$hour:$min:$sec');
      return '$hour:$min:$sec';
    } else {
      return '';
    }
  }

  static String convertIntoNormalDateTimeStringFromDateTimeStringForTimezone(String dateTimeString) {
    final toDateTime = DateTime.parse(dateTimeString);
    final normalDateString = DateFormat('yyyy-MM-dd HH:mm:ss').format(toDateTime);
    return normalDateString;
  }

  static String convertIntoNormalDateTimeStringFromDateTimeString(String dateTimeString) {
    final toDateTime = DateTime.parse(dateTimeString);
    final normalDateString = DateFormat('dd-MM-yyyy HH:mm:ss').format(toDateTime);
    return normalDateString;
  }

  static String convertIntoNormalDateStringFromDateTimeString(String dateTimeString) {
    final toDateTime = DateTime.parse(dateTimeString);
    final normalDateString = DateFormat('dd-MM-yyyy').format(toDateTime);
    return normalDateString;
  }

  static String convertIntoNormalTimeStringFromDateTimeString(String dateTimeString) {
    final toDateTime = DateTime.parse(dateTimeString);
    final normalDateString = DateFormat('HH:mm:ss').format(toDateTime);
    return normalDateString;
  }

  static List<String> generateDateList({required DateTime startDate, required DateTime? endDate}) {
    final datesList = <String>[];
    // final start =startDate;
    // final end = endDate;

    // for (var date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
    for (var date = startDate; endDate == null ? date.isBefore(DateTime.now()) : date != endDate.add(const Duration(days: 1)); date = date.add(const Duration(days: 1))) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      datesList.add(formattedDate);
    }
    return datesList;
  }

  Future<void> downloadAndSaveImage({required String imageUrl, required String operatorID}) async {
    final api = Api();

    try {
      // Send a GET request
      final response = await api.dio?.get<List<int>>(imageUrl, options: Options(responseType: ResponseType.bytes));

      // Get the app's document directory
      final appDocDir = await getApplicationDocumentsDirectory();

      // Create a file with a unique name in the documents directory
      final filePath = '${appDocDir.path}/${operatorID}_company_logo.png';
      final file = File(filePath);

      // Check if the file exists
      final fileExists = await file.exists();

      if (fileExists) {
        // If the file exists, open it in append mode and write the new bytes
        final sink = file.openWrite(mode: FileMode.append);
        sink.add(response!.data!);
        await sink.close();
        print('Bytes appended to the existing file.');
      } else {
        // If the file doesn't exist, simply write the bytes using writeAsBytes
        await file.writeAsBytes(response!.data!);
        print('New file created with the provided bytes.');
      }

      // Write the downloaded bytes to the file
      // await file.writeAsBytes(response!.data!);

      await StorageServices.to.setString('company_logo_file_path', filePath);

      print('Image downloaded and saved to: $filePath');
    } catch (e) {
      print('Error downloading image: $e');
    }
  }
}

Duration _parseTime(String timeString) {
  final parts = timeString.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = int.parse(parts[2]);
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
