// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_panel/models/new/user/user_model.dart';
import 'package:admin_panel/screens/report/ticket.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/actions/actions_response_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/services/actions/actions_services.dart';
import 'package:admin_panel/services/dashboard/dashboard_services.dart';
import 'package:admin_panel/services/search/search_services.dart';
// import 'package:admin_panel/view/report/sub_pages/ticket.dart';

class CashCollectionBloc {
  CashCollectionBloc() {
    initDetails();
  }

  final mainSearchStream = BehaviorSubject<String>.seeded('');

  final getAllCheckInItemsStream = BehaviorSubject<ActionsResponseModel?>();
  final getTicketRespStream = BehaviorSubject<GetAllTicketsResponse?>();
  final getAllTicketsRespStream = BehaviorSubject<GetAllTicketsResponse?>();

  final getUsersWithLocationStream = BehaviorSubject<GetUsersModel?>();

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

  Future<void> initDetails() async {
    // await getAllTickets(orderBy: 'id');
  }
  
  // Future<GetUsersModel?> getUsersWithLocation({
  //   required String orderBy,
  //   required int locationId,
  //   String orderByDirection = 'DESC', //ASC
  //   bool modelRequired = false,
  // }) async {
  //   getUsersWithLocationStream.add(null);
  //   final respModel = await DashBoardServices().getUsersWithLocation(orderBy: orderBy, orderByDirection: orderByDirection, locationId: locationId);
  //   if (modelRequired) {
  //     return respModel;
  //   } else {
  //     getUsersWithLocationStream.add(respModel);
  //     return null;
  //   }
  // }

  Future<GetAllTicketsResponse?> getAllTickets({
    required String orderBy,
    String orderByDirection = 'DESC', //ASC
    bool modelRequired = false,
  }) async {
    final respModel = await DashBoardServices().getAllTickets(orderBy: orderBy, orderByDirection: orderByDirection);
    if (modelRequired) {
      return respModel;
    } else {
      getAllTicketsRespStream.add(respModel);
      return null;
    }
  }

  Future<bool> getAllTicketsWithPageNo({
    required String orderBy,
    required int pageNo,
    bool modelRequired = false,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getAllTicketsWithPageNo(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    // getTicketRespStream.add(null); // to show reload
    Future.delayed(const Duration(milliseconds: 500), () {
      getTicketRespStream.add(respModel);
    });
    return isNewPageLoading;
  }

  Future<GetAllTicketsResponse?> getTicketsWithSearchKey({
    required String orderBy,
    required String searchKey,
    required int pageNo,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await SearchServices().getTicketsWithSearchKey(orderBy: orderBy, orderByDirection: orderByDirection, searchKey: searchKey, pageNo: pageNo);
    return respModel;
  }

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

  Future<GetAllTicketsResponse?> getAllTicketsWithCombinations({
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
    // required int pageNo,
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
    final respModel = await SearchServices().getAllTicketsWithCombinations(
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
      // pageNo: pageNo,
    );
    return respModel;
  }

  Future<void> getAllCheckInItems() async {
    getAllCheckInItemsStream.add(null);
    final respModel = await ActionsServices().getAllCheckInItems();
    // return respModel;
    getAllCheckInItemsStream.add(respModel);
  }

  void clearSreams() {
    currentPageForTicket.value = 1;
    currentPageForTicket.notifyListeners();
    getAllCheckInItemsStream.add(null);
    getTicketRespStream.add(null);
    getAllTicketsRespStream.add(null);
    selectedStartDate.value = null;
    selectedStartDate.notifyListeners();
    selectedEndDate.value = null;
    selectedEndDate.notifyListeners();
    mainSearchStream.add('');
    // barcodeStream.add('');
    // plateNumberStream.add('');
    // mobileNumberStream.add('');
    // vehicleModelStream.add('');
    // vehicleColorStream.add('');
    // vehicleLocationStream.add('');
    // outletsStream.add('');
    // statusStream.add('');
    // cvaInStream.add('');
    // cvaOutStream.add('');
    // print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm ${locationStream.value}');
    locationStream.add('');
    userTypeStream.add('');
    ticketListNotifier.add([]);
    filterValue.add('');
  }

  void dispose() {
    getAllCheckInItemsStream.close();
    getTicketRespStream.close();
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
