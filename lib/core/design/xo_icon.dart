import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Premium line icon from bundled transparent Lucide SVGs.
///
/// Usage: `const XoIcon('wifi', size: 24, color: Colors.white)`.
/// Available names: brain, film, music, puzzle, type, gamepad2, wifi,
/// users, zap, sparkles, crown, doorOpen, logIn, plus, minus, arrowLeft,
/// swords, check, x, copy, play, timer, loader2, lock, search, google.
class XoIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const XoIcon(this.name, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color ?? Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}
