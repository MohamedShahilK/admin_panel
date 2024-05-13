import 'package:json_annotation/json_annotation.dart';

part 'auth_error_response_model.g.dart';

@JsonSerializable()
class AuthErrorResponseModel {
  AuthErrorResponseModel({
    required this.status,
    required this.message,
    required this.errors,
  });

  factory AuthErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthErrorResponseModelFromJson(json);

  final String status;
  final String message;
  final List<String> errors;

  Map<String, dynamic> toJson() => _$AuthErrorResponseModelToJson(this);
}
