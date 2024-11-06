import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/modules/login/blocs/login_bloc.dart';
import 'package:flutter_dev_test/modules/login/blocs/login_state.dart';
import 'package:flutter_dev_test/modules/recovery/views/recovery_secret_page.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_colors.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_spacements.dart';
import 'package:flutter_dev_test/shared/di/injectable_config.dart';
import 'package:flutter_dev_test/shared/navigation/app_routes.dart';
import 'package:flutter_dev_test/shared/components/snackbar_helper.dart';
import 'package:flutter_dev_test/modules/login/components/custom_text_button.dart';
import 'package:flutter_dev_test/modules/login/components/custom_text_form_field.dart';
import 'package:flutter_dev_test/shared/components/main_button.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool hasSecretTOTP = false;

  String get username => _emailController.text;
  String get password => _passwordController.text;

  final controller = getIt.get<LoginBloc>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();

    controller.login(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, AuthState>(
      bloc: controller,
      listener: (context, state) async {
        final goRouter = GoRouter.of(context);
        switch (state) {
          case AuthTotpRecovery():
            final generatedTotp = await goRouter.push(
              AppRoutes.recoverySecretPage,
              extra: RecoverySecretPageArguments(
                username: username,
                password: password,
              ),
            );
            if (generatedTotp == null) {
              return;
            }
            controller.setTotp(generatedTotp as String);
            break;
          case AuthFailure(:final error):
            showCustomSnackBar(context, error);
            break;
          case AuthSuccess():
            goRouter.pushReplacement(AppRoutes.homePage);
          default:
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 72),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset('assets/images/waves.svg'),
                            Image.asset('assets/images/login_image.png'),
                          ],
                        ),
                        const SizedBox(height: 38),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacements.defaultPadding),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  hintText: 'E-mail',
                                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                                  controller: _emailController,
                                  obscureText: false,
                                  fillColor: AppColors.surfaceBgLightBackground,
                                  validator: (value) {
                                    if (value == null || value.length < 5) {
                                      //A validação está assim devido ao formato do teste que aceita o login como 'admin', caso contrário implementaria um regex para verificar se o formato é compatível com um e-mail.
                                      return 'O e-mail deve ter pelo menos 5 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  hintText: 'Senha',
                                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                                  controller: _passwordController,
                                  obscureText: true,
                                  fillColor: AppColors.surfaceBgLightBackground,
                                  validator: (value) {
                                    if (value == null || value.length < 5) {
                                      return 'A senha deve ter pelo menos 5 caracteres';
                                    }
                                    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                                      return 'A senha deve conter letras e números';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacements.defaultPadding),
                                BlocBuilder<LoginBloc, AuthState>(
                                    bloc: controller,
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;
                                      return MainButton(
                                        onPressed: submit,
                                        backgroundColor: AppColors.buttonColor,
                                        isLoading: isLoading,
                                        child: Text(
                                          'Entrar',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomTextButton(
                          child: Text(
                            'Esqueci a senha',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.buttonColor,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 38),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
