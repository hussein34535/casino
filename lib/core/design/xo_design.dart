import 'package:flutter/material.dart';

/// Premium XO design tokens.
///
/// Single source of truth for the new dark-luxe look: deep navy surfaces,
/// gold accents, soft shadows. No hard comic borders.
abstract final class XoDesign {
  // ── Palette ──────────────────────────────────────────────
  static const Color navy900 = Color(0xFF0B0C28);
  static const Color navy800 = Color(0xFF14153D);
  static const Color navy700 = Color(0xFF1E2052);
  static const Color indigo = Color(0xFF5B5FE9);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color gold = Color(0xFFF2B73B);
  static const Color goldDeep = Color(0xFFD9941A);
  static const Color mint = Color(0xFF34D399);
  static const Color rose = Color(0xFFF87171);
  static const Color sky = Color(0xFF38BDF8);
  static const Color pink = Color(0xFFEC4899);
  static const Color ink = Color(0xFF14142B);
  static const Color muted = Color(0xFF6E6E8A);
  static const Color onDarkMuted = Color(0xFFB7B7D2);
  static const Color card = Colors.white;
  static const Color glass = Color(0x14FFFFFF);

  // ── Gradients ────────────────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navy900, navy800, navy700],
  );
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, goldDeep],
  );
  static const LinearGradient indigoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [indigo, violet],
  );

  // ── Shape ────────────────────────────────────────────────
  static const double radius = 24;
  static const double radiusSm = 16;
  static const double radiusXs = 12;

  static BorderRadius get radiusAll => BorderRadius.circular(radius);
  static BorderRadius get radiusSmAll => BorderRadius.circular(radiusSm);

  // ── Shadows (soft, premium — no hard offsets) ────────────
  static List<BoxShadow> softShadow([Color color = Colors.black]) =>
      [BoxShadow(color: color.withValues(alpha: 0.16), blurRadius: 28, offset: const Offset(0, 14))];

  static List<BoxShadow> glowShadow(Color color) =>
      [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 8))];

  // ── Type ─────────────────────────────────────────────────
  static const TextStyle h1 = TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.3);
  static const TextStyle h2 = TextStyle(fontSize: 19, fontWeight: FontWeight.w800, height: 1.4);
  static const TextStyle body = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.6);
  static const TextStyle caption = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.5);
}
