// ignore_for_file: lines_longer_than_80_chars

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:admin_panel/firebase_options.dart';
import 'package:admin_panel/models/new/check_in/hive/check_in.dart';
// import 'package:admin_panel/utils/constants/connectivity_controller.dart';

import 'package:admin_panel/utils/storage_services.dart';

Future<void> mainInitialization() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   ConnectivityController().isInternetConnected(result);
  // });

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  

  // final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // await messaging.getToken().then((value) => print(value));
  // await FirebaseMessaging.instance.subscribeToTopic('allDevices');

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  // Pass all uncaught "fatal" errors from the framework to Crashlytics

  // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // lock screen orientation into portrait
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  // await Permission.notification.request();
  // await Permission.contacts.request();

  // fqrlBA_MSIa0Cmtdop8bCT:APA91bFWpiOw-5zj5hEcl4hyID5Yw5OkXmLSuptl-ZFXWV_tYQWszPqSi_Eo8VUDIDwWh682XnawNrb5BoFuNupnahg2KtdjYlBbVG1jwgP-QUp-xxOP41pwe94NyA0BQZeXfkPbNnGQ
  // fqrlBA_MSIa0Cmtdop8bCT:APA91bFWpiOw-5zj5hEcl4hyID5Yw5OkXmLSuptl-ZFXWV_tYQWszPqSi_Eo8VUDIDwWh682XnawNrb5BoFuNupnahg2KtdjYlBbVG1jwgP-QUp-xxOP41pwe94NyA0BQZeXfkPbNnGQ

  // Hide Status bar
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  // putAsync, because "StorageServices" class returns only after sharedPreferences is initialized, it is a Future function
  await Get.putAsync<StorageServices>(() => StorageServices().init());

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(HiveCheckInModelAdapter().typeId)) {
    Hive.registerAdapter(HiveCheckInModelAdapter());
  }

  tz.initializeTimeZones();

  // await AwesomeNotifications().initialize(
  //   // set the icon to null if you want to use the default app icon
  //   'resource://drawable/res_app_icon',
  //   // null,
  //   [
  //     NotificationChannel(
  //       // icon: 'assets/images/1024.png',
  //       // icon:  'resource://drawable/res_app_icon',
  //       channelGroupKey: 'basic_channel_group',
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: const Color(0xFF9D50DD),
  //       ledColor: Colors.white,
  //     ),
  //   ],
  //   // Channel groups are only visual and are not required
  //   channelGroups: [NotificationChannelGroup(channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')],
  //   debug: true,
  // );

  // await ConnectivityController().init();
}
