import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final Clip clipBehavior;

  const XoCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius = 20,
    this.backgroundColor,
    this.borderColor,
    this.gradientColors,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
  });

  XoCard.premium({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.width,
    this.height,
  }) : elevation = 6,
       backgroundColor = null,
       borderColor = ComicColors.black,
       gradientColors = [ComicColors.yellow.withValues(alpha: 0.15), ComicColors.orange.withValues(alpha: 0.08)],
       clipBehavior = Clip.antiAlias;

  @override
  State<XoCard> createState() => _XoCardState();
}

class _XoCardState extends State<XoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? ComicColors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor ?? ComicColors.black, width: 3),
        gradient: widget.gradientColors != null
            ? LinearGradient(colors: widget.gradientColors!, begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        boxShadow: widget.elevation != null
            ? const [BoxShadow(color: ComicColors.black, blurRadius: 0, offset: Offset(4, 4))]
            : null,
      ),
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      card = InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onHighlightChanged: (highlighted) => setState(() => _isPressed = highlighted),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: ComicColors.black.withValues(alpha: 0.08),
        highlightColor: ComicColors.black.withValues(alpha: 0.05),
        child: card,
      );
    }

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      child: card,
    );
  }
}

class XoSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final Color? accentColor;
  final Widget? trailing;

  const XoSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.accentColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return XoCard(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null || title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: accentColor ?? ComicColors.black),
                    const SizedBox(width: 8),
                  ],
                  Text(title, style: TextStyle(
                    color: accentColor ?? ComicColors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  )),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}
