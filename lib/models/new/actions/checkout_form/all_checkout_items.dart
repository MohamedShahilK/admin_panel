// ignore_for_file: lines_longer_than_80_chars

import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_checkout_items.g.dart';

@JsonSerializable()
class AllCheckOutItemsResponse {
  AllCheckOutItemsResponse({required this.status, required this.message, required this.data});

  factory AllCheckOutItemsResponse.fromJson(Map<String, dynamic> json) => _$AllCheckOutItemsResponseFromJson(json);
  final String? status;
  final String? message;
  final Data? data;
  // Map<String, dynamic> toJson() => _$AllCheckOutItemsResponseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.cvas,
    required this.cashSetting,
    required this.vatSetting,
    required this.paymentMethod,
    required this.paymentTypes,
    required this.vouchers,
    required this.paymentTypesMaster,
    required this.outlets,
  });
  final List<Cvas>? cvas;
  final CashSetting? cashSetting;
  final VatSetting? vatSetting;
  final List<String>? paymentMethod;
  final List<PaymentTypes>? paymentTypes;
  final List<String?>? vouchers;
  final List<PaymentTypesMaster>? paymentTypesMaster;
  final List<Outlets>? outlets;
}

@JsonSerializable()
class Cvas {
  Cvas({required this.departmentId, required this.departmentName});
  final int? departmentId;
  final String? departmentName;
}

@JsonSerializable()
class CashSetting {
  CashSetting({required this.popupSettingId, required this.popupStatus});
  final int? popupSettingId;
  final String? popupStatus;
}

@JsonSerializable()
class VatSetting {
  VatSetting({required this.vatSettingId, required this.vatValue, required this.vatStatus});
  final int? vatSettingId;
  final int? vatValue;
  final String? vatStatus;
}

@JsonSerializable()
class PaymentTypes {
  PaymentTypes({
    required this.id,
    required this.paymentTypeId,
    required this.locationId,
    required this.cashCategory,
    required this.title,
    required this.payType,
    required this.barcodePrefix,
    required this.startingHours,
    required this.startingHourRate,
    required this.balanceHourRate,
    required this.includeVat,
    required this.paymentTypeStatus,
    required this.paymentTypeName,
  });
  final int? id;
  final int? paymentTypeId;
  final int? locationId;
  final int? cashCategory;
  final String? title;
  final String? payType;
  final String? barcodePrefix;
  final int? startingHours;
  final int? startingHourRate;
  final int? balanceHourRate;
  final String? includeVat;
  final String? paymentTypeStatus;
  final String? paymentTypeName;
}

@JsonSerializable()
class PaymentTypesMaster {
  PaymentTypesMaster({
    required this.paymentTypeId,
    required this.paymentType,
    required this.paymentTypeOrder,
    required this.paymentMasterStatus,
  });

  final int? paymentTypeId;
  final String? paymentType;
  final int? paymentTypeOrder;
  final String? paymentMasterStatus;
}

@JsonSerializable()
class Outlets {
  Outlets({
    required this.outletId,
    required this.outletPostName,
    required this.locationId,
    required this.outletPostStatus,
    required this.addedOn,
  });
  final int? outletId;
  final String? outletPostName;
  final int? locationId;
  final String? outletPostStatus;
  final String? addedOn;
}
