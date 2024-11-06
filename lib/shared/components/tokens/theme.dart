import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_font_size.dart';
import 'app_font_weights.dart';

ThemeData buildTheme() {
  return ThemeData(
    fontFamily: 'PlusJakartaSans',
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    textTheme: const TextTheme(
      // Callout
      bodyLarge: TextStyle(
        fontSize: AppFontSizes.fontTextField,
        fontWeight: AppFontWeights.medium,
        height: 20.0 / 12.0,
        letterSpacing: -0.009,
        color: AppColors.textOnBackground,
      ),
      // Label
      bodyMedium: TextStyle(
        fontSize: AppFontSizes.fontButton,
        fontWeight: AppFontWeights.semiBold,
        height: 20.0 / 13.0,
        color: AppColors.textInvert,
      ),
      // TextPrimary
      displayLarge: TextStyle(
        fontSize: AppFontSizes.textPrimary,
        fontWeight: AppFontWeights.semiBold,
        height: 32.0 / 20.0,
        letterSpacing: -0.017,
        color: AppColors.textPrimary,
      ),
      // Subheading
      titleMedium: TextStyle(
        fontSize: AppFontSizes.textSecondary,
        fontWeight: AppFontWeights.medium,
        height: 20.0 / 14.0,
        letterSpacing: -0.007,
        color: AppColors.textSecondary,
      ),
    ),
  );
}
