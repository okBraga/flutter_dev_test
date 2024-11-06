import 'package:flutter_dev_test/modules/login/datasource/request/login_request.dart';
import 'package:flutter_dev_test/modules/login/datasource/request/recovery_request.dart';
import 'package:flutter_dev_test/modules/login/datasource/response/error/authentication_exception.dart';
import 'package:flutter_dev_test/modules/login/datasource/response/success/recovery_secret_response.dart';
import 'package:flutter_dev_test/shared/adapters/http_client.dart';
import 'package:injectable/injectable.dart';
import 'package:otp/otp.dart';

abstract class AuthenticationDatasource {
  Future<void> login(LoginRequest request);
  Future<RecoverySecretResponse> recoverySecret(RecoveryRequest request);
  Future<String> generateTotp(String secret);
}

@Injectable(as: AuthenticationDatasource)
class AuthenticationDatasourceImpl implements AuthenticationDatasource {
  final HttpClient _httpClient;

  AuthenticationDatasourceImpl(this._httpClient);

  void _handleAuthenticationErrors(HttpException exception) {
    final response = exception.response;
    if (response == null) {
      return;
    }

    throw AuthenticationException.fromHttpResponse(response);
  }

  @override
  Future<void> login(LoginRequest request) async {
    try {
      await _httpClient.post(
        path: '/auth/login',
        data: request.toJson(),
      );
    } on HttpException catch (exception) {
      _handleAuthenticationErrors(exception);
      rethrow;
    }
  }

  @override
  Future<RecoverySecretResponse> recoverySecret(RecoveryRequest request) async {
    try {
      final result = await _httpClient.post(
        path: '/auth/recovery-secret',
        data: request.toJson(),
      );

      return RecoverySecretResponse.fromJson(result.data as Map<String, dynamic>);
    } on HttpException catch (exception) {
      _handleAuthenticationErrors(exception);
      rethrow;
    }
  }

  @override
  Future<String> generateTotp(String secret) async {
    return OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 30,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
  }
}
