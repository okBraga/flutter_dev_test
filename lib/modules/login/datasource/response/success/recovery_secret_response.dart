import 'package:json_annotation/json_annotation.dart';
part 'recovery_secret_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RecoverySecretResponse {
  final String message;

  @JsonKey(name: 'totp_secret')
  final String totpSecret;

  RecoverySecretResponse({
    required this.message,
    required this.totpSecret,
  });

  factory RecoverySecretResponse.fromJson(Map<String, dynamic> json) => _$RecoverySecretResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecoverySecretResponseToJson(this);
}
