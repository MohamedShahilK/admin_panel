// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'change_pass_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordResponseModel _$ChangePasswordResponseModelFromJson(
  Map<String, dynamic> json,
) =>
    ChangePasswordResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChangePasswordResponseModelToJson(ChangePasswordResponseModel instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      userId: json['user_id'] as int?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'user_id': instance.userId,
    };
