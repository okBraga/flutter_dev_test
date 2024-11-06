import 'package:flutter_dev_test/shared/adapters/http_client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injectable_config.config.dart';

final getIt = GetIt.instance;
const _url = 'http://127.0.0.1:5000';

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
  // throwOnMissingDependencies: true,
)
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  HttpClient defaultHttpClient() => DioHttpClient.fromPath(_url);

  @lazySingleton
  SharedPreferencesAsync get prefs => SharedPreferencesAsync();
}
