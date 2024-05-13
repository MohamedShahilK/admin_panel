// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:admin_panel/api/api.dart';
import 'package:admin_panel/api/api_contants.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/storage_services.dart';

class SearchServices {
  factory SearchServices() => _instance ??= SearchServices._();
  SearchServices._();
  static SearchServices? _instance;

  final api = Api();

  // Future<GetAllTicketsResponse?> getTicketWithBarcode({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required String barcode,
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
  //           'barcode': barcode,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketWithVehiclNumber({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required String vehicleNumber,
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
  //           'vehicle_number': vehicleNumber,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketWithMobileNumber({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required String mobileNumber,
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
  //           'mobile_number': mobileNumber,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithStartAndEndDates({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required String startDate,
  //   required String endDate,
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
  //           'start_date': startDate,
  //           'end_date': endDate,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithVehicleModel({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int vehicleModelId,
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
  //           'vehicle_model': vehicleModelId,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithColor({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int vehicleColorlId,
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
  //           'vehicle_colr': vehicleColorlId,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithEmirates({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int emiratesId,
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
  //           'emirates': emiratesId,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithOutlets({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int outletId,
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
  //           'verified_in_outlet': outletId,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithCvaIn({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int cvaIn,
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
  //           'cva_in': cvaIn,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithCvaOut({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int cvaOut,
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
  //           'cva_in': cvaOut,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithLocationAndUserType({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int parkingLocationId,
  //   required int locationUserId,
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
  //           'parking_location': parkingLocationId,
  //           'location_user_id': locationUserId,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithLocation({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required int parkingLocationId,
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
  //           'parking_location': parkingLocationId,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithCheckoutStatus({
  //   required String orderBy,
  //   required String orderByDirection, //ASC
  //   required String checkOutStatus,
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
  //           'ticket_status': checkOutStatus,
  //         },
  //         EndPoints.getAllTickets,
  //       );

  //       final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
  //       return respModel;
  //     }
  //     return null;
  //   } catch (e) {
  //     //print('Error :- $e');
  //     return null;
  //   }
  // }

  // Now this is using instead of above individuals
  Future<GetAllTicketsResponse?> getTicketsWithCombinations({
    required String orderBy,
    required String orderByDirection, //ASC
    required String checkOutStatus,
    required int parkingLocationId,
    required int locationUserId,
    required int cvaOut,
    required int cvaIn,
    required int outletId,
    required int emiratesId,
    required int vehicleColorlId,
    required int vehicleModelId,
    required String startDate,
    required String endDate,
    required String mobileNumber,
    required String vehicleNumber,
    required String barcode,
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
            'barcode': barcode,
            'vehicle_number': vehicleNumber,
            'mobile_number': mobileNumber,
            'start_date': startDate,
            'end_date': endDate,
            'vehicle_model': vehicleModelId,
            'vehicle_colr': vehicleColorlId,
            'emirates': emiratesId,
            'verified_in_outlet': outletId,
            'cva_in': cvaIn,
            'cva_out': cvaOut,
            'ticket_status': checkOutStatus,
            'parking_location': parkingLocationId,
            'location_user_id': locationUserId,
            'page': pageNo,
          },
          EndPoints.getAllTickets,
        );

        final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getTicketsWithCombinations Error :- $e');
      return null;
    }
  }

  // Now this is using instead of above individuals
  Future<GetAllTicketsResponse?> getAllTicketsWithCombinations({
    required String orderBy,
    required String orderByDirection, //ASC
    required String checkOutStatus,
    required int parkingLocationId,
    required int locationUserId,
    required int cvaOut,
    required int cvaIn,
    required int outletId,
    required int emiratesId,
    required int vehicleColorlId,
    required int vehicleModelId,
    required String startDate,
    required String endDate,
    required String mobileNumber,
    required String vehicleNumber,
    required String barcode,
    // required int pageNo,
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
            'barcode': barcode,
            'vehicle_number': vehicleNumber,
            'mobile_number': mobileNumber,
            'start_date': startDate,
            'end_date': endDate,
            'vehicle_model': vehicleModelId,
            'vehicle_colr': vehicleColorlId,
            'emirates': emiratesId,
            'verified_in_outlet': outletId,
            'cva_in': cvaIn,
            'cva_out': cvaOut,
            'ticket_status': checkOutStatus,
            'parking_location': parkingLocationId,
            'location_user_id': locationUserId,
            // 'page': pageNo,
          },
          EndPoints.getAllTickets,
        );

        final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getTicketsWithCombinations Error :- $e');
      return null;
    }
  }

  // Only Barcode, plateNumber, mobileNumber
  Future<GetAllTicketsResponse?> getTicketsWithSearchKey({
    required String orderBy,
    required String orderByDirection, //ASC
    required String searchKey,
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
            'search_key': searchKey,
            'page': pageNo,
          },
          EndPoints.getAllTickets,
        );

        final respModel = GetAllTicketsResponse.fromJson(response!.data ?? {});
        return respModel;
      }
      return null;
    } catch (e) {
      Loader.hide();
      print('getTicketsWithSearchKey Error :- $e');
      return null;
    }
  }
}
