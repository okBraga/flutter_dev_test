import 'package:flutter_dev_test/shared/adapters/http_client.dart';

enum AuthenticationErrorCode {
  invalidCredentials('Invalid credentials'),
  invalidPassword('Invalid password'),
  invalidCode('Invalid recovery code'),
  invalidTotpCode('Invalid TOTP code'),
  userNotFound('User not found');

  const AuthenticationErrorCode(this.code);

  final String code;

  static AuthenticationErrorCode valueOf(String message) {
    return AuthenticationErrorCode.values.firstWhere((value) => value.code == message);
  }
}

class AuthenticationException implements Exception {
  final AuthenticationErrorCode code;

  AuthenticationException(this.code);

  factory AuthenticationException.fromHttpResponse(HttpResponse response) {
    final data = response.data as Map;
    final code = AuthenticationErrorCode.valueOf(data['message']);
    return AuthenticationException(code);
  }
}
