import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/modules/recovery/blocs/recovery_bloc.dart';
import 'package:flutter_dev_test/modules/recovery/blocs/recovery_state.dart';
import 'package:flutter_dev_test/shared/components/snackbar_helper.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_colors.dart';
import 'package:flutter_dev_test/shared/components/main_button.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_radius.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_spacements.dart';
import 'package:flutter_dev_test/shared/di/injectable_config.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class RecoverySecretPageArguments {
  final String username;
  final String password;

  RecoverySecretPageArguments({
    required this.username,
    required this.password,
  });
}

class RecoverySecretPage extends StatefulWidget {
  final RecoverySecretPageArguments arguments;
  const RecoverySecretPage({super.key, required this.arguments});

  @override
  State<RecoverySecretPage> createState() => _RecoverySecretPageState();
}

class _RecoverySecretPageState extends State<RecoverySecretPage> {
  final controller = getIt.get<RecoveryBloc>();
  final codeController = TextEditingController();
  bool isButtonEnabled = false;

  Future<void> submit() async {
    final RecoverySecretPageArguments(:username, :password) = widget.arguments;
    controller.recoverTotp(
      username,
      password,
      codeController.text,
    );
  }

  @override
  void initState() {
    super.initState();
    codeController.addListener(() {
      setState(() {
        isButtonEnabled = codeController.text.length == 6;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecoveryBloc, RecoveryState>(
      bloc: controller,
      listener: (context, state) {
        final goRouter = GoRouter.of(context);
        switch (state) {
          case RecoverySuccess(:final totpCode):
            goRouter.pop(totpCode);
            break;
          case RecoveryFailure(:final error):
            showCustomSnackBar(context, error);
            break;
          default:
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset('assets/icons/chevron_left.png'),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacements.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verificação',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Insira o código que foi enviado:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 72),
              Pinput(
                autofocus: true,
                controller: codeController,
                length: 6,
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 52,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: AppColors.buttonColor,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pinBackgroundColor,
                    border: Border.all(color: AppColors.buttonColor, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                defaultPinTheme: PinTheme(
                  width: 48.2,
                  height: 52,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: AppColors.buttonColor,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pinBackgroundColor,
                    border: Border.all(color: AppColors.pinBoderColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onCompleted: (_) => submit(),
              ),
              const SizedBox(height: 32),
              MainButton(
                onPressed: isButtonEnabled ? submit : null,
                backgroundColor: isButtonEnabled ? AppColors.buttonColor : AppColors.disabledButtonColor,
                child: Text(
                  'Confirmar',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                  onTap: () {
                    //Não foi passado nenhum comportamento.
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icons/message_question.png'),
                      const SizedBox(width: 8),
                      Text(
                        'Não recebi o código',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textOnBackground,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
