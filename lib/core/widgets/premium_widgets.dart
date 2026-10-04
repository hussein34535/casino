import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════
//  🎨 COMIC GAME DESIGN SYSTEM
//  Style: Cartoonish • Flat • Bold • Vibrant
// ═══════════════════════════════════════════════

class ComicColors {
  static const Color yellow    = Color(0xFFFFD600);
  static const Color orange    = Color(0xFFFF6B00);
  static const Color red       = Color(0xFFFF1F4B);
  static const Color blue      = Color(0xFF0066FF);
  static const Color skyBlue   = Color(0xFF00C2FF);
  static const Color green     = Color(0xFF00D26A);
  static const Color purple    = Color(0xFF8B2BE2);
  static const Color pink      = Color(0xFFFF3DDD);
  static const Color grey      = Color(0xFF888888);
  static const Color black     = Color(0xFF1A1A1A);
  static const Color white     = Color(0xFFFFFBF0);
  static const Color cream     = Color(0xFFFFF8DC);
}

/// Flat card with thick black border + hard offset shadow (comic 3D pop)
class ComicCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double shadowOffset;
  final double borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ComicCard({
    super.key,
    required this.child,
    this.color = ComicColors.white,
    this.shadowOffset = 6,
    this.borderRadius = 20,
    this.padding,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () {
        HapticFeedback.lightImpact();
        onTap!();
      } : null,
      onLongPress: onLongPress != null ? () {
        HapticFeedback.heavyImpact();
        onLongPress!();
      } : null,
      child: Container(
        margin: EdgeInsets.only(bottom: shadowOffset, right: shadowOffset),
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: ComicColors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: ComicColors.black,
              offset: Offset(shadowOffset, shadowOffset),
              blurRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Big juicy button with thick border, hard shadow — looks EXTRUDED!
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
    this.fontSize = 18,
  });

  @override
  State<ComicButton> createState() => _ComicButtonState();
}

class _ComicButtonState extends State<ComicButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final txt = widget.textColor ?? ComicColors.black;

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
            margin: EdgeInsets.only(
              bottom: _pressed ? 0 : widget.shadowOffset,
              right:  _pressed ? 0 : widget.shadowOffset,
              top:    _pressed ? widget.shadowOffset : 0,
              left:   _pressed ? widget.shadowOffset : 0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: ComicColors.black, width: 3),
              boxShadow: _pressed ? [] : [
                BoxShadow(
                  color: ComicColors.black,
                  offset: Offset(widget.shadowOffset, widget.shadowOffset),
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
                      letterSpacing: 0.5,
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


/// Halftone dot pattern background (comic book feel)
class ComicBackground extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color dotColor;

  const ComicBackground({
    super.key,
    required this.child,
    this.bgColor = const Color(0xFFFFF9E6),
    this.dotColor = const Color(0xFFFFE066),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color
        Positioned.fill(child: Container(color: bgColor)),
        // Halftone dots via custom painter
        Positioned.fill(
          child: CustomPaint(
            painter: _HalftonePainter(dotColor: dotColor),
          ),
        ),
        child,
      ],
    );
  }
}

class _HalftonePainter extends CustomPainter {
  final Color dotColor;
  _HalftonePainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor.withValues(alpha: 0.15);
    const spacing = 28.0;
    const radius = 3.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Comic speech-bubble style label tag
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ComicColors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? ComicColors.black,
          fontWeight: FontWeight.w900,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Star burst / badge widget (wow! or new! badge in comics)
class ComicBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const ComicBadge({
    super.key, 
    required this.text, 
    this.color = ComicColors.red,
    this.fontSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ComicColors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

/// Comic score chip (for player scores)
class ComicScoreChip extends StatelessWidget {
  final int score;
  final Color color;

  const ComicScoreChip({super.key, required this.score, this.color = ComicColors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: ComicColors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Text(
        '$score PTS',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// Keep old names as aliases for backward compatibility
typedef UltraGlass = ComicCard;
typedef NeonButton = ComicButton;

/// Standard snackbar (docs/DESIGN_SYSTEM.md §7): floating, black bg, w800 text.
void showComicSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? ComicColors.red : ComicColors.black,
    ));
}

class MeshGradientBackground extends StatelessWidget {
  final Widget child;
  const MeshGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) => ComicBackground(child: child);
}
