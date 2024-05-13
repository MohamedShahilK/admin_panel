// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'ticket_generation_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketSettingsResponseModel _$TicketSettingsResponseModelFromJson(Map<String, dynamic> json) => TicketSettingsResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      locationId: json['location_id'] as int?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$TicketSettingsResponseModelToJson(
//         TicketSettingsResponseModel instance) =>
//     <String, dynamic>{
//       'status': instance.status,
//       'message': instance.message,
//       'location_id': instance.locationId,
//       'data': _$DataToJson(instance.data),
//     };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      locationInfo: json['location_info'] == null ? null : _$LocationInfoFromJson(json['location_info'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'location_info': _$LocationInfoToJson(instance.locationInfo),
//     };

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) => LocationInfo(
      // departmentId: json['department_id'] as int,
      // departmentName: json['department_name'] as String,
      // departmentParentId: json['department_parentId'] as int,
      // departmentUserType: json['department_user_type'] as String,
      // departmentUsername: json['department_username'] as String,
      // departmentPassword: json['department_password'] as String,
      // departmentStatus: json['department_status'] as String,
      // verificationFor: json['verification_for'] as String?,
      // allowedVerification: json['allowed_verification'] as String,
      // departmentAvgWaitTime: json['department_avg_wait_time'] as String,
      // departmentMakeItFree: json['department_make_it_free'] as String,
      // enableFeeCollection: json['enable_fee_collection'] as String,
      // outletUserType: json['outlet_user_type'] as String?,
      // outletPostId: json['outlet_post_id'] as int,
      // enableManualValidation: json['enable_manual_validation'] as String,
      // permissionBtnRequested: json['permission_btn_requested'] as String,
      // permissionBtnOntheway: json['permission_btn_ontheway'] as String,
      // permissionBtnCollectnow: json['permission_btn_collectnow'] as String,
      // permissionBtnCheckout: json['permission_btn_checkout'] as String,
      // setUserAsManager: json['set_user_as_manager'] as String,
      // setNoteEntryRequired: json['set_note_entry_required'] as String,
      // permissionForEditTicket: json['permission_for_edit_ticket'] as String,
      // permissionForDeleteTicket: json['permission_for_delete_ticket'] as String,
      // permissionMobilePrint: json['permission_mobile_print'] as String,
      // permissionForReport: json['permission_for_report'] as String,
      barcodeMinLength: json['barcode_min_length'] as int?,
      barcodeMaxLength: json['barcode_max_length'] as int?,
      // permissionCashCheckin: json['permission_cash_checkin'] as String,
      // cashCheckinDefaultValue: json['cash_checkin_default_value'] as String,
      // permissionCheckinAmountEditable:
      //     json['permission_checkin_amount_editable'] as String,
      // permissionCheckoutpageFilter:
      //     json['permission_checkoutpage_filter'] as String,
      // permissionForVehicleImgUpload:
      //     json['permission_for_vehicle_img_upload'] as String,
      // permissionVehicleImgDelete:
      //     json['permission_vehicle_img_delete'] as String,
      // requestedVehicleWaitTime: json['requested_vehicle_wait_time'] as int,
      // requestingVehicleInfoNote: json['requesting_vehicle_info_note'] as String,
      // checkinUserInfoNote: json['checkin_user_info_note'] as String,
    );

Map<String, dynamic> _$LocationInfoToJson(LocationInfo instance) => <String, dynamic>{
      // 'department_id': instance.departmentId,
      // 'department_name': instance.departmentName,
      // 'department_parentId': instance.departmentParentId,
      // 'department_user_type': instance.departmentUserType,
      // 'department_username': instance.departmentUsername,
      // 'department_password': instance.departmentPassword,
      // 'department_status': instance.departmentStatus,
      // 'verification_for': instance.verificationFor,
      // 'allowed_verification': instance.allowedVerification,
      // 'department_avg_wait_time': instance.departmentAvgWaitTime,
      // 'department_make_it_free': instance.departmentMakeItFree,
      // 'enable_fee_collection': instance.enableFeeCollection,
      // 'outlet_user_type': instance.outletUserType,
      // 'outlet_post_id': instance.outletPostId,
      // 'enable_manual_validation': instance.enableManualValidation,
      // 'permission_btn_requested': instance.permissionBtnRequested,
      // 'permission_btn_ontheway': instance.permissionBtnOntheway,
      // 'permission_btn_collectnow': instance.permissionBtnCollectnow,
      // 'permission_btn_checkout': instance.permissionBtnCheckout,
      // 'set_user_as_manager': instance.setUserAsManager,
      // 'set_note_entry_required': instance.setNoteEntryRequired,
      // 'permission_for_edit_ticket': instance.permissionForEditTicket,
      // 'permission_for_delete_ticket': instance.permissionForDeleteTicket,
      // 'permission_mobile_print': instance.permissionMobilePrint,
      // 'permission_for_report': instance.permissionForReport,
      'barcode_min_length': instance.barcodeMinLength,
      'barcode_max_length': instance.barcodeMaxLength,
      // 'permission_cash_checkin': instance.permissionCashCheckin,
      // 'cash_checkin_default_value': instance.cashCheckinDefaultValue,
      // 'permission_checkin_amount_editable':
      //     instance.permissionCheckinAmountEditable,
      // 'permission_checkoutpage_filter': instance.permissionCheckoutpageFilter,
      // 'permission_for_vehicle_img_upload':
      //     instance.permissionForVehicleImgUpload,
      // 'permission_vehicle_img_delete': instance.permissionVehicleImgDelete,
      // 'requested_vehicle_wait_time': instance.requestedVehicleWaitTime,
      // 'requesting_vehicle_info_note': instance.requestingVehicleInfoNote,
      // 'checkin_user_info_note': instance.checkinUserInfoNote,
    };
