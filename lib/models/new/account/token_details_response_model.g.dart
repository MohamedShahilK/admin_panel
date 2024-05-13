// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTokenDetailsResponse _$GetTokenDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    GetTokenDetailsResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => _$DataFromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetTokenDetailsResponseToJson(
        GetTokenDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      userId: json['userId'] as int?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      locationId: json['locationId'] as int?,
      userCategory: json['userCategory'] as String?,
      userType: json['userType'] as String?,
      permissions: json['permissions'] == null
          ? null
          : _$PermissionsFromJson(json['permissions'] as Map<String, dynamic>),
      iat: json['iat'] as int?,
      exp: json['exp'] as int?,
      locationName: json['locationName'] as String?,
      operatorId: json['OPERATOR_ID'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'username': instance.username,
      'locationId': instance.locationId,
      'userCategory': instance.userCategory,
      'userType': instance.userType,
      'permissions': instance.permissions,
      'iat': instance.iat,
      'exp': instance.exp,
    };

Permissions _$PermissionsFromJson(Map<String, dynamic> json) => Permissions(
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

Map<String, dynamic> _$PermissionsToJson(Permissions instance) =>
    <String, dynamic>{
      'feeCollection': instance.feeCollection,
      'ticketCheckin': instance.ticketCheckin,
      'ticketRequest': instance.ticketRequest,
      'ticketOntheway': instance.ticketOntheway,
      'ticketCollectnow': instance.ticketCollectnow,
      'ticketCheckout': instance.ticketCheckout,
      'ticketEdit': instance.ticketEdit,
      'ticketDelete': instance.ticketDelete,
      'ticketMobilePrint': instance.ticketMobilePrint,
      'report': instance.report,
      'cashCheckin': instance.cashCheckin,
      'cashCheckinEdit': instance.cashCheckinEdit,
      'imageUpload': instance.imageUpload,
    };
