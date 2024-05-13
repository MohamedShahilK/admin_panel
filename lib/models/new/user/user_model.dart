// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class GetUsersModel {
  GetUsersModel({required this.status, required this.message, required this.data});
  
  factory GetUsersModel.fromJson(Map<String, dynamic> json) => _$GetUsersModelFromJson(json);
  
  final String? status;
  final String? message;
  final Data? data;
}

@JsonSerializable()
class Data {
  Data({required this.locations, required this.users});
  final List<Locations>? locations;
  final List<Users>? users;
}

@JsonSerializable()
class Locations {
  Locations({required this.departmentId, required this.departmentName});
  int? departmentId;
  final String? departmentName;
}

@JsonSerializable()
class Users {
  Users({required this.departmentId, required this.departmentName});
  int? departmentId;
  final String? departmentName;
}
