// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../modules/login/blocs/login_bloc.dart' as _i873;
import '../../modules/recovery/blocs/recovery_bloc.dart' as _i574;
import '../../modules/login/datasource/authentication_datasource.dart' as _i710;
import '../adapters/http_client.dart' as _i866;
import '../adapters/storage.dart' as _i688;
import 'injectable_config.dart' as _i404;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i460.SharedPreferencesAsync>(() => registerModule.prefs);
    gh.lazySingleton<_i866.HttpClient>(() => registerModule.defaultHttpClient());
    gh.factory<_i688.StorageDao>(() => _i688.SharedPreferencesStorage(gh<_i460.SharedPreferencesAsync>()));
    gh.factory<_i710.AuthenticationDatasource>(() => _i710.AuthenticationDatasourceImpl(gh<_i866.HttpClient>()));
    gh.factory<_i574.RecoveryBloc>(() => _i574.RecoveryBloc(gh<_i710.AuthenticationDatasource>()));
    gh.factory<_i873.LoginBloc>(() => _i873.LoginBloc(gh<_i710.AuthenticationDatasource>()));
    return this;
  }
}

class _$RegisterModule extends _i404.RegisterModule {}
