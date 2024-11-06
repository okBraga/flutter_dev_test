import 'package:flutter/material.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_colors.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_radius.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_spacements.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: AppColors.snackBarColor,
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacements.defaultPadding, vertical: 8),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
    ),
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
