// ignore_for_file: lines_longer_than_80_chars

import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_checkout_response_model.g.dart';

@JsonSerializable()
class AllCheckOutResponse {
  AllCheckOutResponse({required this.status, required this.message, required this.data});

  factory AllCheckOutResponse.fromJson(Map<String, dynamic> json) => _$AllCheckOutResponseFromJson(json);

  final String? status;
  final String? message;
  final Data? data;
}

@JsonSerializable()
class Data {
  Data({
    required this.checkOutStatus,
    required this.totalRecords,
    required this.locationId,
    required this.startDate,
    required this.endDate,
    required this.orderBy,
    required this.orderByDirection,
    required this.count,
    required this.page,
    required this.recordsPerPage,
    required this.totalPages,
    required this.checkOutList,
  });
  final String? checkOutStatus;
  final int? totalRecords;
  final int? locationId;
  final String? startDate;
  final String? endDate;
  final String? orderBy;
  final String? orderByDirection;
  final int? count;
  final int? page;
  final int? recordsPerPage;
  final int? totalPages;
  final List<CheckOutList>?  checkOutList;
  
}

@JsonSerializable()
class CheckOutList {
  CheckOutList({
    required this.id,
    required this.barcode,
    required this.createDate,
    required this.parkingTime,
    required this.checkoutTime,
    required this.payment,
    required this.voucherMainId,
    required this.voucherCodeNo,
    required this.cashier,
    required this.checkoutStatus,
    required this.requestedByUser,
    required this.initialCheckinTime,
    required this.dataCheckinTime,
    required this.requestedTime,
    required this.onthewayTime,
    required this.paymentCalculatedOn,
    required this.finalCheckoutTime,
    required this.parkingLocation,
    required this.parkingLocationnew,
    required this.slotId,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.vehicleColr,
    required this.emirates,
    required this.cvaIn,
    required this.cvaOut,
    required this.guestType,
    required this.slot,
    required this.customerDetails,
    required this.customerMobile,
    required this.vehicleRemark,
    required this.userId,
    required this.userType,
    required this.status,
    required this.inBy,
    required this.outBy,
    required this.paymentMethod,
    required this.paymentNote,
    required this.grossAmount,
    required this.discountAmount,
    required this.voucherBarcode,
    required this.vatPercentage,
    required this.vatAmount,
    required this.subTotal,
    required this.outletOfferId,
    required this.offerTotalMidnight,
    required this.paymentPaidMethod,
    required this.modifiedOn,
    required this.modifiedBy,
    required this.modifiedByUser,
    required this.paidOnCheckin,
    required this.customerRequest,
    required this.customerEmail,
    required this.customerPhoneNo,
    required this.carColorName,
    required this.carModelName,
    required this.locationName,
    required this.cvaInName,
    required this.cvaOutName,
    required this.userName,
    required this.guestTypeName,
    required this.emiratesName,
    required this.requestedUser,
  });
  final String? id;
  final String? barcode;
  final String? createDate;
  final String? parkingTime;
  final String? checkoutTime;
  final String? payment;
  final String? voucherMainId;
  final String? voucherCodeNo;
  final String? cashier;
  final String? checkoutStatus;
  final String? requestedByUser;
  final String? initialCheckinTime;
  final String? dataCheckinTime;
  final String? requestedTime;
  final String? onthewayTime;
  final String? paymentCalculatedOn;
  final String? finalCheckoutTime;
  final String? parkingLocation;
  final String? parkingLocationnew;
  final String? slotId;
  final String? vehicleNumber;
  // final String? vehicleModel;
  final int? vehicleModel;
  final String? vehicleColr;
  final String? emirates;
  final String? cvaIn;
  final String? cvaOut;
  final String? guestType;
  final String? slot;
  final String? customerDetails;
  final String? customerMobile;
  final String? vehicleRemark;
  final String? userId;
  final String? userType;
  final String? status;
  final String? inBy;
  final String? outBy;
  final String? paymentMethod;
  final String? paymentNote;
  final String? grossAmount;
  final String? discountAmount;
  final String? voucherBarcode;
  final double? vatPercentage;
  final double? vatAmount;
  final double? subTotal;
  final String? outletOfferId;
  final String? offerTotalMidnight;
  final String? paymentPaidMethod;
  final String? modifiedOn;
  final String? modifiedBy;
  final String? modifiedByUser;
  final String? paidOnCheckin;
  final String? customerRequest;
  final String? customerEmail;
  final String? customerPhoneNo;

  final String? carColorName;
  final String? carModelName;
  final String? locationName;
  final String? cvaInName;
  final String? cvaOutName;
  final String? userName;
  final String? guestTypeName;
  final String? emiratesName;
  final String? requestedUser;
}
