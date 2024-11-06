// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'http_client.g.dart';

@JsonSerializable(explicitToJson: true)
class HttpResponse {
  HttpResponse(this.data, this.status, this.url, this.headers, this.request);

  factory HttpResponse.fromJson(Map<String, dynamic> json) => _$HttpResponseFromJson(json);
  final Object? data;
  final int? status;
  final Uri? url;
  final Map<String, Object>? headers;
  final HttpRequest request;

  Map<String, dynamic> toJson() => _$HttpResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HttpRequest {
  HttpRequest(this.data, this.method, this.url, this.headers);

  factory HttpRequest.fromJson(Map<String, dynamic> json) => _$HttpRequestFromJson(json);
  final Object? data;
  final String method;
  final Uri url;
  final Map<String, dynamic> headers;

  Map<String, dynamic> toJson() => _$HttpRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HttpException implements Exception {
  HttpException(this.message, this.response);

  factory HttpException.fromJson(Map<String, dynamic> json) => _$HttpExceptionFromJson(json);
  final String? message;
  final HttpResponse? response;

  Map<String, dynamic> toJson() => _$HttpExceptionToJson(this);

  @override
  String toString() => 'HttpException(Exception: message: $message, body: ${jsonEncode(response?.toJson())})';
}

@JsonSerializable(explicitToJson: true)
class HttpRequestOptions {
  HttpRequestOptions({
    required this.path,
    required this.method,
    this.data,
    this.queryParameters,
    this.headers,
  });

  final String path;
  final String method;
  final Object? data;
  final Map<String, Object>? queryParameters;
  final Map<String, dynamic>? headers;

  Map<String, dynamic> toJson() => _$HttpRequestOptionsToJson(this);

  HttpRequestOptions copyWith({
    String? path,
    String? method,
    Object? data,
    Map<String, Object>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      HttpRequestOptions(
        path: path ?? this.path,
        method: method ?? this.method,
        data: data ?? this.data,
        queryParameters: queryParameters ?? this.queryParameters,
        headers: headers ?? this.headers,
      );
}

abstract class HttpInterceptor {
  FutureOr<HttpResponse> onResponse(
    HttpRequestOptions request,
    HttpResponse response,
  ) =>
      response;

  FutureOr<HttpRequestOptions?> onError(
    HttpRequestOptions request,
    HttpException exception,
  ) =>
      null;

  FutureOr<HttpRequestOptions> onRequest(HttpRequestOptions request) => request;
}

abstract class HttpClient {
  Future<HttpResponse> post({
    required String path,
    Object? data,
    Map<String, Object>? queryParameters,
    Map<String, Object>? headers,
  });
}

class DioHttpClient implements HttpClient {
  DioHttpClient(this._dio);

  factory DioHttpClient.fromPath(String path) => DioHttpClient(Dio(BaseOptions(baseUrl: path)));

  final Dio _dio;

  final List<HttpInterceptor> interceptors = [];

  static const _defaultHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  HttpResponse? _buildResponse(Response? response) {
    if (response == null) {
      return null;
    }

    final request = response.requestOptions;

    return HttpResponse(
      response.data,
      response.statusCode,
      response.realUri,
      Map.of(response.headers.map),
      HttpRequest(
        request.data,
        request.method,
        request.uri,
        Map.of(request.headers),
      ),
    );
  }

  HttpException _handleError(DioException exception) => HttpException(
        exception.message,
        _buildResponse(exception.response),
      );

  Future<HttpRequestOptions> _interceptRequest(HttpRequestOptions options) async {
    HttpRequestOptions requestOptions = options;
    for (final interceptor in interceptors) {
      requestOptions = await interceptor.onRequest(requestOptions);
    }
    return requestOptions;
  }

  Future<HttpRequestOptions?> _interceptError(HttpRequestOptions options, HttpException exception) async {
    for (final interceptor in interceptors) {
      final requestOptions = await interceptor.onError(options, exception);
      if (requestOptions != null) {
        return requestOptions;
      }
    }

    return null;
  }

  Future<HttpResponse> _handleRequest(HttpRequestOptions options) async {
    try {
      final requestOptions = await _interceptRequest(options);

      final response = await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: {..._defaultHeaders, ...?requestOptions.headers},
          responseType: ResponseType.json,
        ),
      );

      return _buildResponse(response)!;
    } on DioException catch (exception) {
      final errorOptions = await _interceptError(options, _handleError(exception));
      if (errorOptions != null) {
        await _handleRequest(options);
      }
      throw _handleError(exception);
    }
  }

  @override
  Future<HttpResponse> post({
    required String path,
    Object? data,
    Map<String, Object>? queryParameters,
    Map<String, Object>? headers,
  }) async =>
      _handleRequest(
        HttpRequestOptions(
          path: path,
          method: 'POST',
          data: data,
          queryParameters: queryParameters,
          headers: headers,
        ),
      );
}
