import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

/// Legacy color names kept for compatibility — values now follow the
/// Game Show Stage palette (see docs/DESIGN_SYSTEM.md).
class AppColors {
  /// Dark stage background (legacy name kept).
  static const Color darkBlue = ComicColors.stage;
  static const Color yellow = ComicColors.yellow;
  static const Color red = ComicColors.red;
  static const Color grey = ComicColors.navMuted;
  static const Color outline = ComicColors.line;
  static const Color white = ComicColors.light;
  static const Color green = ComicColors.green;
  static const Color gold = ComicColors.yellow;
  static const Color teal = ComicColors.green;
  static const Color purple = ComicColors.purple;
  static const Color orange = ComicColors.orange;
  static const Color amber = ComicColors.yellow;
  static const Color surfaceDark = ComicColors.stage;
  static const Color cardDark = ComicColors.stage2;
}

/// Game Show Stage theme — dark TV-studio look, the ONLY theme used
/// by the app, so every screen renders in the same identity.
class AppTheme {
  static ThemeData get darkTheme => lightTheme;

  static ThemeData get lightTheme {
    const light = ComicColors.light;
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: kStageBodyFont,
      scaffoldBackgroundColor: ComicColors.stage,
      primaryColor: ComicColors.yellow,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.dark(
        primary: ComicColors.yellow,
        secondary: ComicColors.blue,
        surface: ComicColors.stage,
        error: ComicColors.red,
        onPrimary: ComicColors.ink,
        onSecondary: ComicColors.light,
        onSurface: light,
        onError: ComicColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: light,
        titleTextStyle: TextStyle(
          color: light,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          fontFamily: kStageBodyFont,
        ),
      ),
      cardTheme: CardThemeData(
        color: ComicColors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ComicColors.yellow,
          foregroundColor: const Color(0xFF201800),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: kStageBodyFont,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        hintStyle: const TextStyle(color: ComicColors.navMuted),
        labelStyle:
            const TextStyle(color: light, fontWeight: FontWeight.w700),
        floatingLabelStyle: const TextStyle(color: ComicColors.cyan),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.28), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.28), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: ComicColors.cyan, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: ComicColors.red, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: light, fontWeight: FontWeight.w900),
        headlineMedium: TextStyle(color: light, fontWeight: FontWeight.w900),
        headlineSmall: TextStyle(color: light, fontWeight: FontWeight.w900),
        titleLarge: TextStyle(color: light, fontWeight: FontWeight.w900),
        titleMedium: TextStyle(color: light, fontWeight: FontWeight.w800),
        titleSmall: TextStyle(color: light, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: light),
        bodyMedium: TextStyle(color: light),
        bodySmall: TextStyle(color: ComicColors.lightMuted),
      ).apply(fontFamily: kStageBodyFont),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ComicColors.ink,
        contentTextStyle: TextStyle(
          color: light,
          fontWeight: FontWeight.w800,
          fontFamily: kStageBodyFont,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ComicColors.stage2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: light,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          fontFamily: kStageBodyFont,
        ),
        contentTextStyle: const TextStyle(
          color: light,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: kStageBodyFont,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.14),
        thickness: 1.5,
      ),
    );
  }
}
