// ignore_for_file: lines_longer_than_80_chars

import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_brands_model.g.dart';

@JsonSerializable()
class GetCarBrandsModel {
  GetCarBrandsModel({required this.status, required this.message, required this.data});

  factory GetCarBrandsModel.fromJson(Map<String, dynamic> json) => _$GetCarBrandsModelFromJson(json);

  final String? status;
  final String? message;
  final Data? data;
}

@JsonSerializable()
class Data {
  Data({required this.carImageBaseUrl, required this.carModels, required this.carImages, required this.carColors});
  final String? carImageBaseUrl;
  final List<CarModels>? carModels;
  final List<String>? carImages;
  final Map<String, dynamic>? carColors;
}

@JsonSerializable()
class CarModels {
  CarModels({required this.modelId, required this.modelTitle, required this.modelStatus});
  final int? modelId;
  final String? modelTitle;
  final String? modelStatus;
}
