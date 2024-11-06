import 'package:flutter/material.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_radius.dart';

class MainButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final bool isLoading;

  const MainButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : child,
      ),
    );
  }
}
