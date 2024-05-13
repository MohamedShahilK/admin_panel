// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthErrorResponseModel _$AuthErrorResponseModelFromJson(
        Map<String, dynamic> json) =>
    AuthErrorResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AuthErrorResponseModelToJson(
        AuthErrorResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'errors': instance.errors,
    };
