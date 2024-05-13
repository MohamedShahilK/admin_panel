// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'car_brands_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCarBrandsModel _$GetCarBrandsModelFromJson(Map<String, dynamic> json) => GetCarBrandsModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      carImageBaseUrl: json['car_image_base_url'] as String?,
      carModels: json['car_models'] == null ? null : (json['car_models'] as List<dynamic>?)?.map((e) => _$CarModelsFromJson(e as Map<String, dynamic>)).toList(),
      carImages: json['car_images'] == null ? null : (json['car_images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      carColors: json['car_colors'] == null ? null : json['car_colors'] as Map<String, dynamic>?,
    );

CarModels _$CarModelsFromJson(Map<String, dynamic> json) => CarModels(
      modelId: json['model_id'] as int?,
      modelTitle: json['model_title'] as String?,
      modelStatus: json['model_status'] as String?,
    );
