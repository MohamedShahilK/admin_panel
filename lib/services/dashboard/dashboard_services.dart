// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/models/new/all_checkin/all_checkin_response_model.dart';
import 'package:admin_panel/models/new/all_checkout/all_checkout_response_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/brands/car_brands_model.dart';
import 'package:admin_panel/models/new/dashboard/dashboard_resp_model.dart';
import 'package:admin_panel/models/new/print/printing_header_model.dart';
import 'package:admin_panel/models/new/settings/settings_model.dart';
import 'package:admin_panel/models/new/user/user_model.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/utility_functions.dart';

class DashBoardServices {
  factory DashBoardServices() => _instance ??= DashBoardServices._();
  DashBoardServices._();
  static DashBoardServices? _instance;

  final api = Api();

  // get all tickets
  // can be sort by id,barcode,createdate
  // inventory = true for getting all tickets except checkout
  Future<GetAllTicketsResponse?> getAllTickets({
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
            // 'user_id' : 'null',
          },
          EndPoints.getAllTickets,
        );
        // //print('1111111111111111111111111111 ${response!.data}');
        final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
        final userType = StorageServices.to.getString('userType');
        // print('dddddddddddddddddddddddddddddddddddddddddddd $userType');
        if (userType == 'A' || userType == 'ADMIN') {
          await StorageServices.to.setInt('locationId', respModel.data?.locationsList?.first.departmentId ?? 0);
          print('tttttttttttttttttttttttttttttttttttttt ${StorageServices.to.getInt('locationId')}');
        }
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getAllTickets Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  // Future<GetAllTicketsResponse?> getAllTicketsWithLocation({
  //   required String orderBy,
  //   required int locationId,
  //   required String orderByDirection, //ASC
  // }) async {
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
  //           'order_by': orderBy,
  //           'order_by_direction': orderByDirection,
  //           'parking_location': locationId,
  //         },
  //         EndPoints.getAllTickets,
  //       );
  //       // //print('1111111111111111111111111111 ${response!.data}');
  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     Loader.hide();
  //     print('getAllTickets Error :- $e');
  //     // await toastInfo(
  //     //   msg: e.toString(),
  //     //   gravity: ToastGravity.BOTTOM,
  //     //   backgroundColor: Colors.red[500]!,
  //     // );
  //     return null;
  //   }
  // }

  Future<GetUsersModel?> getUsersWithLocation({
    required String orderBy,
    required int locationId,
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
            'parking_location': locationId,
          },
          EndPoints.getUsers,
        );
        // //print('1111111111111111111111111111 ${response!.data}');
        final respModel = GetUsersModel.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getUsersWithLocation Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<GetUsersModel?> getUsersAllLocationAndUsers({
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
          },
          EndPoints.getUsers,
        );
        // //print('1111111111111111111111111111 ${response!.data}');
        final respModel = GetUsersModel.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getUsersWithLocation Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<GetAllTicketsResponse?> getAllTicketsWithPageNo({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'page': pageNo,
            // 'user_id' : 'null',
          },
          EndPoints.getAllTickets,
        );
        // //print('1111111111111111111111111111 ${response!.data}');
        final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getAllTicketsWithPageNo Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<DashBoardResponseModel?> getDashBoardWithTicket({required int pageNo}) async {
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
            'page': pageNo,
          },
          EndPoints.dashboard,
        );
        print('getDashBoardWithTicket1111111111111111111111111111 ${(response!.data?['data']['active_tickets'] as List).length}');
        final respModel = DashBoardResponseModel.fromJson(response!.data ?? {});

        await StorageServices.to.setString('logoPath', respModel.logoPath!);

        if (StorageServices.to.getString('company_logo_file_path').isEmpty) {
          // company logo download
          final operatorID = StorageServices.to.getString('operatorId');
          final imageUrl = '${ApiConstants.BASE_URL}/${StorageServices.to.getString('logoPath')}';
          await UtilityFunctions().downloadAndSaveImage(imageUrl: imageUrl, operatorID: operatorID);
          // company logo download
        }

        // await StorageServices.to.setInt('locationId', respModel.locationId!);
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getDashBoardWithTicket Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<DashBoardResponseModel?> getDashBoardAllTicketsWithDate({
    required int pageNo,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      if (haveToken) {
        print('6848468468447878697');
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              // 'accept': '*/*',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {
            'page': pageNo,
            'start_date': startDate,
            'end_date': endDate,
          },
          EndPoints.dashboard,
        );
        print('1111111111111111111111111111 ${response!.data?['location_name']}');
        final respModel = DashBoardResponseModel.fromJson(response!.data ?? {});
        await StorageServices.to.setString('logoPath', respModel.logoPath!);

        if (StorageServices.to.getString('company_logo_file_path').isEmpty) {
          // company logo download
          final operatorID = StorageServices.to.getString('operatorId');
          final imageUrl = '${ApiConstants.BASE_URL}/${StorageServices.to.getString('logoPath')}';
          await UtilityFunctions().downloadAndSaveImage(imageUrl: imageUrl, operatorID: operatorID);
          // company logo download
        }

        // await StorageServices.to.setInt('locationId', respModel.locationId!);
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getDashBoardAllTicketsWithDate Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<AllCheckInResponse?> getCheckInTickets({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'page': pageNo,
          },
          EndPoints.getAllCheckins,
        );
        //print('Done');
        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = AllCheckInResponse.fromJson(response!.data ?? {});

        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getCheckInTickets Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<AllCheckOutResponse?> getCheckOutTickets({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'checkout_status': 'Y',
            'page': pageNo,
          },
          EndPoints.getAllCheckOuts,
        );
        //print('getCheckOutTickets');

        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = AllCheckOutResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getCheckOutTickets Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<AllCheckOutResponse?> getRequestedTickets({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'page': pageNo,
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
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<AllCheckOutResponse?> getOnTheWayTickets({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'page': pageNo,
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

  Future<AllCheckOutResponse?> getCollectNowTickets({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'checkout_status': 'C',
            'page': pageNo,
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
      print('getCollectNowTickets Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<AllCheckOutResponse?> getParkedTickets({
    required String orderBy,
    required String orderByDirection, //ASC
    required int pageNo,
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
            'checkout_status': 'P',
            'page': pageNo,
          },
          EndPoints.getAllCheckOuts,
        );
        //print('Done');
        // print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${response!.data}');
        final respModel = AllCheckOutResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getParkedTickets Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<GetCarBrandsModel?> getCarBrands() async {
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
          EndPoints.carBrands,
        );
        //print('Done');
        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = GetCarBrandsModel.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getCarBrands Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<PrintingHeadingModel?> getPrintingSettingsAndHeader({required int locationId}) async {
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
            'location_id': locationId,
          },
          EndPoints.printSettings,
        );
        //print('Done');
        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = PrintingHeadingModel.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getPrintingSettingsAndHeader Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }

  Future<GetSettingsModel?> getSettings() async {
    try {
      final token = StorageServices.to.getString(StorageServicesKeys.token);
      final haveToken = token.isNotEmpty;
      print(token);
      if (haveToken) {
        final response = await api.dio?.get<Map<String, dynamic>>(
          options: Options(
            headers: {
              // 'accept': '*/*',
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Headers': '*',
              // 'Access-Control-Allow-Headers': 'Origin, Content-Type, Cookie, X-CSRF-TOKEN, Accept, Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin',
              // 'Access-Control-Expose-Headers': 'Authorization, authenticated',
              // 'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, OPTIONS',
              // 'Access-Control-Allow-Credentials': 'true',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          EndPoints.settings,
        );
        //print('Done');
        // //print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${(response!.data?['checkin_list'] as List).length}');
        final respModel = GetSettingsModel.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getSettings Error :- $e');
      // await toastInfo(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red[500]!,
      // );
      return null;
    }
  }
}
