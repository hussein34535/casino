import 'package:flutter/material.dart';
import 'package:game_show_app/core/design/xo_design.dart';

/// Shared premium text field for auth screens.
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
    OutlineInputBorder border(Color color, [double width = 1.5]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(fontWeight: FontWeight.w700, color: XoDesign.ink),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: XoDesign.muted),
        prefixIcon: Icon(prefix, color: XoDesign.muted),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF1F2F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border(const Color(0xFFE2E4EF)),
        enabledBorder: border(const Color(0xFFE2E4EF)),
        focusedBorder: border(XoDesign.indigo, 2),
        errorBorder: border(XoDesign.rose),
        focusedErrorBorder: border(XoDesign.rose, 2),
      ),
      validator: validator,
    );
  }
}
