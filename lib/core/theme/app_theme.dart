import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

/// Legacy color names kept for compatibility — values now match the
/// canonical Comic palette (see docs/DESIGN_SYSTEM.md).
class AppColors {
  /// Text / borders (was a dark navy background — backgrounds are cream now)
  static const Color darkBlue = Color(0xFF1A1A1A);
  static const Color yellow = ComicColors.yellow;
  static const Color red = ComicColors.red;
  static const Color grey = ComicColors.grey;
  static const Color outline = ComicColors.black;
  static const Color white = ComicColors.white;
  static const Color green = ComicColors.green;
  static const Color gold = Color(0xFFFFD700);
  static const Color teal = ComicColors.green;
  static const Color purple = ComicColors.purple;
  static const Color orange = ComicColors.orange;
  static const Color amber = ComicColors.yellow;
  static const Color surfaceDark = ComicColors.cream;
  static const Color cardDark = ComicColors.white;
}

/// Comic light theme — the ONLY theme used by the app (dark mode included),
/// so every screen renders in the same identity.
class AppTheme {
  static ThemeData get darkTheme => lightTheme;

  static ThemeData get lightTheme {
    const black = ComicColors.black;
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: ComicColors.cream,
      primaryColor: ComicColors.yellow,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.light(
        primary: ComicColors.yellow,
        secondary: ComicColors.blue,
        surface: ComicColors.cream,
        error: ComicColors.red,
        onPrimary: black,
        onSecondary: ComicColors.white,
        onSurface: black,
        onError: ComicColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ComicColors.blue,
        elevation: 0,
        centerTitle: true,
        foregroundColor: ComicColors.white,
        shape: Border(
          bottom: BorderSide(color: black, width: 3),
        ),
        titleTextStyle: TextStyle(
          color: ComicColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          fontFamily: 'Cairo',
        ),
      ),
      cardTheme: CardThemeData(
        color: ComicColors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: black, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ComicColors.yellow,
          foregroundColor: black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: black, width: 2.5),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ComicColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        hintStyle: TextStyle(color: ComicColors.grey.withValues(alpha: 0.9)),
        labelStyle: const TextStyle(color: black, fontWeight: FontWeight.w700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: black, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: black, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: ComicColors.blue, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: ComicColors.red, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: black, fontWeight: FontWeight.w900),
        headlineMedium: TextStyle(color: black, fontWeight: FontWeight.w900),
        headlineSmall: TextStyle(color: black, fontWeight: FontWeight.w900),
        titleLarge: TextStyle(color: black, fontWeight: FontWeight.w900),
        titleMedium: TextStyle(color: black, fontWeight: FontWeight.w800),
        titleSmall: TextStyle(color: black, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: black),
        bodyMedium: TextStyle(color: black),
        bodySmall: TextStyle(color: ComicColors.grey),
      ).apply(fontFamily: 'Cairo'),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: black,
        contentTextStyle: TextStyle(
          color: ComicColors.white,
          fontWeight: FontWeight.w800,
          fontFamily: 'Cairo',
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: black, width: 4),
        ),
        titleTextStyle: const TextStyle(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          fontFamily: 'Cairo',
        ),
        contentTextStyle: const TextStyle(
          color: black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
