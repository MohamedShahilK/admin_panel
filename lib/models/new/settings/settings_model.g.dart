// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSettingsModel _$GetSettingsModelFromJson(Map<String, dynamic> json) => GetSettingsModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$GetSettingsModelToJson(GetSettingsModel instance) =>
//     <String, dynamic>{
//       'status': instance.status,
//       'message': instance.message,
//       'data': instance.data,
//     };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      cURRENCY: json['CURRENCY'] as String?,
      rECORDSPERPAGE: json['RECORDS_PER_PAGE'] as int?,
      rEQUESTEDNOTIFICATION: json['REQUESTED_NOTIFICATION'] as String?,
      oNTHEWAYNOTIFICATION: json['ONTHEWAY_NOTIFICATION'] as String?,
      appEndDate: json['APP_END_DATE'] as String?,
      commonScrollMessage: json['COMMON_SCROLL_MESSAGE'] as String?,
      scrollMessage: json['SCROLL_MESSAGE'] as String?,
      appMaintenanceMode: json['APP_MAINTENANCE_MODE'] as String?,
      maintenanceMode: json['MAINTENANCE_MODE'] as String?,
      timezoneRegion: json['TZ'] as String?,
      companyUrl: json['COMPANY_URL'] as String?,
    );

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'cURRENCY': instance.cURRENCY,
//       'rECORDSPERPAGE': instance.rECORDSPERPAGE,
//       'rEQUESTEDNOTIFICATION': instance.rEQUESTEDNOTIFICATION,
//       'oNTHEWAYNOTIFICATION': instance.oNTHEWAYNOTIFICATION,
//     };
