import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginRequest {
  final String username;
  final String password;

  @JsonKey(name: 'totp_code')
  final String? totpCode;

  LoginRequest({
    required this.username,
    required this.password,
    this.totpCode,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
