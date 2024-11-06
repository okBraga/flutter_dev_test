// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryRequest _$RecoveryRequestFromJson(Map<String, dynamic> json) => RecoveryRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$RecoveryRequestToJson(RecoveryRequest instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'code': instance.code,
    };
