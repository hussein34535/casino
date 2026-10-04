import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoDivider extends StatelessWidget {
  final String? label;
  final double thickness;
  final Color? color;

  const XoDivider({super.key, this.label, this.thickness = 1, this.color});

  const XoDivider.withLabel(this.label, {super.key, this.thickness = 1, this.color});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Divider(
        thickness: thickness,
        color: color ?? ComicColors.black.withValues(alpha: 0.15),
        height: 1,
      );
    }

    return Row(
      children: [
        Expanded(child: Divider(thickness: thickness, color: color ?? ComicColors.black)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(label!, style: TextStyle(color: color ?? ComicColors.black, fontSize: 14, fontWeight: FontWeight.w700)),
        ),
        Expanded(child: Divider(thickness: thickness, color: color ?? ComicColors.black)),
      ],
    );
  }
}

class XoSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const XoSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(
            color: ComicColors.black,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          )),
          const Spacer(),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!, style: const TextStyle(color: ComicColors.blue, fontSize: 13, fontWeight: FontWeight.w900)),
            ),
        ],
      ),
    );
  }
}
