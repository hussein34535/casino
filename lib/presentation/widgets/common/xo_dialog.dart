import 'package:flutter/material.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoDialog {
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    side: BorderSide(color: ComicColors.black, width: 4),
  );

  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'تأكيد',
    String cancelLabel = 'إلغاء',
    Color? confirmColor,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: _shape,
        title: Text(title, style: const TextStyle(color: ComicColors.black, fontWeight: FontWeight.w900)),
        content: Text(message, style: const TextStyle(color: ComicColors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(foregroundColor: ComicColors.black),
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger ? AppColors.red : confirmColor ?? ComicColors.yellow,
              foregroundColor: isDanger ? ComicColors.white : ComicColors.black,
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  static Future<String?> prompt(
    BuildContext context, {
    required String title,
    String? hintText,
    String? initialValue,
    String confirmLabel = 'حفظ',
    String cancelLabel = 'إلغاء',
  }) {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: _shape,
        title: Text(title, style: const TextStyle(color: ComicColors.black, fontWeight: FontWeight.w900)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: ComicColors.black, width: 2.5),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: ComicColors.black),
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: _shape,
        title: Text(title, style: const TextStyle(color: ComicColors.black, fontWeight: FontWeight.w900)),
        content: Text(message, style: const TextStyle(color: ComicColors.black)),
        actions: [
          if (actionLabel != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                onAction?.call();
              },
              child: Text(actionLabel),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: ComicColors.black),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
