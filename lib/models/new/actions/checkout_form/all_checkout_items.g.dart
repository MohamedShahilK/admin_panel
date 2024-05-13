// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'all_checkout_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllCheckOutItemsResponse _$AllCheckOutItemsResponseFromJson(Map<String, dynamic> json) => AllCheckOutItemsResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$AllCheckOutItemsResponseToJson(AllCheckOutItemsResponse instance) => <String, dynamic>{
//       'status': instance.status,
//       'message': instance.message,
//       'data': _$DataToJson(instance.data),
//     };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      cvas: json['cvas'] == null ? null : (json['cvas'] as List<dynamic>).map((e) => _$CvasFromJson(e as Map<String, dynamic>)).toList(),
      cashSetting: json['cash_setting'] == null ? null : _$CashSettingFromJson(json['cash_setting'] as Map<String, dynamic>),
      // vatSetting: (json['vat_setting'] as List<dynamic>).map((e) => e as String?).toList(),
      vatSetting: json['vat_setting'] == null ? null : _$VatSettingFromJson(json['vat_setting'] as Map<String, dynamic>),
      paymentMethod: json['payment_method'] == null ? null : (json['payment_method'] as List<dynamic>).map((e) => e as String).toList(),
      paymentTypes: json['payment_types'] == null ? null : (json['payment_types'] as List<dynamic>).map((e) => _$PaymentTypesFromJson(e as Map<String, dynamic>)).toList(),
      vouchers: json['vouchers'] == null ? null : (json['vouchers'] as List<dynamic>).map((e) => e as String?).toList(),
      paymentTypesMaster: json['payment_types_master'] == null ? null : (json['payment_types_master'] as List<dynamic>).map((e) => _$PaymentTypesMasterFromJson(e as Map<String, dynamic>)).toList(),
      outlets: json['outlets'] == null ? null : (json['outlets'] as List<dynamic>).map((e) => _$OutletsFromJson(e as Map<String, dynamic>)).toList(),
    );

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'cvas': instance.cvas.map(_$CvasToJson),
//       'cash_setting': _$CashSettingToJson(instance.cashSetting),
//       'vat_setting': _$VatSettingToJson(instance.vatSetting),
//       'payment_method': instance.paymentMethod,
//       'payment_types': instance.paymentTypes.map(_$PaymentTypesToJson),
//       'vouchers': instance.vouchers,
//     };

Cvas _$CvasFromJson(Map<String, dynamic> json) => Cvas(
      departmentId: json['department_Id'] as int?,
      departmentName: json['department_name'] as String?,
    );

// Map<String, dynamic> _$CvasToJson(Cvas instance) => <String, dynamic>{
//       'department_Id': instance.departmentId,
//       'department_name': instance.departmentName,
//     };

CashSetting _$CashSettingFromJson(Map<String, dynamic> json) => CashSetting(
      popupSettingId: json['popup_setting_id'] as int?,
      popupStatus: json['popup_status'] as String?,
    );
// Map<String, dynamic> _$CashSettingToJson(CashSetting instance) => <String, dynamic>{
//       'popup_setting_id': instance.popupSettingId,
//       'popup_status': instance.popupStatus,
//     };

VatSetting _$VatSettingFromJson(Map<String, dynamic> json) => VatSetting(
      vatSettingId: json['vat_setting_id'] as int?,
      vatValue: json['vat_value'] as int?,
      vatStatus: json['vat_status'] as String?,
    );

// Map<String, dynamic> _$VatSettingToJson(VatSetting instance) => <String, dynamic>{
//       'vat_setting_id': instance.vatSettingId,
//       'vat_value': instance.vatValue,
//       'vat_status': instance.vatStatus,
//     };
PaymentTypes _$PaymentTypesFromJson(Map<String, dynamic> json) => PaymentTypes(
      id: json['id'] as int?,
      paymentTypeId: json['payment_type_id'] as int?,
      locationId: json['location_id'] as int?,
      cashCategory: json['cash_category'] as int?,
      title: json['title'] as String?,
      payType: json['pay_type'] as String?,
      barcodePrefix: json['barcode_prefix'] as String?,
      startingHours: json['starting_hours'] as int?,
      startingHourRate: json['starting_hour_rate'] as int?,
      balanceHourRate: json['balance_hour_rate'] as int?,
      includeVat: json['include_vat'] as String?,
      paymentTypeStatus: json['payment_type_status'] as String?,
      paymentTypeName: json['payment_type_name'] as String?,
    );

// Map<String, dynamic> _$PaymentTypesToJson(PaymentTypes instance) => <String, dynamic>{
//       'id': instance.id,
//       'payment_type_id': instance.paymentTypeId,
//       'location_id': instance.locationId,
//       'cash_category': instance.cashCategory,
//       'title': instance.title,
//       'pay_type': instance.payType,
//       'barcode_prefix': instance.barcodePrefix,
//       'starting_hours': instance.startingHours,
//       'starting_hour_rate': instance.startingHourRate,
//       'balance_hour_rate': instance.balanceHourRate,
//       'include_vat': instance.includeVat,
//       'payment_type_status': instance.paymentTypeStatus,
//       'payment_type_name': instance.paymentTypeName,
//     };

PaymentTypesMaster _$PaymentTypesMasterFromJson(Map<String, dynamic> json) => PaymentTypesMaster(
      paymentTypeId: json['payment_type_id'] as int?,
      paymentType: json['payment_type'] as String?,
      paymentTypeOrder: json['payment_type_order'] as int?,
      paymentMasterStatus: json['payment_master_status'] as String?,
    );

Outlets _$OutletsFromJson(Map<String, dynamic> json) => Outlets(
      outletId: json['outlet_post_id'] as int?,
      outletPostName: json['outlet_post_name'] as String?,
      locationId: json['location_id'] as int?,
      outletPostStatus: json['outlet_post_status'] as String?,
      addedOn: json['added_on'] as String?,
    );
