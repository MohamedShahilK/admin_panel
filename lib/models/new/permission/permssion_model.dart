// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'permssion_model.g.dart';

@JsonSerializable()
class GetAllPermissions {
  GetAllPermissions({this.status, this.message, this.data});

  factory GetAllPermissions.fromJson(Map<String, dynamic> json) => _$GetAllPermissionsFromJson(json);

  final String? status;
  final String? message;
  final List<Data>? data;
}

@JsonSerializable()
class Data {
  Data({
    this.feeCollection,
    this.ticketCheckin,
    this.ticketRequest,
    this.ticketOntheway,
    this.ticketCollectnow,
    this.ticketCheckout,
    this.ticketEdit,
    this.ticketDelete,
    this.ticketMobilePrint,
    this.report,
    this.cashCheckin,
    this.cashCheckinEdit,
    this.imageUpload,
  });
  final String? feeCollection;
  final String? ticketCheckin;
  final String? ticketRequest;
  final String? ticketOntheway;
  final String? ticketCollectnow;
  final String? ticketCheckout;
  final String? ticketEdit;
  final String? ticketDelete;
  final String? ticketMobilePrint;
  final String? report;
  final String? cashCheckin;
  final String? cashCheckinEdit;
  final String? imageUpload;
}
