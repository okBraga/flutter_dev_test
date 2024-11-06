import 'package:flutter/material.dart';
import 'package:flutter_dev_test/shared/components/tokens/app_radius.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final double borderRadius;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    this.validator,
    required this.fillColor,
    this.hintStyle,
    this.borderRadius = AppRadius.radiusMedium,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        fillColor: fillColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
            borderSide: BorderSide.none),
      ),
    );
  }
}
