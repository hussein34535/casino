import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

/// Shared Comic text field for auth screens (docs/DESIGN_SYSTEM.md §6).
class XoAuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefix;
  final bool obscure;
  final TextInputType? keyboard;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const XoAuthField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefix,
    this.obscure = false,
    this.keyboard,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 2.5]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(fontWeight: FontWeight.w800, color: ComicColors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w800, color: ComicColors.black),
        prefixIcon: Icon(prefix, color: ComicColors.grey),
        suffixIcon: suffix,
        filled: true,
        fillColor: ComicColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border(ComicColors.black),
        enabledBorder: border(ComicColors.black),
        focusedBorder: border(ComicColors.blue, 3),
        errorBorder: border(ComicColors.red),
        focusedErrorBorder: border(ComicColors.red, 3),
      ),
      validator: validator,
    );
  }
}
