// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'ticket_exists_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketExistsResponseModel _$TicketExistsResponseModelFromJson(Map<String, dynamic> json) => TicketExistsResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      locationId: json['location_id'] as int?,
      ticketNumber: json['ticket_number'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$TicketExistsResponseModelToJson(
//         TicketExistsResponseModel instance) =>
//     <String, dynamic>{
//       'status': instance.status,
//       'message': instance.message,
//       'location_id': instance.locationId,
//       'ticket_number': instance.ticketNumber,
//       'data': _$DataToJson(instance.data),
//     };

Data? _$DataFromJson(Map<String, dynamic> json) => Data(
      ticketInfo:json['ticket_info'] == null ? null: json['ticket_info'] as List<dynamic>,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'ticket_info': instance.ticketInfo,
    };
