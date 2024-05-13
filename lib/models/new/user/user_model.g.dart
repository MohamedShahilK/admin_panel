// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUsersModel _$GetUsersModelFromJson(Map<String, dynamic> json) => GetUsersModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      locations: (json['locations'] as List<dynamic>?)?.map((e) => _$LocationsFromJson(e as Map<String, dynamic>)).toList(),
      users: (json['users'] as List<dynamic>?)?.map((e) => _$UsersFromJson(e as Map<String, dynamic>)).toList(),
    );

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      departmentId: json['department_Id'] as int?,
      departmentName: json['department_name'] as String?,
    );

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      departmentId: json['department_Id'] as int?,
      departmentName: json['department_name'] as String?,
    );
