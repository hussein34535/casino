import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoSnackbar {
  static void success(BuildContext context, String message) {
    _show(context, message, ComicColors.green);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, ComicColors.red);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, ComicColors.yellow);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, ComicColors.blue);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == ComicColors.green ? Icons.check_circle :
              color == ComicColors.red ? Icons.error :
              color == ComicColors.yellow ? Icons.warning :
              Icons.info,
              color: color, size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: ComicColors.white, fontWeight: FontWeight.w800))),
          ],
        ),
        backgroundColor: ComicColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
