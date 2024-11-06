import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../modules/home/views/home_page.dart';
import '../../modules/login/views/login_page.dart';
import '../../modules/recovery/views/recovery_secret_page.dart';
import 'app_routes.dart';

RouterConfig<Object> buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.loginPage,
    routes: [
      GoRoute(
        path: AppRoutes.loginPage,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.homePage,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.recoverySecretPage,
        builder: (context, state) {
          final arguments = state.extra as RecoverySecretPageArguments;
          return RecoverySecretPage(arguments: arguments);
        },
      ),
    ],
  );
}
