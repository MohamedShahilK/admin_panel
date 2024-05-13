// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'change_pass_response_model.g.dart';

@JsonSerializable()
class ChangePasswordResponseModel {
  ChangePasswordResponseModel({required this.status, required this.message, required this.data});

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) => _$ChangePasswordResponseModelFromJson(json);

  final String? status;
  final String? message;
  final Data? data;

  Map<String, dynamic> toJson() => _$ChangePasswordResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({required this.userId});
  final int? userId;
}
