// ignore_for_file: lines_longer_than_80_chars

import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/actions/actions_response_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/user/user_model.dart';
import 'package:admin_panel/services/actions/actions_services.dart';
import 'package:admin_panel/services/dashboard/dashboard_services.dart';
import 'package:admin_panel/services/search/search_services.dart';

class SearchBloc {
  SearchBloc() {
    initDetails();
  }

  Future<void> initDetails() async {
    // await getAllTickets(orderBy: 'create_date');
    // await getAllTickets(orderBy: 'parking_time');
    await getAllCheckInItems();
    await getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: 1);
  }

  final getAllCheckInItemsStream = BehaviorSubject<ActionsResponseModel?>();

  final getAllTicketsRespStream = BehaviorSubject<GetAllTicketsResponse?>();
  final getUsersWithLocationStream = BehaviorSubject<GetUsersModel?>();

  final mainSearchStream = BehaviorSubject<String>.seeded('');

  final barcodeStream = BehaviorSubject<String>.seeded('');
  final plateNumberStream = BehaviorSubject<String>.seeded('');
  final mobileNumberStream = BehaviorSubject<String>.seeded('');

  final vehicleModelStream = BehaviorSubject<String>.seeded('');
  final vehicleColorStream = BehaviorSubject<String>.seeded('');
  final vehicleLocationStream = BehaviorSubject<String>.seeded('');
  final outletsStream = BehaviorSubject<String>.seeded('');
  final statusStream = BehaviorSubject<String>.seeded('');
  final cvaInStream = BehaviorSubject<String>.seeded('');
  final cvaOutStream = BehaviorSubject<String>.seeded('');
  final locationStream = BehaviorSubject<String>.seeded('');
  final userTypeStream = BehaviorSubject<String>.seeded('');

  Future<void> getAllCheckInItems() async {
    getAllCheckInItemsStream.add(null);
    final respModel = await ActionsServices().getAllCheckInItems();
    // return respModel;
    getAllCheckInItemsStream.add(respModel);
  }

  // Future<GetAllTicketsResponse?> getAllTickets({
  //   required String orderBy,
  //   String orderByDirection = 'DESC', //ASC
  //   bool modelRequired = false,
  // }) async {

  //   final respModel = await DashBoardServices().getAllTickets(orderBy: orderBy, orderByDirection: orderByDirection);
  //   if (modelRequired) {
  //     return respModel;
  //   } else {
  //     getAllTicketsRespStreamWithoutPageNo.add(respModel);
  //     return null;
  //   }
  // }

  //   Future<GetAllTicketsResponse?> getAllTicketsWithLocation({
  //   required String orderBy,
  //   required int locationId,
  //   String orderByDirection = 'DESC', //ASC
  //   bool modelRequired = false,
  // }) async {
  //   getAllTicketsRespStreamWithoutPageNo.add(null);
  //   final respModel = await DashBoardServices().getAllTicketsWithLocation(orderBy: orderBy, orderByDirection: orderByDirection,locationId: locationId);
  //   if (modelRequired) {
  //     return respModel;
  //   } else {
  //     getAllTicketsRespStreamWithoutPageNo.add(respModel);
  //     return null;
  //   }
  // }

  Future<GetUsersModel?> getUsersWithLocation({
    required String orderBy,
    required int locationId,
    String orderByDirection = 'DESC', //ASC
    bool modelRequired = false,
  }) async {
    getUsersWithLocationStream.add(null);
    final respModel = await DashBoardServices().getUsersWithLocation(orderBy: orderBy, orderByDirection: orderByDirection, locationId: locationId);
    if (modelRequired) {
      return respModel;
    } else {
      getUsersWithLocationStream.add(respModel);
      return null;
    }
  }

  Future<GetUsersModel?> getUsersAllLocationAndUsers({
    required String orderBy,
    String orderByDirection = 'DESC', //ASC
  }) async {
    getUsersWithLocationStream.add(null);
    final respModel = await DashBoardServices().getUsersAllLocationAndUsers(orderBy: orderBy, orderByDirection: orderByDirection);

    return respModel;
  }

  Future<bool> getAllTicketsWithPageNo({
    required String orderBy,
    required int pageNo,
    bool modelRequired = false,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getAllTicketsWithPageNo(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    // getAllTicketsRespStream.add(null); // to show reload
    Future.delayed(const Duration(milliseconds: 500), () {
      getAllTicketsRespStream.add(respModel);
    });
    return isNewPageLoading;
  }

  // Future<GetAllTicketsResponse?> getTicketWithBarcode({
  //   required String orderBy,
  //   required String barcode,
  //   String orderByDirection = 'DESC', //ASC
  //   // bool modelRequired = false,
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, barcode: barcode);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketWithVehiclNumber({
  //   required String orderBy,
  //   required String vehicleNumber,
  //   String orderByDirection = 'DESC', //ASC
  //   // bool modelRequired = false,
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, vehicleNumber: vehicleNumber);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketWithMobileNumber({
  //   required String orderBy,
  //   required String mobileNumber,
  //   String orderByDirection = 'DESC', //ASC
  //   // bool modelRequired = false,
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, mobileNumber: mobileNumber);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithStartAndEndDates({
  //   required String orderBy,
  //   required String startDate,
  //   required String endDate,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, startDate: startDate, endDate: endDate);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithVehicleModel({
  //   required String orderBy,
  //   required int vehicleModelId,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, vehicleModelId: vehicleModelId);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithVehicleColor({
  //   required String orderBy,
  //   required int vehicleColorId,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, vehicleColorlId: vehicleColorId);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithEmirates({
  //   required String orderBy,
  //   required int emiratesId,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, emiratesId: emiratesId);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithOutlets({
  //   required String orderBy,
  //   required int outletId,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, outletId: outletId);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithCvaIn({
  //   required String orderBy,
  //   required int cvaIn,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, cvaIn: cvaIn);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithCvaOut({
  //   required String orderBy,
  //   required int cvaOut,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, cvaOut: cvaOut);
  //   return respModel;
  // }

  Future<GetAllTicketsResponse?> getTicketsWithSearchKey({
    required String orderBy,
    required String searchKey,
    required int pageNo,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await SearchServices().getTicketsWithSearchKey(orderBy: orderBy, orderByDirection: orderByDirection, searchKey: searchKey, pageNo: pageNo);
    return respModel;
  }

  // Future<GetAllTicketsResponse?> getTicketsWithLocationAndUserType({
  //   required String orderBy,
  //   required int parkingLocationId,
  //   required int locationUserId,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices()
  //       .getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, parkingLocationId: parkingLocationId, locationUserId: locationUserId);
  //   return respModel;
  // }

  // Future<GetAllTicketsResponse?> getTicketsWithLocation({
  //   required String orderBy,
  //   required int parkingLocationId,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, parkingLocationId: parkingLocationId);
  //   return respModel;
  // }

  //   Future<GetAllTicketsResponse?> getTicketsWithCheckoutStatus({
  //   required String orderBy,
  //   required String checkoutStatus,
  //   String orderByDirection = 'DESC', //ASC
  // }) async {
  //   final respModel = await SearchServices().getTicketsWithCombinations(orderBy: orderBy, orderByDirection: orderByDirection, checkOutStatus: checkoutStatus);
  //   return respModel;
  // }

  Future<GetAllTicketsResponse?> getTicketsWithCombinations({
    required String orderBy,
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
    // String checkOutStatus = '',
    // int parkingLocationId = 0,
    // int locationUserId = 0,
    // int cvaOut = 0,
    // int cvaIn = 0,
    // int outletId = 0,
    // int emiratesId = 0,
    // int vehicleColorlId = 0,
    // int vehicleModelId = 0,
    // String startDate = '',
    // String endDate = '',
    // String mobileNumber = '',
    // String vehicleNumber = '',
    // String barcode = '',
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await SearchServices().getTicketsWithCombinations(
      orderBy: orderBy,
      orderByDirection: orderByDirection,
      checkOutStatus: checkOutStatus,
      parkingLocationId: parkingLocationId,
      locationUserId: locationUserId,
      cvaOut: cvaOut,
      cvaIn: cvaIn,
      outletId: outletId,
      emiratesId: emiratesId,
      vehicleColorlId: vehicleColorlId,
      vehicleModelId: vehicleModelId,
      startDate: startDate,
      endDate: endDate,
      mobileNumber: mobileNumber,
      vehicleNumber: vehicleNumber,
      barcode: barcode,
      pageNo: pageNo,
    );
    return respModel;
  }

  void clearSreams() {
    getAllCheckInItemsStream.add(null);
    getAllTicketsRespStream.add(null);
    mainSearchStream.add('');
    barcodeStream.add('');
    plateNumberStream.add('');
    mobileNumberStream.add('');
    vehicleModelStream.add('');
    vehicleColorStream.add('');
    vehicleLocationStream.add('');
    outletsStream.add('');
    statusStream.add('');
    cvaInStream.add('');
    cvaOutStream.add('');
    locationStream.add('');
    userTypeStream.add('');
  }

  void dispose() {
    getAllCheckInItemsStream.close();
    getAllTicketsRespStream.close();
    mainSearchStream.close();
    barcodeStream.close();
    plateNumberStream.close();
    mobileNumberStream.close();
    vehicleModelStream.close();
    vehicleColorStream.close();
    vehicleLocationStream.close();
    outletsStream.close();
    statusStream.close();
    cvaInStream.close();
    cvaOutStream.close();
    locationStream.close();
    userTypeStream.close();
  }
}
