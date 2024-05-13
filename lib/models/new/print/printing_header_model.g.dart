// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'printing_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintingHeadingModel _$PrintingHeadingModelFromJson(
  Map<String, dynamic> json,
) =>
    PrintingHeadingModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      printSettings: json['print_settings'] == null
          ? null
          : _$PrintSettingsFromJson(
              json['print_settings'] as Map<String, dynamic>,
            ),
    );

PrintSettings _$PrintSettingsFromJson(Map<String, dynamic> json) => PrintSettings(
      printsettingsId: json['printsettings_id'] as int?,
      printsettingLocation: json['printsetting_location'] as int?,
      printsettingsTitle1: json['printsettings_title_1'] as String?,
      printsettingsTitle2: json['printsettings_title_2'] as String?,
      printsettingsTrnNo: json['printsettings_trn_no'] as String?,
      printsettingsStatus: json['printsettings_status'] as String?,
      printsettingsHeader: json['printsettings_header'] as String?,
      printsettingsFooter: json['printsettings_footer'] as String?,
      printsettingAutoClose: json['printsetting_auto_close'] as String?,
      printsettingsLogo: json['printsettings_logo'] as String?,
    );
