import 'package:json_annotation/json_annotation.dart';

part 'ticket_generation_settings_model.g.dart';

@JsonSerializable()
class TicketSettingsResponseModel {
  TicketSettingsResponseModel({
    required this.status,
    required this.message,
    required this.locationId,
    required this.data,
  });

  factory TicketSettingsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TicketSettingsResponseModelFromJson(json);

  final String? status;
  final String? message;
  final int? locationId;
  final Data? data;

  // Map<String, dynamic> toJson() => _$TicketSettingsResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({required this.locationInfo});
  LocationInfo? locationInfo;
}

@JsonSerializable()
class LocationInfo {
  LocationInfo({
    // required this.departmentId,
    // required this.departmentName,
    // required this.departmentParentId,
    // required this.departmentUserType,
    // required this.departmentUsername,
    // required this.departmentPassword,
    // required this.departmentStatus,
    // required this.verificationFor,
    // required this.allowedVerification,
    // required this.departmentAvgWaitTime,
    // required this.departmentMakeItFree,
    // required this.enableFeeCollection,
    // required this.outletUserType,
    // required this.outletPostId,
    // required this.enableManualValidation,
    // required this.permissionBtnRequested,
    // required this.permissionBtnOntheway,
    // required this.permissionBtnCollectnow,
    // required this.permissionBtnCheckout,
    // required this.setUserAsManager,
    // required this.setNoteEntryRequired,
    // required this.permissionForEditTicket,
    // required this.permissionForDeleteTicket,
    // required this.permissionMobilePrint,
    // required this.permissionForReport,
    required this.barcodeMinLength,
    required this.barcodeMaxLength,
    // required this.permissionCashCheckin,
    // required this.cashCheckinDefaultValue,
    // required this.permissionCheckinAmountEditable,
    // required this.permissionCheckoutpageFilter,
    // required this.permissionForVehicleImgUpload,
    // required this.permissionVehicleImgDelete,
    // required this.requestedVehicleWaitTime,
    // required this.requestingVehicleInfoNote,
    // required this.checkinUserInfoNote,
  });
  // final int departmentId;
  // final String departmentName;
  // final int departmentParentId;
  // final String departmentUserType;
  // final String? departmentUsername;
  // final String? departmentPassword;
  // final String departmentStatus;
  // final String? verificationFor;
  // final String? allowedVerification;
  // final String departmentAvgWaitTime;
  // final String departmentMakeItFree;
  // final String enableFeeCollection;
  // final String? outletUserType;
  // final int outletPostId;
  // final String enableManualValidation;
  // final String permissionBtnRequested;
  // final String permissionBtnOntheway;
  // final String permissionBtnCollectnow;
  // final String permissionBtnCheckout;
  // final String setUserAsManager;
  // final String setNoteEntryRequired;
  // final String permissionForEditTicket;
  // final String permissionForDeleteTicket;
  // final String permissionMobilePrint;
  // final String permissionForReport;
  final int? barcodeMinLength;
  final int? barcodeMaxLength;
  // final String permissionCashCheckin;
  // final String cashCheckinDefaultValue;
  // final String permissionCheckinAmountEditable;
  // final String permissionCheckoutpageFilter;
  // final String permissionForVehicleImgUpload;
  // final String permissionVehicleImgDelete;
  // final int requestedVehicleWaitTime;
  // final String requestingVehicleInfoNote;
  // final String checkinUserInfoNote;
}
