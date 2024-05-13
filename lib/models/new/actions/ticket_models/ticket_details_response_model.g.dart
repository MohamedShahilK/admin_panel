// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'ticket_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDetailsResponseModel _$TicketDetailsResponseModelFromJson(Map<String, dynamic> json) => TicketDetailsResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      locationId: json['location_id'] as int?,
      ticketNumber: json['ticket_number'] as String?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
    );

// Map<String, dynamic> _$TicketDetailsResponseModelToJson(TicketDetailsResponseModel instance) => <String, dynamic>{
//       'status': instance.status,
//       'message': instance.message,
//       'location_id': instance.locationId,
//       'ticket_number': instance.ticketNumber,
//       'data': _$DataToJson(instance.data),
//     };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      ticketInfo: json['ticket_info'] == null ? null : (json['ticket_info'] as List<dynamic>).map((e) => _$TicketInfoFromJson(e as Map<String, dynamic>)).toList(),
    );

// Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
//       'ticket_info': instance.ticketInfo.map(_$TicketInfoToJson).toList(),
//     };

TicketInfo _$TicketInfoFromJson(Map<String, dynamic> json) => TicketInfo(
      id: json['id'] as int?,
      barcode: json['barcode'] as String?,
      createDate: json['create_date'] as String?,
      parkingTime: json['parking_time'] as String?,
      checkoutTime: json['checkout_time'] as String?,
      payment: json['payment'] as String?,
      voucherMainId: json['voucher_main_id'] as int?,
      voucherCodeNo: json['voucher_code_no'] as String?,
      cashier: json['cashier'] as String?,
      checkoutStatus: json['checkout_status'] as String?,
      requestedByUser: json['requested_by_user'] as int?,
      initialCheckinTime: json['initial_checkin_time'] as String?,
      dataCheckinTime: json['data_checkin_time'] as String?,
      requestedTime: json['requested_time'] as String?,
      onthewayTime: json['ontheway_time'] as String?,
      paymentCalculatedOn: json['payment_calculated_on'] as String?,
      finalCheckoutTime: json['final_checkout_time'] as String?,
      parkingLocation: json['parking_location'] as int?,
      parkingLocationnew: json['parking_locationnew'] as String?,
      slotId: json['slot_id'] as int?,
      vehicleNumber: json['vehicle_number'] as String?,
      vehicleModel: json['vehicle_model'] as int?,
      vehicleColr: json['vehicle_colr'] as int?,
      emirates: json['emirates'] as int?,
      cvaIn: json['cva_in'] as int?,
      cvaOut: json['cva_out'] as int?,
      guestType: json['guest_type'] as int?,
      slot: json['slot'] as String?,
      customerDetails: json['customer_details'] as String?,
      customerMobile: json['customer_mobile'] as String?,
      vehicleRemark: json['vehicle_remark'] as String?,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String?,
      status: json['status'] as String?,
      inBy: json['in_by'] as int?,
      outBy: json['out_by'] as int?,
      paymentMethod: json['payment_method'] as int?,
      paymentNote: json['payment_note'] as String?,
      grossAmount: json['gross_amount'] as String?,
      discountAmount: json['discount_amount'] as String?,
      voucherBarcode: json['voucher_barcode'] as String?,
      vatPercentage: (json['vat_percentage'] as num?)?.toDouble(),
      vatAmount: (json['vat_amount'] as num?)?.toDouble(),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      outletOfferId: json['outlet_offer_id'] as String?,
      offerTotalMidnight: json['offer_total_midnight'] as String?,
      paymentPaidMethod: json['payment_paid_method'] as String?,
      modifiedOn: json['modified_on'] as String?,
      modifiedBy: json['modified_by'] as int?,
      modifiedByUser: json['modified_by_user'] as String?,
      paidOnCheckin: json['paid_on_checkin'] as String?,
      customerRequest: json['customer_request'] as String?,
      customerEmail: json['customer_email'] as String?,
      customerPhoneNo: json['customer_phone_no'] as String?,
      outletId: json['verified_in_outlet'] as int?,
      ///////////////////////////////////////////////////
      carColorName: json['car_color_name'] as String?,
      carBrandName: json['car_model_name'] as String?,
      locationName: json['location_name'] as String?,
      cvaInName: json['cva_in_name'] as String?,
      cvaOutName: json['cva_out_name'] as String?,
      userName: json['user_name'] as String?,
      guestTypeName: json['guest_type_name'] as String?,
      emiratesName: json['emirates_name'] as String?,
    );

Map<String, dynamic> _$TicketInfoToJson(TicketInfo instance) => <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'create_date': instance.createDate,
      'parking_time': instance.parkingTime,
      'checkout_time': instance.checkoutTime,
      'payment': instance.payment,
      'voucher_main_id': instance.voucherMainId,
      'voucher_code_no': instance.voucherCodeNo,
      'cashier': instance.cashier,
      'checkout_status': instance.checkoutStatus,
      'requested_by_user': instance.requestedByUser,
      'initial_checkin_time': instance.initialCheckinTime,
      'data_checkin_time': instance.dataCheckinTime,
      'requested_time': instance.requestedTime,
      'ontheway_time': instance.onthewayTime,
      'payment_calculated_on': instance.paymentCalculatedOn,
      'final_checkout_time': instance.finalCheckoutTime,
      'parking_location': instance.parkingLocation,
      'parking_locationnew': instance.parkingLocationnew,
      'slot_id': instance.slotId,
      'vehicle_number': instance.vehicleNumber,
      'vehicle_model': instance.vehicleModel,
      'vehicle_colr': instance.vehicleColr,
      'emirates': instance.emirates,
      'cva_in': instance.cvaIn,
      'cva_out': instance.cvaOut,
      'guest_type': instance.guestType,
      'slot': instance.slot,
      'customer_details': instance.customerDetails,
      'customer_mobile': instance.customerMobile,
      'vehicleRemark': instance.vehicleRemark,
      'user_id': instance.userId,
      'user_type': instance.userType,
      'status': instance.status,
      'in_by': instance.inBy,
      'out_by': instance.outBy,
      'payment_method': instance.paymentMethod,
      'paymentNote': instance.paymentNote,
      'gross_amount': instance.grossAmount,
      'discount_amount': instance.discountAmount,
      'voucher_barcode': instance.voucherBarcode,
      'vat_percentage': instance.vatPercentage,
      'vat_amount': instance.vatAmount,
      'sub_total': instance.subTotal,
      'outlet_offer_id': instance.outletOfferId,
      'offer_total_midnight': instance.offerTotalMidnight,
      'payment_paid_method': instance.paymentPaidMethod,
      'modified_on': instance.modifiedOn,
      'modified_by': instance.modifiedBy,
      'modified_by_user': instance.modifiedByUser,
      'paid_on_checkin': instance.paidOnCheckin,
      'customer_request': instance.customerRequest,
      'customer_email': instance.customerEmail,
      'customer_phone_no': instance.customerPhoneNo,
      'car_color_name': instance.carColorName,
      'car_model_name': instance.carBrandName,
      'location_name': instance.locationName,
      'cva_in_name': instance.cvaInName,
      'cva_out_name': instance.cvaOutName,
      'user_name': instance.userName,
      'guest_type_name': instance.guestTypeName,
      'emirates_name': instance.emiratesName,
    };
