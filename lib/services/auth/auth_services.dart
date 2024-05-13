// ignore_for_file: inference_failure_on_function_invocation, cast_nullable_to_non_nullable, lines_longer_than_80_chars

import 'dart:developer';

import 'package:admin_panel/utils/custom_tools.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/api/api_errror_handling.dart';
import 'package:admin_panel/models/new/auth/auth_response_model.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/storage_services.dart';


class AuthServices {
  factory AuthServices() => _instance ??= AuthServices._();
  AuthServices._();
  static AuthServices? _instance;

  final api = Api();

  // Auth
  Future<AuthResponseModel?> login(
    BuildContext context, {
    required String username,
    required String password,
    required String operatorId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
        'OPERATOR_ID': operatorId,
      });

      final response = await api.dio!.post<Map<String, dynamic>>(
        EndPoints.login,
        data: formData,
      );

      return AuthResponseModel.fromJson(response.data ?? {});
    } on UnauthorizedException catch (e) {
      Loader.hide();
      final errorResponse = e.response;
      final errorMsg = errorResponse!.data['errors'][0];

      // await toastInfo(
      //   msg: errorMsg as String,
      //   gravity: ToastGravity.BOTTOM,
      // );

      // ignore: use_build_context_synchronously
      // MotionToast.error(
      //   title: Text(errorMsg as String, style: TextStyle(fontSize: 12.w)),
      //   description: const Text(''),
      //   height: 40.h,
      //   width: 300.w,
      //   iconSize: 23.w,
      //   animationType: AnimationType.fromLeft,
      //   animationDuration: const Duration(milliseconds: 800),
      // ).show(context);

      await erroMotionToastInfo(context, msg: errorMsg as String);
      print('login function Error1 : ${errorMsg as String}');
      return null;
      // rethrow;
    } on Exception catch (e) {
      Loader.hide();
      print('login function Error2 : $e');
      // await toastInfo(
      //   msg: 'Invalid Username or Password',
      // );
      return null;
      // rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await StorageServices.to.remove(StorageServicesKeys.token);
  }

  // Get Token
  Future<AuthResponseModel?> getToken({required String token}) async {
    try {
      final response = await api.dio?.get<Map<String, dynamic>>(
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        EndPoints.getToken,
      );

      return AuthResponseModel.fromJson(response!.data ?? {});
    } catch (e) {
      Loader.hide();
      print('getToken function $e');
      // rethrow;
      return null;
    }
  }

  // Regenerate Token
  Future<AuthResponseModel> regenerateToken({required String token}) async {
    try {
      final response = await api.dio!.get<Map<String, dynamic>>(
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        EndPoints.regenerateToken,
      );

      return AuthResponseModel.fromJson(response.data ?? {});
    } on Exception catch (e) {
      Loader.hide();
      // log(e.toString());
      print('regenerateToken Error $e');
      rethrow;
    }
  }
}
