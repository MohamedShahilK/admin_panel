// ignore_for_file: inference_failure_on_function, lines_longer_than_80_chars
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/api/api_errror_handling.dart';
import 'package:admin_panel/models/new/account/change_pass_response_model.dart';
import 'package:admin_panel/models/new/account/token_details_response_model.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/storage_services.dart';


class AccountServices {
  factory AccountServices() => _instance ??= AccountServices._();
  AccountServices._();
  static AccountServices? _instance;

  final api = Api();

  Future<GetTokenDetailsResponse?> getTokenDetails() async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              // 'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          EndPoints.getTokenDetails,
        );

        return GetTokenDetailsResponse.fromJson(response!.data ?? {});
      }

      return null;
    } on Exception catch (e) {
      Loader.hide();
      print('getTokenDetails Error $e');
      return null;
    }
  }

  Future<ChangePasswordResponseModel?> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    ChangePasswordResponseModel? model;
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final formData = FormData.fromMap({
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        });
        final response = await api.dio?.post<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              // 'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          EndPoints.changePassword,
          data: formData,
        );

        model = ChangePasswordResponseModel.fromJson(response!.data ?? {});
      }
      // return null;
      return model;
    } on UnauthorizedException catch (e) {
      Loader.hide();
      print('changePassword Error :- $e');
      final errorResponse = e.response;
      var errorMsg = errorResponse!.data['message'];
      if (errorMsg is String) {
        if (errorMsg == 'Password mismatch') {
          errorMsg = 'Your Current Password Is Wrong';
        }
        await erroMotionToastInfo(context, msg: errorMsg);
      }
      // // //print(errorMsg);
      // await toastInfo(
      //   msg: '$errorMsg'.toUpperCase(),
      //   gravity: ToastGravity.BOTTOM,
      // );
      // await toastInfo(
      //   msg: 'Invaild Password.Please Enter Correct Password',
      //   gravity: ToastGravity.BOTTOM,
      // );
      return null;
      // rethrow;
    } on BadRequestException catch (e) {
      Loader.hide();
      final errorResponse = e.response;
      final errorMsg = errorResponse!.data['errors']['errors']['confirm_password'];
      if (errorMsg is String) await erroMotionToastInfo(context, msg: errorMsg);
      // // //print(errorMsg);
      // await toastInfo(
      //   msg: '$errorMsg'.toUpperCase(),
      //   gravity: ToastGravity.BOTTOM,
      // );
      // await toastInfo(
      //   msg: 'Invaild Password.Please Enter Correct Password',
      //   gravity: ToastGravity.BOTTOM,
      // );
      return null;
      // rethrow;
    } catch (e) {
      print('Error :- $e');
      return null;
      // rethrow;
    }
  }
}
