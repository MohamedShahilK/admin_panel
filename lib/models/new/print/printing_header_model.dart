// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'printing_header_model.g.dart';

@JsonSerializable()
class PrintingHeadingModel {
  PrintingHeadingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PrintingHeadingModel.fromJson(Map<String, dynamic> json) => _$PrintingHeadingModelFromJson(json);

  final String? status;
  final String? message;
  final Data? data;
}

@JsonSerializable()
class Data {
  Data({required this.printSettings});
  final PrintSettings? printSettings;
}

@JsonSerializable()
class PrintSettings {
  PrintSettings({
    required this.printsettingsId,
    required this.printsettingLocation,
    required this.printsettingsTitle1,
    required this.printsettingsTitle2,
    required this.printsettingsTrnNo,
    required this.printsettingsStatus,
    required this.printsettingsHeader,
    required this.printsettingsFooter,
    required this.printsettingAutoClose,
    required this.printsettingsLogo,
  });
  final int? printsettingsId;
  final int? printsettingLocation;
  final String? printsettingsTitle1;
  final String? printsettingsTitle2;
  final String? printsettingsTrnNo;
  final String? printsettingsStatus;
  final String? printsettingsHeader;
  final String? printsettingsFooter;
  final String? printsettingAutoClose;
  final String? printsettingsLogo;
}
