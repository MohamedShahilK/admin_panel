// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'dashboard_resp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashBoardResponseModel _$DashBoardResponseModelFromJson(Map<String, dynamic> json) => DashBoardResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      locationId: json['location_id'] as int?,
      locationName: json['location_name'] as String?,
      userType: json['user_type'] as String?,
      userId: json['user_id'] as int?,
      count: json['count'] as int?,
      page: json['page'] as int?,
      offset: json['offset'] as int?,
      recordsPerPage: json['records_per_page'] as int?,
      totalPages: json['total_pages'] as int?,
      inventoryCount: json['inventory_count'] as int?,
      data: json['data'] == null ? null : _$DataFromJson(json['data'] as Map<String, dynamic>),
      logoPath: json['logo_path'] as String?,
      locationParkingCapacity: json['location_parking_capacity'] as int?,
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      checkinCount: json['checkin_count'] == null ? null : _$CheckinCountFromJson(json['checkin_count'] as Map<String, dynamic>),
      parkedCount: json['parked_count'] == null ? null : _$CheckinCountFromJson(json['parked_count'] as Map<String, dynamic>),
      requestedCount: json['requested_count'] == null ? null : _$CheckinCountFromJson(json['requested_count'] as Map<String, dynamic>),
      onthewayCount: json['ontheway_count'] == null ? null : _$CheckinCountFromJson(json['ontheway_count'] as Map<String, dynamic>),
      collectnowCount: json['collectnow_count'] == null ? null : _$CheckinCountFromJson(json['collectnow_count'] as Map<String, dynamic>),
      checkoutCount: json['checkout_count'] == null ? null : _$CheckinCountFromJson(json['checkout_count'] as Map<String, dynamic>),
      activeTickets: json['active_tickets'] == null ? null : (json['active_tickets'] as List<dynamic>?)?.map((e) => _$ActiveTicketsFromJson(e as Map<String, dynamic>)).toList(),
    );

CheckinCount _$CheckinCountFromJson(Map<String, dynamic> json) => CheckinCount(
      count: json['count'] as int?,
    );

ActiveTickets _$ActiveTicketsFromJson(Map<String, dynamic> json) => ActiveTickets(
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
      userId: json['user_id'] as int?,
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
      outletOfferId: json['outlet_offer_id'] as int?,
      offerTotalMidnight: json['offer_total_midnight'] as String?,
      paymentPaidMethod: json['payment_paid_method'] as String?,
      modifiedOn: json['modified_on'] as String?,
      modifiedBy: json['modified_by'] as int?,
      modifiedByUser: json['modified_by_user'] as String?,
      paidOnCheckin: json['paid_on_checkin'] as String?,
      customerRequest: json['customer_request'] as String?,
      customerEmail: json['customer_email'] as String?,
      customerPhoneNo: json['customer_phone_no'] as String?,
      carColorName: json['car_color_name'] as String?,
      carModelName: json['car_model_name'] as String?,
      locationName: json['location_name'] as String?,
      cvaInName: json['cva_in_name'] as String?,
      cvaOutName: json['cva_out_name'] as String?,
      userName: json['user_name'] as String?,
      guestTypeName: json['guest_type_name'] as String?,
      emiratesName: json['emirates_name'] as String?,
    );
