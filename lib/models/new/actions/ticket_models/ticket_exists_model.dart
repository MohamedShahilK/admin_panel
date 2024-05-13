

import 'package:json_annotation/json_annotation.dart';

part 'ticket_exists_model.g.dart';

@JsonSerializable()
class   TicketExistsResponseModel {
  TicketExistsResponseModel({
    required this.status,
    required this.message,
    required this.locationId,
    required this.ticketNumber,
    required this.data,
  });
  factory TicketExistsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TicketExistsResponseModelFromJson(json);

  final String? status;
  final String? message;
  final int? locationId;
  final String? ticketNumber;
  final Data? data;

  // Map<String, dynamic> toJson() => _$TicketExistsResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({required this.ticketInfo});
  final List<dynamic>? ticketInfo;
}
