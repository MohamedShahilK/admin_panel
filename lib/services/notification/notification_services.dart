// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/models/new/all_checkout/all_checkout_response_model.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/storage_services.dart';

class NotificationsServices {
  factory NotificationsServices() => _instance ??= NotificationsServices._();
  NotificationsServices._();
  static NotificationsServices? _instance;

  final api = Api();
  Future<AllCheckOutResponse?> getRequestedTickets({
    required String orderBy,
    required String orderByDirection, //ASC
  }) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              // 'accept': '*/*',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {
            'order_by': orderBy,
            'order_by_direction': orderByDirection,
            'checkout_status': 'R',
          },
          EndPoints.getAllCheckOuts,
        );
        //print('Done');
        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = AllCheckOutResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getRequestedTickets Error :- $e');
      // await toastInfo(
      //   msg:  e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<AllCheckOutResponse?> getOnTheWayTickets({
    required String orderBy,
    required String orderByDirection, //ASC
  }) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              // 'accept': '*/*',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {
            'order_by': orderBy,
            'order_by_direction': orderByDirection,
            'checkout_status': 'O',
          },
          EndPoints.getAllCheckOuts,
        );
        //print('Done');
        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = AllCheckOutResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getOnTheWayTickets Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }
}
