// ignore_for_file: lines_longer_than_80_chars
import 'package:json_annotation/json_annotation.dart';

part 'image_upload_form_response_model.g.dart';

@JsonSerializable()
class ImageUploadFormResponseModel {
  ImageUploadFormResponseModel({required this.status, required this.message, required this.allowedImagesPerVehicle, required this.data});

  factory ImageUploadFormResponseModel.fromJson(Map<String, dynamic> json) => _$ImageUploadFormResponseModelFromJson(json);

  final String? status;
  final String? message;
  final int? allowedImagesPerVehicle;
  final Data? data;
}

@JsonSerializable()
class Data {
  Data({required this.ticketInfo, required this.vehicleImages, required this.vehicleParts});
  final TicketInfo? ticketInfo;
  final List<VehicleImages>? vehicleImages;
  final List<VehicleParts>? vehicleParts;
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
class VehicleImages {
  VehicleImages({
    required this.imageId,
    required this.parkingEntryId,
    required this.vehiclePartId,
    required this.vehicleCategoryId,
    required this.imagePath,
    required this.remark,
    required this.addedBy,
    required this.addedOn,
    required this.status,
    required this.partId,
    required this.partTitle,
    required this.partPosition,
    required this.partStatus,
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
  final int? partId;
  final String? partTitle;
  final String? partPosition;
  final String? partStatus;
}

@JsonSerializable()
class VehicleParts {
  VehicleParts({required this.partId, required this.vehicleCategoryId, required this.partTitle, required this.remark, required this.partPosition, required this.partStatus});
  final int? partId;
  final int? vehicleCategoryId;
  final String? partTitle;
  final String? remark;
  final String? partPosition;
  final String? partStatus;
}
