// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/actions/actions_response_model.dart';
import 'package:admin_panel/models/new/actions/checkin/checkin_responce_model.dart';
import 'package:admin_panel/models/new/actions/checkout_form/all_checkout_items.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart' as tdrm;
// ignore: unused_import
import 'package:admin_panel/models/new/actions/ticket_models/ticket_generation_settings_model.dart';
import 'package:admin_panel/models/new/permission/permssion_model.dart';
import 'package:admin_panel/models/new/status/change_status_response.dart';
import 'package:admin_panel/services/actions/actions_services.dart';


class ActionsBloc {
  ActionsBloc() {
    initDetails();
  }
  final barcodeStream = BehaviorSubject<String>.seeded('');
  final barcodeStreamError = BehaviorSubject<String>.seeded('');

  final ticketIdStream = BehaviorSubject<String>.seeded('');
  final ticketIdStreamError = BehaviorSubject<String>.seeded('');

  final getAllCheckInItemsStream = BehaviorSubject<ActionsResponseModel?>();
  final getAllCheckOutItemsStream = BehaviorSubject<AllCheckOutItemsResponse?>();
  final checkInSubmitResponse = BehaviorSubject<CheckInSubmitResponseModel?>();
  final ticketDetailsResponse = BehaviorSubject<tdrm.TicketDetailsResponseModel?>();
  final getAllPermissionStream = BehaviorSubject<GetAllPermissions?>();

  final adjustmentAmtOfOthers = BehaviorSubject<String?>();

  // final getCheckoutTickInfo = BehaviorSubject<tdrm.TicketInfo?>();
  // final ticketSettingsResponse =
  //     BehaviorSubject<TicketSettingsResponseModel?>();

  Future<void> initDetails() async {
    await getAllCheckInItems();
    await getAllPermissions();
    await ticketGenerationSettings();
  }

  Future<bool> checkValidation() async {
    final minValue = StorageServices.to.getInt(StorageServicesKeys.minValue);
    final maxValue = StorageServices.to.getInt(StorageServicesKeys.maxValue);
    var isValid = true;
    // if (barcodeStream.value.isEmpty) {
    //   isValid = false;
    //   barcodeStreamError.add('Please provide barcode');
    // } else if (barcodeStream.value.length < minValue) {
    //   isValid = false;
    //   barcodeStreamError.add('Please enter atleast $minValue digit barcode');
    // } else if (barcodeStream.value.length > maxValue) {
    //   isValid = false;
    //   barcodeStreamError.add('Maximum Length Exceeded ($maxValue in length)');
    // } else {
    //   barcodeStreamError.add('');
    // }

    if (barcodeStream.value.isEmpty) {
      isValid = false;
      barcodeStreamError.add('Please provide barcode');
    } else if (barcodeStream.value.length < minValue) {
      isValid = false;
      barcodeStreamError.add('Please enter atleast $minValue digit barcode');
    } else {
      barcodeStreamError.add('');
    }
    return isValid;
  }

  Future<void> getAllCheckInItems() async {
    // getAllCheckInItemsStream.add(null);
    final respModel = await ActionsServices().getAllCheckInItems();
    // return respModel;
    getAllCheckInItemsStream.add(respModel);
  }

  Future<void> getAllCheckOutItems({int? id}) async {
    // getAllCheckOutItemsStream.add(null);
    final respModel = await ActionsServices().getAllCheckOutItems(id: id);
    // return respModel;
    print('222222222222222222222 $respModel');
    getAllCheckOutItemsStream.add(respModel);
  }

  // Check In Submit
  Future<void> checkInSubmit({
    required String ticketNumber,
  }) async {
    checkInSubmitResponse.add(null);
    final respModel = await ActionsServices().checkInSubmit(ticketNumber: ticketNumber);
    checkInSubmitResponse.add(respModel);
  }

  // Check Ticket Exists or Not
  Future<bool> checkTicketExists({required String ticketNumber}) async {
    return ActionsServices().checkTicketExists(ticketNumber: ticketNumber);
  }

  // Settings for ticket generation
  Future<void> ticketGenerationSettings() async {
    final respModel = await ActionsServices().ticketGenerationSettings();
    // ticketSettingsResponse.add(respModel);
    final minValue = respModel?.data?.locationInfo?.barcodeMinLength;
    final maxValue = respModel?.data?.locationInfo?.barcodeMaxLength;

    await StorageServices.to.setInt(StorageServicesKeys.minValue, minValue ?? 0);
    await StorageServices.to.setInt(StorageServicesKeys.maxValue, maxValue ?? 0);
  }

  // get Ticket details
  Future<void> getTicketDetails({required String ticketNumber}) async {
    final respModel = await ActionsServices().getTicketDetails(ticketNumber: ticketNumber);
    ticketDetailsResponse.add(respModel);
  }

  // providing status is true or false
  Future<bool> isStatusTrue({required String ticketNumber, required String status}) async {
    return ActionsServices().isStatusTrue(ticketNumber: ticketNumber, status: status);
  }

  // Change Ticket Status
  Future<ChangeStatusResponse?> changeTicketStatus({required int id, required String status}) async {
    return ActionsServices().changeTicketStatus(id: id, status: status);
  }

  Future<void> getAllPermissions() async {
    final respModel = await ActionsServices().getAllPermissions();
    getAllPermissionStream.add(respModel);
  }

  Future<void> getOneCheckoutTicket({required String ticketId}) async {
    final respModel = await ActionsServices().getOneCheckoutTicket(ticketId: ticketId);
    // return respModel;
    // getCheckoutTickInfo.add(respModel);
    // return respModel;
    ticketDetailsResponse.add(respModel);
  }

  void dispose() {
    barcodeStream.close();
    getAllCheckInItemsStream.close();
    barcodeStreamError.close();
    ticketIdStream.close();
    ticketIdStreamError.close();
    getAllCheckOutItemsStream.close();
    checkInSubmitResponse.close();
    ticketDetailsResponse.close();
    getAllPermissionStream.close();
    adjustmentAmtOfOthers.close();
  }
}
