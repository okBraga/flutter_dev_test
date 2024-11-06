import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/modules/login/datasource/request/recovery_request.dart';
import 'package:injectable/injectable.dart';
import '../../login/datasource/authentication_datasource.dart';
import '../../login/datasource/response/error/authentication_exception.dart';
import 'recovery_state.dart';

@injectable
class RecoveryBloc extends Cubit<RecoveryState> {
  final AuthenticationDatasource _authenticationDatasource;
  String? totpSecret;

  RecoveryBloc(this._authenticationDatasource) : super(RecoveryInitial());

  void recoverTotp(String username, String password, String recoveryCode) async {
    try {
      emit(RecoveryLoading());

      final recoveryRequest = RecoveryRequest(
        username: username,
        password: password,
        code: recoveryCode,
      );

      final response = await _authenticationDatasource.recoverySecret(recoveryRequest);
      final totpCode = await _authenticationDatasource.generateTotp(response.totpSecret);
      emit(RecoverySuccess(totpCode: totpCode));
    } on AuthenticationException catch (exception) {
      final code = exception.code;
      final message = switch (code) {
        AuthenticationErrorCode.invalidTotpCode => 'Código inválido',
        AuthenticationErrorCode.invalidCode => 'Código inválido',
        AuthenticationErrorCode.invalidCredentials || AuthenticationErrorCode.invalidPassword || AuthenticationErrorCode.userNotFound => 'Login ou senha incorretos',
      };
      emit(RecoveryFailure(message));
    } catch (exception) {
      emit(RecoveryFailure('Ocorreu um erro ao realizar essa operaçao, tente novamente mais tarde'));
    }
  }
}
