// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'actions_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionsResponseModel _$ActionsResponseModelFromJson(Map<String, dynamic> json) => ActionsResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data:json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$ActionsResponseModelToJson(ActionsResponseModel instance) => <String, dynamic>{
//       'status': instance.status,
//       'message': instance.message,
//       'data': _$DataToJson(instance.data),
//     };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      carColors:json['car_colors'] ==null ?null : (json['car_colors'] as List<dynamic>).map((e) => _$CarColorsFromJson(e as Map<String, dynamic>)).toList(),
      carModels:json['car_models'] ==null ?null : (json['car_models'] as List<dynamic>).map((e) => _$CarModelsFromJson(e as Map<String, dynamic>)).toList(),
      guestTypes: json['guest_types'] ==null ?null :(json['guest_types'] as List<dynamic>).map((e) => _$GuestTypesFromJson(e as Map<String, dynamic>)).toList(),
      vehicleLocations:json['vehicle_locations'] ==null ?null : (json['vehicle_locations'] as List<dynamic>).map((e) => _$VehicleLocationsFromJson(e as Map<String, dynamic>)).toList(),
      cvas: json['cvas'] ==null ?null :(json['cvas'] as List<dynamic>).map((e) => _$CvasFromJson(e as Map<String, dynamic>)).toList(),
      paymentMethod:json['payment_method'] ==null ?null : (json['payment_method'] as List<dynamic>).map((e) => e as String).toList(),
      outlets:json['outlets'] ==null ?null : (json['outlets'] as List<dynamic>).map((e) => _$OutletsFromJson(e as Map<String, dynamic>)).toList(),
    );

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'car_colors': instance.carColors.map(_$CarColorsToJson).toList(),
//       'car_models': instance.carModels.map(_$CarModelsToJson).toList(),
//       'guest_types': instance.guestTypes.map(_$GuestTypesToJson).toList(),
//       'vehicle_locations': instance.vehicleLocations.map(_$VehicleLocationsToJson).toList(),
//       'cvas': instance.cvas.map(_$CvasToJson).toList(),
//       'payment_method': instance.paymentMethod,
//     };

CarColors _$CarColorsFromJson(Map<String, dynamic> json) => CarColors(
      carId: json['car_id'] as int?,
      carTitle: json['car_title'] as String?,
      carStatus: json['car_status'] as String?,
    );

Map<String, dynamic> _$CarColorsToJson(CarColors instance) => <String, dynamic>{
      'car_id': instance.carId,
      'car_title': instance.carTitle,
      'car_status': instance.carStatus,
    };

CarModels _$CarModelsFromJson(Map<String, dynamic> json) => CarModels(
      modelId: json['model_id'] as int?,
      modelTitle: json['model_title'] as String?,
      modelStatus: json['model_status'] as String?,
    );

Map<String, dynamic> _$CarModelsToJson(CarModels instance) => <String, dynamic>{
      'model_id': instance.modelId,
      'model_title': instance.modelTitle,
      'model_status': instance.modelStatus,
    };

GuestTypes _$GuestTypesFromJson(Map<String, dynamic> json) => GuestTypes(
      typeId: json['type_id'] as int?,
      typeName: json['type_name'] as String?,
      typeStatus: json['type_status'] as String?,
    );

Map<String, dynamic> _$GuestTypesToJson(GuestTypes instance) => <String, dynamic>{
      'type_id': instance.typeId,
      'type_name': instance.typeName,
      'type_status': instance.typeStatus,
    };

VehicleLocations _$VehicleLocationsFromJson(Map<String, dynamic> json) => VehicleLocations(
      vehicleLocationId: json['vehicle_location_id'] as int?,
      vehicleLocationName: json['vehicle_location_name'] as String?,
      vehicleLocationStatus: json['vehicle_location_status'] as String?,
    );

Map<String, dynamic> _$VehicleLocationsToJson(VehicleLocations instance) => <String, dynamic>{
      'vehicle_location_id': instance.vehicleLocationId,
      'vehicle_location_name': instance.vehicleLocationName,
      'vehicle_location_status': instance.vehicleLocationStatus,
    };

Cvas _$CvasFromJson(Map<String, dynamic> json) => Cvas(
      departmentId: json['department_Id'] as int?,
      departmentName: json['department_name'] as String?,
    );

Map<String, dynamic> _$CvasToJson(Cvas instance) => <String, dynamic>{
      'department_Id': instance.departmentId,
      'department_name': instance.departmentName,
    };

Outlets _$OutletsFromJson(Map<String, dynamic> json) => Outlets(
      outletPostId: json['outlet_post_id'] as int?,
      outletPostName: json['outlet_post_name'] as String?,
      outletPostStatus: json['outlet_post_status'] as String?,
      addedOn: json['added_on'] as String?,
    );
