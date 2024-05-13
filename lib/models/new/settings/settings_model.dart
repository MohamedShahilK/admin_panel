// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class GetSettingsModel {
  GetSettingsModel({required this.status, required this.message, required this.data});

  factory GetSettingsModel.fromJson(Map<String, dynamic> json) => _$GetSettingsModelFromJson(json);

  final String? status;
  final String? message;
  final Data? data;
}

@JsonSerializable()
class Data {
  Data({
    required this.cURRENCY,
    required this.rECORDSPERPAGE,
    required this.rEQUESTEDNOTIFICATION,
    required this.oNTHEWAYNOTIFICATION,
    required this.appEndDate,
    required this.commonScrollMessage,
    required this.scrollMessage,
    required this.appMaintenanceMode,
    required this.maintenanceMode,
    required this.timezoneRegion,
    required this.companyUrl,
  });
  final String? cURRENCY;
  final int? rECORDSPERPAGE;
  final String? rEQUESTEDNOTIFICATION;
  final String? oNTHEWAYNOTIFICATION;
  final String? appEndDate;
  final String? commonScrollMessage;
  final String? scrollMessage;
  final String? appMaintenanceMode;
  final String? maintenanceMode;
  final String? timezoneRegion;
  final String? companyUrl;
}
