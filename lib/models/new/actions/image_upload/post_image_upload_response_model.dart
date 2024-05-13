// ignore_for_file: lines_longer_than_80_chars

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_image_upload_response_model.g.dart';

@JsonSerializable()
class PostUploadImageResponseModel {
  PostUploadImageResponseModel({required this.status, required this.message, required this.imageId, required this.data});

  factory PostUploadImageResponseModel.fromJson(Map<String, dynamic> json) => _$PostUploadImageResponseModelFromJson(json);

  final String? status;
  final String? message;
  final int? imageId;
  final Data? data;

  // Map<String, dynamic> toJson() => _$PostUploadImageResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({required this.id, required this.fileName, required this.ticketInfo, required this.imageInfo});
  final String? id;
  final String? fileName;
  final TicketInfo? ticketInfo;
  final ImageInfo? imageInfo;
}

@JsonSerializable()
class TicketInfo {
  TicketInfo({
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
  });

  final int? id;
  final String? barcode;
  final String? createDate;
  final String? parkingTime;
  final String? checkoutTime;
  final String? payment;
  final int? voucherMainId;
  final String? voucherCodeNo;
  final String? cashier;
  final String? checkoutStatus;
  final int? requestedByUser;
  final String? initialCheckinTime;
  final String? dataCheckinTime;
  final String? requestedTime;
  final String? onthewayTime;
  final String? paymentCalculatedOn;
  final String? finalCheckoutTime;
  final int? parkingLocation;
  final String? parkingLocationnew;
  final int? slotId;
  final String? vehicleNumber;
  final int? vehicleModel;
  final int? vehicleColr;
  final int? emirates;
  final int? cvaIn;
  final int? cvaOut;
  final int? guestType;
  final String? slot;
  final String? customerDetails;
  final String? customerMobile;
  final String? vehicleRemark;
  final int? userId;
  final String? userType;
  final String? status;
  final int? inBy;
  final int? outBy;
  final int? paymentMethod;
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
  final int? modifiedBy;
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
}

@JsonSerializable()
class ImageInfo {
  ImageInfo({
    required this.imageId,
    required this.parkingEntryId,
    required this.vehiclePartId,
    required this.vehicleCategoryId,
    required this.imagePath,
    required this.remark,
    required this.addedBy,
    required this.addedOn,
    required this.status,
  });
  final int? imageId;
  final int? parkingEntryId;
  final int? vehiclePartId;
  final int? vehicleCategoryId;
  final String? imagePath;
  final String? remark;
  final int? addedBy;
  final String? addedOn;
  final String? status;
}
