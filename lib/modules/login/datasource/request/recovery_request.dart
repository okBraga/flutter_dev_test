import 'package:json_annotation/json_annotation.dart';

part 'recovery_request.g.dart';

@JsonSerializable(explicitToJson: true)
class RecoveryRequest {
  final String username;
  final String password;
  final String code;

  RecoveryRequest({
    required this.username,
    required this.password,
    required this.code,
  });

  factory RecoveryRequest.fromJson(Map<String, dynamic> json) => _$RecoveryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecoveryRequestToJson(this);
}
