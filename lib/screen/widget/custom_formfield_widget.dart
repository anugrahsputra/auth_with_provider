import 'package:flutter/material.dart';

class CustomFormfield extends StatelessWidget {
  const CustomFormfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      keyboardType: keyboardType,
      keyboardAppearance: Brightness.light,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 16,
        ),
      ),
      validator: validator,
    );
  }
}
