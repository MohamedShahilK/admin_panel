// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/utility_functions.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/logic/dashboard/dashboard_state.dart';
import 'package:admin_panel/models/new/all_checkin/all_checkin_response_model.dart';
import 'package:admin_panel/models/new/all_checkout/all_checkout_response_model.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/brands/car_brands_model.dart';
import 'package:admin_panel/models/new/print/printing_header_model.dart';
import 'package:admin_panel/models/new/settings/settings_model.dart';
import 'package:admin_panel/services/dashboard/dashboard_services.dart';

class DashboardBloc {
  DashboardBloc() {
    initDetails();
  }

  Future<void> initDetails() async {
    await getSettings();
    final userType = StorageServices.to.getString('userType');

    String userCat = userType == 'ADMIN' ? 'A' : userType;
    if (userCat == 'A' || userCat == 'ADMIN') {
      await getAllTickets(orderBy: 'id');
    }

    // Today Filter Default
    // final now = DateTime.now();
    // final todayStartDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    // final todayEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // final formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(todayStartDate);
    // final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(todayEndDate);

    // await getDashBoardAllTicketsWithDate(pageNo: 1, startDate: formattedStartDate, endDate: formattedEndDate);
    // Today Filter Default

    // Last 3 days Filter Default
    final now = DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime());

    // Calculate the first date of the 3-day period
    final firstDate = now.subtract(const Duration(days: 3));

    final formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(firstDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    await getDashBoardAllTicketsWithDate(pageNo: 1, startDate: formattedStartDate, endDate: formattedEndDate);

    final locationId = StorageServices.to.getInt('locationId');
    await getPrintingSettingsAndHeader(locationId: locationId);
    // Last 3 days Filter Default

    // await getDashBoardWithTicket(pageNo: 1);

    await getCheckInTickets(orderBy: 'id', pageNo: 1);
    await getCheckOutTickets(orderBy: 'id', pageNo: 1);
    await getRequestedTickets(orderBy: 'id', pageNo: 1);
    await getOntheWayTickets(orderBy: 'id', pageNo: 1);
    await getCollectNowTickets(orderBy: 'id', pageNo: 1);
    await getParkedTickets(orderBy: 'id', pageNo: 1);
    await getCarBrands();

    // Calling Settings
    await getSettings();

    // final FirebaseMessaging messaging = FirebaseMessaging.instance;
  }

  final state = DashboardState();

  final getAllCheckInTickets = BehaviorSubject<AllCheckInResponse?>();
  final getAllCheckOutTickets = BehaviorSubject<AllCheckOutResponse?>();
  final getAllRequestedTickets = BehaviorSubject<AllCheckOutResponse?>();
  final getAllOntheWayTickets = BehaviorSubject<AllCheckOutResponse?>();
  final getAllCollectNowTickets = BehaviorSubject<AllCheckOutResponse?>();
  final getAllParkedTickets = BehaviorSubject<AllCheckOutResponse?>();
  final carBrands = BehaviorSubject<GetCarBrandsModel?>();
  final printSettingsAndHeader = BehaviorSubject<PrintingHeadingModel?>();
  final getSettingsStream = BehaviorSubject<GetSettingsModel?>();

  Future<GetAllTicketsResponse?> getAllTickets({
    required String orderBy,
    String orderByDirection = 'DESC', //ASC
    bool modelRequired = false,
  }) async {
    final respModel = await DashBoardServices().getAllTickets(orderBy: orderBy, orderByDirection: orderByDirection);
    if (modelRequired) {
      return respModel;
    } else {
      state.getAllTicketsRespStream.add(respModel);
      return null;
    }
  }

  Future<void> getAllTicketsWithPageNo({
    required String orderBy,
    required int pageNo,
    bool modelRequired = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getAllTicketsWithPageNo(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    state.getAllTicketsRespStream.add(null);
    Future.delayed(const Duration(milliseconds: 500), () {
      state.getAllTicketsRespStream.add(respModel);
    });
  }

  // Future<DashBoardResponseModel?> getDashBoardWithTicket({
  //   required int pageNo,
  //   bool modelRequired = false,
  // }) async {
  //   final respModel = await DashBoardServices().getDashBoardWithTicket(pageNo: pageNo);
  //   if (modelRequired) {
  //     return respModel;
  //   } else {
  //     state.getDashRespStream.add(null);
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       state.getDashRespStream.add(respModel);
  //     });
  //     return null;
  //   }
  // }

  Future<bool> getDashBoardWithTicket({
    required int pageNo,
    bool isNewPageLoading = false,
  }) async {
    final respModel = await DashBoardServices().getDashBoardWithTicket(pageNo: pageNo);
    state.getDashRespStream.add(respModel);
    // if (respModel != null && respModel.locationId != null) {
    //   await StorageServices.to.setInt('locationId', respModel.locationId!);
    // }
    return isNewPageLoading;
  }

  Future<bool> getDashBoardAllTicketsWithDate({
    required int pageNo,
    required String startDate,
    required String endDate,
    bool isNewPageLoading = false,
  }) async {
    final respModel = await DashBoardServices().getDashBoardAllTicketsWithDate(pageNo: pageNo, startDate: startDate, endDate: endDate);
    state.getDashRespStream.add(respModel);
    // if (respModel != null && respModel.locationId != null) {
    //   await StorageServices.to.setInt('locationId', respModel.locationId!);
    // }

    // print('333333333333333333333333333 ${respModel?.totalPages}');
    return isNewPageLoading;
  }

  Future<bool> getCheckInTickets({
    required String orderBy,
    required int pageNo,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getCheckInTickets(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    getAllCheckInTickets.add(respModel);
    return isNewPageLoading;
  }

  Future<bool> getCheckOutTickets({
    required String orderBy,
    required int pageNo,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getCheckOutTickets(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    getAllCheckOutTickets.add(respModel);
    return isNewPageLoading;
  }

  Future<bool> getRequestedTickets({
    required String orderBy,
    required int pageNo,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getRequestedTickets(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    getAllRequestedTickets.add(respModel);
    return isNewPageLoading;
  }

  Future<bool> getOntheWayTickets({
    required String orderBy,
    required int pageNo,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getOnTheWayTickets(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    getAllOntheWayTickets.add(respModel);
    return isNewPageLoading;
  }

  Future<bool> getCollectNowTickets({
    required String orderBy,
    required int pageNo,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getCollectNowTickets(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    getAllCollectNowTickets.add(respModel);
    return isNewPageLoading;
  }

  Future<bool> getParkedTickets({
    required String orderBy,
    required int pageNo,
    bool isNewPageLoading = false,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await DashBoardServices().getParkedTickets(orderBy: orderBy, orderByDirection: orderByDirection, pageNo: pageNo);
    getAllParkedTickets.add(respModel);
    return isNewPageLoading;
  }

  Future<void> getCarBrands() async {
    final respModel = await DashBoardServices().getCarBrands();
    carBrands.add(respModel);
  }

  Future<void> getPrintingSettingsAndHeader({required int locationId}) async {
    // print('66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666');
    final respModel = await DashBoardServices().getPrintingSettingsAndHeader(locationId: locationId);
    printSettingsAndHeader.add(respModel);
  }

  Future<void> getSettings() async {
    final respModel = await DashBoardServices().getSettings();
    getSettingsStream.add(respModel);
    if (respModel != null) {
      await StorageServices.to.setString('appEndDate', respModel.data?.appEndDate ?? '');
      await StorageServices.to.setString('curreny', respModel.data?.cURRENCY ?? '');
      await StorageServices.to.setString('timezone', respModel.data?.timezoneRegion ?? '');
      await StorageServices.to.setString('companyUrl', respModel.data?.companyUrl ?? '');
      print('timezone : ${StorageServices.to.getString('timezone')}');
    }
  }

  void dispose() {
    state.dispose();
    getAllCheckInTickets.close();
    getAllCheckOutTickets.close();
    getAllRequestedTickets.close();
    getAllOntheWayTickets.close();
    getAllCollectNowTickets.close();
    getAllParkedTickets.close();
    carBrands.close();
    printSettingsAndHeader.close();
    getSettingsStream.close();
  }
}
