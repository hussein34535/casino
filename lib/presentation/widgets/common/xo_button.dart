import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

enum XoButtonVariant { primary, secondary, danger, ghost, outlined, text }

class XoButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final XoButtonVariant variant;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool expanded;
  final double height;
  final double borderRadius;

  const XoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = XoButtonVariant.primary,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.expanded = true,
    this.height = 48,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);

    if (!expanded) return child;

    return SizedBox(width: double.infinity, height: height, child: child);
  }

  Widget _buildChild(BuildContext context) {
    final style = _getStyle(context);

    if (isLoading) {
      return _wrap(context, style, SizedBox(
        width: 24, height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: style.foregroundColor ?? ComicColors.black),
      ));
    }

    Widget labelWidget = Text(label, style: style.textStyle);

    if (icon != null || suffixIcon != null) {
      return _wrap(context, style, Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 20),
          if (icon != null) const SizedBox(width: 8),
          labelWidget,
          if (suffixIcon != null) const SizedBox(width: 8),
          if (suffixIcon != null) Icon(suffixIcon, size: 20),
        ],
      ));
    }

    return _wrap(context, style, labelWidget);
  }

  VoidCallback? get _hapticOnPressed {
    if (onPressed == null) return null;
    return () {
      HapticFeedback.lightImpact();
      onPressed!();
    };
  }

  Widget _wrap(BuildContext context, XoButtonStyle style, Widget child) {
    Widget button;

    switch (variant) {
      case XoButtonVariant.primary:
      case XoButtonVariant.secondary:
      case XoButtonVariant.danger:
        button = ElevatedButton(
          onPressed: isLoading ? null : _hapticOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: style.backgroundColor,
            foregroundColor: style.foregroundColor,
            textStyle: style.textStyle,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: const BorderSide(color: ComicColors.black, width: 2.5),
            ),
            elevation: 0,
            minimumSize: expanded ? const Size(double.infinity, 48) : null,
          ),
          child: child,
        );
        break;
      case XoButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : _hapticOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: style.foregroundColor,
            textStyle: style.textStyle,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: child,
        );
        break;
      case XoButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : _hapticOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: style.foregroundColor,
            textStyle: style.textStyle,
            side: BorderSide(color: style.foregroundColor ?? ComicColors.black, width: 2.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          child: child,
        );
        break;
      case XoButtonVariant.text:
        button = TextButton.icon(
          onPressed: isLoading ? null : _hapticOnPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: TextButton.styleFrom(
            foregroundColor: style.foregroundColor,
            textStyle: style.textStyle,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
        break;
    }

    if (!expanded) return button;
    return SizedBox(width: double.infinity, height: height, child: button);
  }

  XoButtonStyle _getStyle(BuildContext context) {
    const w900 = TextStyle(fontWeight: FontWeight.w900, fontSize: 16);
    switch (variant) {
      case XoButtonVariant.primary:
        return XoButtonStyle(ComicColors.yellow, ComicColors.black, 0, textStyle: w900);
      case XoButtonVariant.secondary:
        return XoButtonStyle(ComicColors.blue, ComicColors.white, 0, textStyle: w900);
      case XoButtonVariant.danger:
        return XoButtonStyle(ComicColors.red, ComicColors.white, 0, textStyle: w900);
      case XoButtonVariant.ghost:
        return XoButtonStyle(null, ComicColors.black, 0, textStyle: w900);
      case XoButtonVariant.outlined:
        return XoButtonStyle(null, ComicColors.black, 0, textStyle: w900);
      case XoButtonVariant.text:
        return XoButtonStyle(null, ComicColors.blue, 0, textStyle: w900);
    }
  }
}

class XoButtonStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final TextStyle? textStyle;

  XoButtonStyle(this.backgroundColor, this.foregroundColor, this.elevation, {this.textStyle});

  XoButtonStyle copyWith({Color? backgroundColor, Color? foregroundColor, double? elevation, TextStyle? textStyle}) {
    return XoButtonStyle(
      backgroundColor ?? this.backgroundColor,
      foregroundColor ?? this.foregroundColor,
      elevation ?? this.elevation,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
