// It’s easier to add interceptors when handling requests and errors
//(i.e when refreshing JWT tokens).

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/api/api_errror_handling.dart';
// import 'package:admin_panel/models/firebase/chat_user.dart';
// import 'package:admin_panel/models/firebase/message.dart';
import 'package:admin_panel/utils/storage_services.dart';

class Api {
  factory Api() => _singleton;
  Api._internal();
  static final _singleton = Api._internal();

  // for authentication
  // static FirebaseAuth auth = FirebaseAuth.instance;

  // to return current user
  // static User get user => auth.currentUser!;

  // final dio = Dio();
  final dio = createDio();

  static Dio? createDio() => Dio(
        BaseOptions(
          baseUrl: ApiConstants.BASE_URL,
          receiveTimeout: const Duration(seconds: 15), // 15 seconds
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      )..interceptors.add(AppInterceptors());
  // ..interceptors.add(LogInterceptor(responseBody: true));

  static Future<void> sendPushNotification({required String title, required String msg}) async {
    try {
      // final url = Uri.https('example.com', 'whatsit/create');
      // final body = {
      //   'to': 'fqrlBA_MSIa0Cmtdop8bCT:APA91bFWpiOw-5zj5hEcl4hyID5Yw5OkXmLSuptl-ZFXWV_tYQWszPqSi_Eo8VUDIDwWh682XnawNrb5BoFuNupnahg2KtdjYlBbVG1jwgP-QUp-xxOP41pwe94NyA0BQZeXfkPbNnGQ',
      //   'notification': {
      //     'title':'Hi',
      //     'body': 'Hello',
      //   },
      // };
      final operatorId = StorageServices.to.getString('operatorId');

      final locationName = StorageServices.to.getString('locationName').trim().replaceAll(' ', '');

      print('locationName $locationName');

      final body = {
        // 'to': '/topics/allDevices',
        // 'to': '/topics/$userType$operatorId',
        'to': '/topics/$locationName$operatorId',
        // 'notification': {
        //   'title': 'Requested',
        //   'body': 'Hello',
        // },
        'notification': {
          'title': title,
          'body': msg,
          // 'icon': 'res_app_icon',
          // 'color': '#FF5733',
          // 'image': 'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&w=600',
          // 'icon': 'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&w=600',
          // 'android': {'icon': 'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&w=600'}
        },
      };
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAA27RBilE:APA91bHv8GrFW4JXEOEqHep_d3Z2XEaoLCtD_QytRCRo39rrWwS1xNy68W10NSzDh1BRsgEbB_l7U3-L7BIXmUZ8GKMrqxFjH0M43XGcuekiF6KanisCkXSIUV_WEnHPMmkJQn9FE1-c',
        },
        body: jsonEncode(body),
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
    } catch (e) {
      log('SendPushNotifications : $e');
    }
  }

  // static Future<void> sendMessages({required ChatUser chatUser, required String msg, required Type type}) async {
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();

  //   final message = Message(
  //     toId: chatUser.id,
  //     msg: msg,
  //     read: '',
  //     type: type,
  //     fromId: user.uid,
  //     sent: time,
  //   );
  // }
}
