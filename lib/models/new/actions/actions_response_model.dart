// ignore_for_file: lines_longer_than_80_chars

import 'package:freezed_annotation/freezed_annotation.dart';

part 'actions_response_model.g.dart';

@JsonSerializable()
class ActionsResponseModel {
  ActionsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });
  factory ActionsResponseModel.fromJson(Map<String, dynamic> json) => _$ActionsResponseModelFromJson(json);
  final String? status;
  final String? message;
  final Data? data;
  // Map<String, dynamic> toJson() => _$ActionsResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.carColors,
    required this.carModels,
    required this.guestTypes,
    required this.vehicleLocations,
    required this.cvas,
    required this.paymentMethod,
    required this.outlets,
  });
  final List<CarColors>? carColors;
  final List<CarModels>? carModels;
  final List<GuestTypes>? guestTypes;
  final List<VehicleLocations>? vehicleLocations;
  final List<Cvas>? cvas;
  final List<String>? paymentMethod;
  final List<Outlets>? outlets;
}

@JsonSerializable()
class CarColors {
  CarColors({
    required this.carId,
    required this.carTitle,
    required this.carStatus,
  });
  final int? carId;
  final String? carTitle;
  final String? carStatus;
}

@JsonSerializable()
class CarModels {
  CarModels({
    required this.modelId,
    required this.modelTitle,
    required this.modelStatus,
  });
  final int? modelId;
  final String? modelTitle;
  final String? modelStatus;
}

@JsonSerializable()
class GuestTypes {
  GuestTypes({
    required this.typeId,
    required this.typeName,
    required this.typeStatus,
  });
  final int? typeId;
  final String? typeName;
  final String? typeStatus;
}

@JsonSerializable()
class VehicleLocations {
  VehicleLocations({
    required this.vehicleLocationId,
    required this.vehicleLocationName,
    required this.vehicleLocationStatus,
  });
  final int? vehicleLocationId;
  final String? vehicleLocationName;
  final String? vehicleLocationStatus;
}

@JsonSerializable()
class Cvas {
  Cvas({required this.departmentId, required this.departmentName});
  final int? departmentId;
  final String? departmentName;
}

@JsonSerializable()
class Outlets{
  Outlets({
    required this.outletPostId,
    required this.outletPostName,
    required this.outletPostStatus,
    required this.addedOn,
  });
  final int? outletPostId;
  final String? outletPostName;
  final String? outletPostStatus;
  final String? addedOn;
}
