import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoGradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final VoidCallback? onTap;

  const XoGradientContainer({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
    this.border,
    this.onTap,
  });

  const XoGradientContainer.gold({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  }) : colors = const [ComicColors.yellow, ComicColors.orange],
       begin = Alignment.topLeft,
       end = Alignment.bottomRight,
       boxShadow = null,
       border = null;

  const XoGradientContainer.dark({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  }) : colors = const [ComicColors.blue, ComicColors.purple],
       begin = Alignment.topLeft,
       end = Alignment.bottomRight,
       boxShadow = null,
       border = null;

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      foregroundDecoration: BoxDecoration(
        border: border ?? Border.all(color: ComicColors.black, width: 2.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );

    if (onTap != null) {
      container = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.white.withValues(alpha: 0.1),
        highlightColor: Colors.white.withValues(alpha: 0.05),
        child: container,
      );
    }

    return container;
  }
}
