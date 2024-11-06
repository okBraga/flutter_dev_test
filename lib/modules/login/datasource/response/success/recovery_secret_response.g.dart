// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_secret_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoverySecretResponse _$RecoverySecretResponseFromJson(
        Map<String, dynamic> json) =>
    RecoverySecretResponse(
      message: json['message'] as String,
      totpSecret: json['totp_secret'] as String,
    );

Map<String, dynamic> _$RecoverySecretResponseToJson(
        RecoverySecretResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'totp_secret': instance.totpSecret,
    };
