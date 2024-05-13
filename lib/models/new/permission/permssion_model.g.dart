// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'permssion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllPermissions _$GetAllPermissionsFromJson(Map<String, dynamic> json) => GetAllPermissions(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : (json['data'] as List<dynamic>?)?.map((e) => _$DataFromJson(e as Map<String, dynamic>)).toList(),
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      feeCollection: json['fee_collection'] as String?,
      ticketCheckin: json['ticket_checkin'] as String?,
      ticketRequest: json['ticket_request'] as String?,
      ticketOntheway: json['ticket_ontheway'] as String?,
      ticketCollectnow: json['ticket_collectnow'] as String?,
      ticketCheckout: json['ticket_checkout'] as String?,
      ticketEdit: json['ticket_edit'] as String?,
      ticketDelete: json['ticket_delete'] as String?,
      ticketMobilePrint: json['ticket_mobile_print'] as String?,
      report: json['report'] as String?,
      cashCheckin: json['cash_checkin'] as String?,
      cashCheckinEdit: json['cash_checkin_edit'] as String?,
      imageUpload: json['image_upload'] as String?,
    );
