import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/modules/login/blocs/login_state.dart';
import 'package:flutter_dev_test/modules/login/datasource/authentication_datasource.dart';
import 'package:flutter_dev_test/modules/login/datasource/request/login_request.dart';
import 'package:flutter_dev_test/modules/login/datasource/response/error/authentication_exception.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginBloc extends Cubit<AuthState> {
  final AuthenticationDatasource _authenticationDatasource;

  LoginBloc(this._authenticationDatasource) : super(AuthInitial());

  String? _totpCode;

  void setTotp(String value) => _totpCode = value;

  Future<void> login(String username, String password) async {
    try {
      emit(AuthLoading());
      final loginRequest = LoginRequest(
        username: username,
        password: password,
        totpCode: _totpCode,
      );
      await _authenticationDatasource.login(loginRequest);
      emit(AuthSuccess(''));
    } on AuthenticationException {
      if (_totpCode == null) {
        emit(AuthTotpRecovery());
        return;
      }
      emit(AuthFailure('Credenciais inválidas'));
    } catch (exception) {
      emit(AuthFailure('Ocorreu um erro ao realizar essa operaçao, tente novamente mais tarde'));
    }
  }
}
