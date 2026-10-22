import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════
//  🎭 GAME SHOW STAGE DESIGN SYSTEM
//  Style: TV studio • Deep indigo stage • Spotlights
//          Yellow/gold accents • Big display numbers
//  Reference: docs/ui_templates/01-game-show.html
// ═══════════════════════════════════════════════

class ComicColors {
  // ── Stage (page backgrounds) ──
  static const Color stage = Color(0xFF161046);
  static const Color stage2 = Color(0xFF241A6B);
  static const Color ink = Color(0xFF14123A);

  // ── Brand accents ──
  static const Color yellow = Color(0xFFFFD60A);
  static const Color red = Color(0xFFFF2E4C);
  static const Color cyan = Color(0xFF3BE0FF);
  static const Color blue = Color(0xFF2E6BFF);
  static const Color green = Color(0xFF00D26A);
  static const Color purple = Color(0xFF5A3BFF);
  static const Color orange = Color(0xFFFF6B00);
  static const Color pink = Color(0xFFFF3DDD);
  static const Color gold = Color(0xFFFFD60A);
  static const Color skyBlue = cyan;

  // ── Surfaces ──
  static const Color white = Color(0xFFFFFFFF);
  /// Legacy name: page background → now the dark stage.
  static const Color cream = stage;

  // ── Text ──
  /// Text on white cards / on yellow buttons.
  static const Color black = ink;
  static const Color grey = Color(0xFF6A67A6);
  /// Primary text on the dark stage.
  static const Color light = Color(0xFFEDEBFF);
  /// Secondary text on the dark stage.
  static const Color lightMuted = Color(0xFFB9B4E8);
  /// Nav / inactive text on the dark stage.
  static const Color navMuted = Color(0xFF8F8AC4);

  // ── Lines & chrome ──
  static const Color line = Color(0xFFE7E5F7);
  static const Color outline = ink;
  static const Color goldShadow = Color(0xFFB79300);
}

/// Display face for big numbers / titles (scores, codes, timers).
const String kStageDisplayFont = 'Lalezar';
/// Body face.
const String kStageBodyFont = 'Cairo';

/// Stage page: deep indigo with two soft spotlight glows (like the HTML
/// radial gradients) — replaces the old halftone dots.
class ComicBackground extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color dotColor;

  const ComicBackground({
    super.key,
    required this.child,
    this.bgColor = ComicColors.stage,
    this.dotColor = ComicColors.stage2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.85, -1.0),
                radius: 1.1,
                colors: [dotColor.withValues(alpha: 0.9), bgColor],
                stops: const [0, 0.6],
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.9, -1.0),
                  radius: 0.9,
                  colors: [
                    dotColor.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.55],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// White show card: rounded, NO border, soft floating shadow.
class ComicCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double shadowOffset; // kept for API compat — ignored
  final double borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ComicCard({
    super.key,
    required this.child,
    this.color = ComicColors.white,
    this.shadowOffset = 6,
    this.borderRadius = 16,
    this.padding,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap!();
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              HapticFeedback.heavyImpact();
              onLongPress!();
            }
          : null,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x59000000),
              offset: Offset(0, 12),
              blurRadius: 30,
            ),
          ],
        ),
        // The app theme is dark (stage), so unstyled Text/Icon inside a card
        // would inherit light color — force a readable fallback per card tint.
        child: Builder(
          builder: (context) {
            final label =
                color.computeLuminance() > 0.55 ? ComicColors.black : Colors.white;
            return IconTheme.merge(
              data: IconThemeData(color: label),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: label),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Primary action button: yellow slab with a solid gold under-shadow
/// (press = it sinks). Dark label, no border.
class ComicButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final Widget? leading;
  final double shadowOffset;
  final double fontSize;

  const ComicButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = ComicColors.yellow,
    this.textColor,
    this.icon,
    this.leading,
    this.shadowOffset = 5,
    this.fontSize = 17,
  });

  @override
  State<ComicButton> createState() => _ComicButtonState();
}

class _ComicButtonState extends State<ComicButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final onYellow = widget.color.computeLuminance() > 0.5;
    final txt = widget.textColor ??
        (onYellow ? const Color(0xFF201800) : ComicColors.light);
    final under = onYellow ? ComicColors.goldShadow : Colors.black.withValues(alpha: 0.45);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = constraints.hasBoundedWidth;
        return GestureDetector(
          onTapDown: (_) {
            HapticFeedback.selectionClick();
            setState(() => _pressed = true);
          },
          onTapUp: (_) {
            setState(() => _pressed = false);
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: bounded ? double.infinity : null,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: under,
                  offset: Offset(0, _pressed ? 2 : widget.shadowOffset),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 10),
                ] else if (widget.icon != null) ...[
                  Icon(widget.icon, color: txt, size: 24),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: txt,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w900,
                      fontFamily: kStageBodyFont,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Translucent pill tag for the dark stage (category chips, labels).
class ComicTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const ComicTag({
    super.key,
    required this.label,
    this.color = ComicColors.yellow,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Solid pill (TV-show chip): dark label on bright colors, white on deep
    // colors — readable on both the stage and white cards.
    final fg = textColor ??
        (color.computeLuminance() > 0.55 ? ComicColors.ink : Colors.white);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          fontFamily: kStageBodyFont,
        ),
      ),
    );
  }
}

/// Circular count / notification badge with a soft glow.
class ComicBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const ComicBadge({
    super.key,
    required this.text,
    this.color = ComicColors.red,
    this.fontSize = 13.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.computeLuminance() > 0.5
              ? const Color(0xFF201800)
              : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: fontSize,
          fontFamily: kStageDisplayFont,
        ),
      ),
    );
  }
}

/// Score chip with the display font (Lalezar) — TV-scoreboard energy.
class ComicScoreChip extends StatelessWidget {
  final int score;
  final Color color;

  const ComicScoreChip({
    super.key,
    required this.score,
    this.color = ComicColors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    final darkText = color.computeLuminance() > 0.5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Text(
        '$score',
        style: TextStyle(
          color: darkText ? color : ComicColors.light,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          fontFamily: kStageDisplayFont,
          height: 1.1,
        ),
      ),
    );
  }
}

// Keep old names as aliases for backward compatibility
typedef UltraGlass = ComicCard;
typedef NeonButton = ComicButton;

/// Standard snackbar: floating, stage-ink bg, w800 text.
void showComicSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? ComicColors.red : ComicColors.ink,
    ));
}

class MeshGradientBackground extends StatelessWidget {
  final Widget child;
  const MeshGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) => ComicBackground(child: child);
}
