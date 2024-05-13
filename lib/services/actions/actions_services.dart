// ignore_for_file: inference_failure_on_function_invocation, avoid_print, lines_longer_than_80_chars, use_build_context_synchronously, avoid_dynamic_calls

import 'dart:io';

import 'package:admin_panel/utils/custom_tools.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http_parser/http_parser.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/api/api_errror_handling.dart';
import 'package:admin_panel/models/new/actions/actions_response_model.dart';
import 'package:admin_panel/models/new/actions/checkin/checkin_responce_model.dart';
import 'package:admin_panel/models/new/actions/checkout_form/all_checkout_items.dart';
import 'package:admin_panel/models/new/actions/image_upload/image_upload_form_response_model.dart';
import 'package:admin_panel/models/new/actions/image_upload/post_image_upload_response_model.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart' as tdrm;
import 'package:admin_panel/models/new/actions/ticket_models/ticket_exists_model.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_generation_settings_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/permission/permssion_model.dart';
import 'package:admin_panel/models/new/status/change_status_response.dart';
import 'package:admin_panel/services/auth/auth_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/storage_services.dart';


class ActionsServices {
  factory ActionsServices() => _instance ??= ActionsServices._();
  ActionsServices._();
  static ActionsServices? _instance;

  final api = Api();

  Future<ActionsResponseModel?> getAllCheckInItems() async {
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
          EndPoints.checkinForm,
        );

        final model = ActionsResponseModel.fromJson(response!.data ?? {});

        await StorageServices.to.setList('cvas', model.data?.cvas?.map((e) => e.departmentName ?? '').toList() ?? []);

        return model;
      }

      return null;
    } on Exception catch (e) {
      Loader.hide();
      print('getAllCheckInItems Error $e');
      return null;
    }
  }

  Future<AllCheckOutItemsResponse?> getAllCheckOutItems({int? id}) async {
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
          // queryParameters: {'id': '522'},
          queryParameters: {'id': id},
          EndPoints.checkoutForm,
        );
        print('1111111111111111111111');

        return AllCheckOutItemsResponse.fromJson(response!.data ?? {});
      }

      return null;
    } on Exception catch (e) {
      Loader.hide();
      print('getAllCheckOutItems Error $e');
      return null;
    }
  }

  // Check In Submit
  Future<CheckInSubmitResponseModel?> checkInSubmit({
    required String ticketNumber,
  }) async {
    CheckInSubmitResponseModel? model;
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final formData = FormData.fromMap({
          'ticket_number': ticketNumber,
          'mobile_number': '',
          // 'plate_number': '',
          'car_brand': 0,
          'car_color': 0,
          'plate_number': '',
          'guest_room_number': 0,
          'note': '',
        });
        final response = await api.dio?.post<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              // 'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          EndPoints.checkinSubmit,
          data: formData,
        );

        model = CheckInSubmitResponseModel.fromJson(response!.data ?? {});
      }
      // return null;
      return model;
    } catch (e) {
      Loader.hide();
      print('checkInSubmit Error :- $e');
      return null;
      // rethrow;
    }
  }

  // Check In Submit Edit
  Future<CheckInSubmitResponseModel?> checkInSubmitEdit(
    BuildContext context, {
    required String ticketNumber,
    required int id,
    required int? vechicleNumberId,
    required String? vechicleNumber,
    required int? modelId,
    required int? colorId,
    required int? driverId,
    required String? slot,
    required String? guestName,
    required String? guestPhoneNumber,
    required String? guestNotes,
  }) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      //print('id : $id');
      if (haveToken) {
        final formData = FormData.fromMap({
          'ticket_number': ticketNumber,
          'mobile_number': guestPhoneNumber,
          'plate_number': vechicleNumber,
          'car_brand': modelId,
          'car_color': colorId,
          'cva': driverId,
          // 'slot_number':slot,
          'guest_room_number': slot,
          'emirates': vechicleNumberId,
          'guest_name': guestName,
          'note': guestNotes,
        });
        final response = await api.dio?.post<Map<String, dynamic>>(
          options: Options(
            headers: {
              'accept': '*/*',
              // 'Content-Type': 'application/json',
              'contentType': 'multipart/form-data',
              // 'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'id': id},
          EndPoints.checkinSubmit,
          data: formData,
        );
        //print('Response : ${response!.data}');
        return CheckInSubmitResponseModel.fromJson(response!.data ?? {});
      }
      return null;
    } on BadRequestException catch (e) {
      Loader.hide();
      final errorResponse = e.response;
      final errorMsg = errorResponse!.data['errors']['errors'];

      final mobileNumberError = errorMsg['mobile_number'];
      final plateNumberError = errorMsg['guest_name'];
      try {
        await erroMotionToastInfo(context, msg: mobileNumberError as String);
      } catch (e) {
        //
      }
      try {
        await erroMotionToastInfo(context, msg: plateNumberError as String);
      } catch (e) {
        //
      }
      // print('login function Error1 : ${errorMsg as String}');
      print('checkInSubmitEdit Error :- $e');
      return null;
      // rethrow;
    } catch (e) {
      Loader.hide();
      print('checkInSubmitEdit Error :- $e');
      return null;
    }
  }

  // Check Ticket Exists or Not
  Future<bool> checkTicketExists({required String ticketNumber}) async {
    var isExists = false;
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'ticket_number': ticketNumber},
          EndPoints.CheckTicketExists,
        );

        final respModel = TicketExistsResponseModel.fromJson(response!.data ?? {});
        final existsOrNot = respModel.data!.ticketInfo!.isNotEmpty;
        isExists = existsOrNot;
      }
      return isExists;
    } catch (e) {
      Loader.hide();
      print('checkTicketExists Error :- $e');
      return false;
    }
  }

  // Settings for ticket generation
  Future<TicketSettingsResponseModel?> ticketGenerationSettings() async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          EndPoints.getTicketNumberSettings,
        );
        return TicketSettingsResponseModel.fromJson(response!.data ?? {});
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('ticketGenerationSettings Error :- $e');
      return null;
    }
  }

  // get Ticket details
  Future<tdrm.TicketDetailsResponseModel?> getTicketDetails({
    required String ticketNumber,
  }) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'ticket_number': ticketNumber},
          EndPoints.CheckTicketExists,
        );

        final respModel = tdrm.TicketDetailsResponseModel.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getTicketDetails Error :- $e');
      return null;
    }
  }

  // providing status is true or false
  Future<bool> isStatusTrue({required String ticketNumber, required String status}) async {
    var isStatus = false;
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'ticket_number': ticketNumber},
          EndPoints.CheckTicketExists,
        );

        // //print(response!.data.toString());

        final respModel = tdrm.TicketDetailsResponseModel.fromJson(response!.data ?? {});
        if (respModel.data != null && respModel.data?.ticketInfo != null && respModel.data!.ticketInfo!.isNotEmpty) {
          isStatus = respModel.data!.ticketInfo?[0].checkoutStatus == status;
        }
        //print(respModel.data!.ticketInfo[0].checkoutStatus);
        return isStatus;
      }
      return isStatus;
    } catch (e) {
      Loader.hide();
      print('isStatusTrue Error :- $e');
      return false;
    }
  }

  // Change Ticket Status
  // Future<Map<dynamic, dynamic>> changeTicketStatus({required int id, required String status}) async {
  Future<ChangeStatusResponse?> changeTicketStatus({required int id, required String status}) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final formData = FormData.fromMap({'status': status});
        final response = await api.dio?.post<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'id': id},
          data: formData,
          EndPoints.changeTicketStatus,
        );
        final respModel = ChangeStatusResponse.fromJson(response!.data ?? {});
        // log('1111111111111111111111111111 ${respModel.data}');
        return respModel;
        // return {
        //   'status': response.data!['status'],
        //   'message': response.data!['message'],
        // };
      }
      // return {};
      return null;
    } catch (e) {
      Loader.hide();
      print('changeTicketStatus Error :- $e');
      // return {};
      return null;
    }
  }

  // Checkout submit
  Future<ChangeStatusResponse?> checkOutSubmit({
    required String id,
    required String status,
    required String ticketNumber,
    required int? cvaOutId,
    required int? outletId,
    required String paymentPaidMethod,
    required int paymentMethodId,
    required String paymentNote,
    required String discountAmount,
    required double vatPercentage,
    required double vatAmount,
    required String grossAmount,
    required double subTotal,
    required String payment,
    int paymentMethod = 1,
    String cashierName = 'Vimal Cash',
    int voucherMainId = 1,
    String voucherBarcode = '1',
    String voucherCodeNo = '1',
  }) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final formData = FormData.fromMap({
          'status': status,
          'ticket_number': ticketNumber,
          'cva_out': cvaOutId,
          'verified_in_outlet': outletId,
          'cashier_name': cashierName,
          'payment_paid_method': paymentPaidMethod,
          'payment_method': paymentMethod, //doubt
          'payment_method_id': paymentMethodId,
          'payment_note': paymentNote,
          'vat_percentage': vatPercentage,
          'vat_amount': vatAmount,
          'discount_amount': discountAmount,
          'gross_amount': grossAmount,
          'sub_total': subTotal,
          'payment': payment,
          'voucher_main_id': voucherMainId,
          'voucher_barcode': voucherBarcode,
          'voucher_code_no': voucherCodeNo,
        });
        final response = await api.dio?.post<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'id': id},
          data: formData,
          EndPoints.changeTicketStatus,
        );
        final respModel = ChangeStatusResponse.fromJson(response!.data ?? {});

        return respModel;
      }

      return null;
    } catch (e) {
      Loader.hide();
      // print('1111111111111111111');
      print('checkOutSubmit Error :- $e');

      return null;
    }
  }

  // Get Image Upload Form
  Future<ImageUploadFormResponseModel?> getImageUploadForm({required int ticketId}) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'id': ticketId},
          EndPoints.uploadImageForm,
        );

        // //print(response?.data);
        final respModel = ImageUploadFormResponseModel.fromJson(response!.data ?? {});

        print(respModel);

        return respModel;
      }

      return null;
    } catch (e) {
      Loader.hide();
      print('getImageUploadForm Error :- $e');

      return null;
    }
  }

  // Jpg jpeg gif png
  // 600*400
  // 1 mb or 500kb

  // Upload image into Server
  Future<PostUploadImageResponseModel?> postUploadImageIntoServer({required int ticketId, required int? vechiclePartId, required String remark, required File file}) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final fileName = file.path.split('/').last;
        //print(file.path);

        final formData = FormData.fromMap({
          'vehicle_part_id': vechiclePartId,
          'remark': remark,
          'photo': await MultipartFile.fromFile(
            file.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        });
        final response = await api.dio?.post<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'id': ticketId},
          data: formData,
          EndPoints.uploadImageSubmit,
        );

        // //print(response?.data);
        //print('11111111111111111111111111111111111111111111111111111111111111111');
        final respModel = PostUploadImageResponseModel.fromJson(response!.data ?? {});
        //print('2222222222222222222222222222222222222222222222222222222222222222');

        return respModel;
      }

      return null;
    } catch (e) {
      Loader.hide();
      print('postUploadImageIntoServer Error :- $e');

      return null;
    }
  }

  // Get All Permissions
  Future<GetAllPermissions?> getAllPermissions() async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final regenerateAuthResp = await AuthServices().regenerateToken(token: token);
        final newToken = regenerateAuthResp.data.token;
        // print('44444444444444444444444444444444 $newToken');
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
          ),
          EndPoints.getPermissions,
        );

        // //print(response?.data);
        final respModel = GetAllPermissions.fromJson(response!.data ?? {});

        print(respModel);

        return respModel;
      }

      return null;
    } catch (e) {
      Loader.hide();
      print('getAllPermissions Error :- $e');

      return null;
    }
  }

  // Ticket exclude checkout have given plate number
  Future<GetAllTicketsResponse?> ticketHavingSamePlateNumberExcludeCheckOut({required int emirates, required String vehicleNumber}) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {
            'inventory': true,
            'vehicle_number': vehicleNumber,
            'emirates': emirates.toString(),
          },
          EndPoints.getAllTickets,
        );

        // //print(response?.data);
        final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});

        print(respModel);

        return respModel;
      }

      return null;
    } catch (e) {
      Loader.hide();
      print('ticketHavingSamePlateNumberExcludeCheckOut Error :- $e');

      return null;
    }
  }

  // Future<tdrm.TicketInfo?> getOneCheckoutTicket({required String ticketNumber}) async {
  //   try {
  //     final token = StorageServices.to.getString(StorageServicesKeys.token);
  //     final haveToken = token.isNotEmpty;
  //     if (haveToken) {
  //       final response = await api.dio?.get<Map<String, dynamic>>(
  //         options: Options(
  //           headers: {
  //             // 'accept': '*/*',
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $token',
  //           },
  //         ),
  //         queryParameters: {
  //           'order_by': 'id',
  //           'order_by_direction': 'DESC',
  //           'checkout_status': 'Y',
  //           'barcode': ticketNumber,
  //         },
  //         EndPoints.getAllCheckOuts,
  //       );
  //       //print('getCheckOutTickets');

  //       // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
  //       final respModel = tdrm.TicketInfo.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error :- $e');
  //     await toastInfo(
  //       msg: e.toString(),
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red[500]!,
  //     );
  //     return null;
  //   }
  // }

  Future<tdrm.TicketDetailsResponseModel?> getOneCheckoutTicket({required String ticketId}) async {
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
          queryParameters: {'id': ticketId},
          EndPoints.ticketInfo,
        );
        //print('getCheckOutTickets');

        // debugPrint('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['data']['ticket_info'])}');
        final respModel = tdrm.TicketDetailsResponseModel.fromJson(response!.data ?? {});
        // debugPrint('2222222222222 : ${respModel.data}');
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getOneCheckoutTicket Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteImage({required String ticketId, required String imageId}) async {
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
          queryParameters: {'id': ticketId, 'image_id': imageId},
          EndPoints.deleteImage,
        );

        // print(response?.data);
        final mapData = response?.data;
        return mapData;
      }
      return null;
    } on BadRequestException catch (e) {
      Loader.hide();
      print('deleteImage Error :- ${e.response!.data}');
      final errorMapData = e.response?.data as Map<String, dynamic>;
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return errorMapData;
    } catch (e) {
      Loader.hide();
      print('deleteImage Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }
}
