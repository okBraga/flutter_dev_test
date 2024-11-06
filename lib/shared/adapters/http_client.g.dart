// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpResponse _$HttpResponseFromJson(Map<String, dynamic> json) => HttpResponse(
      json['data'],
      (json['status'] as num?)?.toInt(),
      json['url'] == null ? null : Uri.parse(json['url'] as String),
      (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      ),
      HttpRequest.fromJson(json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HttpResponseToJson(HttpResponse instance) => <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
      'url': instance.url?.toString(),
      'headers': instance.headers,
      'request': instance.request.toJson(),
    };

HttpRequest _$HttpRequestFromJson(Map<String, dynamic> json) => HttpRequest(
      json['data'],
      json['method'] as String,
      Uri.parse(json['url'] as String),
      json['headers'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$HttpRequestToJson(HttpRequest instance) => <String, dynamic>{
      'data': instance.data,
      'method': instance.method,
      'url': instance.url.toString(),
      'headers': instance.headers,
    };

HttpException _$HttpExceptionFromJson(Map<String, dynamic> json) => HttpException(
      json['message'] as String?,
      json['response'] == null ? null : HttpResponse.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HttpExceptionToJson(HttpException instance) => <String, dynamic>{
      'message': instance.message,
      'response': instance.response?.toJson(),
    };

HttpRequestOptions _$HttpRequestOptionsFromJson(Map<String, dynamic> json) => HttpRequestOptions(
      path: json['path'] as String,
      method: json['method'] as String,
      data: json['data'],
      queryParameters: (json['queryParameters'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      ),
      headers: json['headers'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HttpRequestOptionsToJson(HttpRequestOptions instance) => <String, dynamic>{
      'path': instance.path,
      'method': instance.method,
      'data': instance.data,
      'queryParameters': instance.queryParameters,
      'headers': instance.headers,
    };
