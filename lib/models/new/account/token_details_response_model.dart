// ignore_for_file: lines_longer_than_80_chars

import 'package:json_annotation/json_annotation.dart';

part 'token_details_response_model.g.dart';

@JsonSerializable()
class GetTokenDetailsResponse {
  GetTokenDetailsResponse({required this.status, required this.message, required this.data});

  factory GetTokenDetailsResponse.fromJson(Map<String, dynamic> json) => _$GetTokenDetailsResponseFromJson(json);

  final String? message;
  final String? status;
  final List<Data>? data;

  Map<String, dynamic> toJson() => _$GetTokenDetailsResponseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.userId,
    required this.name,
    required this.username,
    required this.locationId,
    required this.userCategory,
    required this.userType,
    required this.permissions,
    required this.iat,
    required this.exp,
    required this.locationName,
    required this.operatorId,
  });
  final int? userId;
  final String? name;
  final String? username;
  final int? locationId;
  final String? userCategory;
  final String? userType;
  final Permissions? permissions;
  final int? iat;
  final int? exp;
  final String? locationName;
  final String? operatorId;
}

@JsonSerializable()
class Permissions {
  Permissions({
    required this.feeCollection,
    required this.ticketCheckin,
    required this.ticketRequest,
    required this.ticketOntheway,
    required this.ticketCollectnow,
    required this.ticketCheckout,
    required this.ticketEdit,
    required this.ticketDelete,
    required this.ticketMobilePrint,
    required this.report,
    required this.cashCheckin,
    required this.cashCheckinEdit,
    required this.imageUpload,
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
