import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoScoreDisplay extends StatelessWidget {
  final int score;
  final double fontSize;
  final bool showIcon;
  final double iconSize;
  final bool animate;

  const XoScoreDisplay({
    super.key,
    required this.score,
    this.fontSize = 24,
    this.showIcon = true,
    this.iconSize = 20,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = score >= 10 ? ComicColors.green : (score > 0 ? ComicColors.black : ComicColors.red);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            score >= 10 ? Icons.star : (score > 0 ? Icons.trending_up : Icons.trending_down),
            color: color,
            size: iconSize,
          ),
          const SizedBox(width: 4),
        ],
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            '$score',
            key: ValueKey('score_$score'),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class XoBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final double fontSize;
  final IconData? icon;

  const XoBadge({
    super.key,
    required this.label,
    this.color,
    this.fontSize = 11,
    this.icon,
  });

  const XoBadge.yellow({super.key, required this.label, this.fontSize = 11})
    : color = ComicColors.yellow, icon = Icons.star;

  const XoBadge.red({super.key, required this.label, this.fontSize = 11})
    : color = ComicColors.red, icon = Icons.error;

  const XoBadge.green({super.key, required this.label, this.fontSize = 11})
    : color = ComicColors.green, icon = Icons.check_circle;

  const XoBadge.purple({super.key, required this.label, this.fontSize = 11})
    : color = ComicColors.purple, icon = Icons.auto_awesome;

  @override
  Widget build(BuildContext context) {
    final Color bg = color ?? ComicColors.grey;
    final Color fg = bg.computeLuminance() > 0.5 ? ComicColors.black : ComicColors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ComicColors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: ComicColors.black, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(
            fontSize: fontSize,
            color: fg,
            fontWeight: FontWeight.w900,
          )),
        ],
      ),
    );
  }
}

class XoStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  const XoStatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? ComicColors.orange, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black)),
        Text(label, style: const TextStyle(fontSize: 12, color: ComicColors.grey)),
      ],
    );
  }
}
