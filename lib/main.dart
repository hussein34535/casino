import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_show_app/providers/game_provider.dart';
import 'package:game_show_app/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:game_show_app/screens/game_select_screen.dart'; // سيتم إلغاء التعليق لاحقًا
// import 'package:game_show_app/screens/game_screen.dart'; // سيتم إلغاء التعليق لاحقًا
// import 'package:game_show_app/screens/results_screen.dart'; // سيتم إلغاء التعليق لاحقًا

// Define the color palette inspired by "Karaset El Al'ab"
const Color karasetDarkBlue = Color(0xFF1A237E); // Deep dark blue
const Color karasetYellow = Color(0xFFFFCA28); // Bright yellow/gold
const Color karasetRed = Color(0xFFE53935); // Bright red
const Color karasetGrey = Color(0xFFB0BEC5); // Light grey/silver
const Color karasetOutline = Colors.black87; // For outlines
const Color karasetWhite = Colors.white;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'كازينو الألعاب',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: karasetDarkBlue,
        primaryColor: karasetYellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: karasetYellow,
          secondary: karasetRed,
          background: karasetDarkBlue,
          surface: karasetDarkBlue,
          onPrimary: karasetOutline,
          onSecondary: karasetWhite,
          onBackground: karasetWhite,
          onSurface: karasetWhite,
          error: karasetRed,
          onError: karasetWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: karasetDarkBlue,
          elevation: 0,
          foregroundColor: karasetWhite,
          titleTextStyle: TextStyle(
            color: karasetWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
          iconTheme: IconThemeData(color: karasetWhite),
        ),
        cardTheme: CardTheme(
          color: karasetDarkBlue.withOpacity(0.6),
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: karasetGrey.withOpacity(0.3), width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: karasetDarkBlue.withOpacity(0.5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          hintStyle: TextStyle(color: karasetGrey.withOpacity(0.8)),
          labelStyle: const TextStyle(color: karasetYellow),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: karasetGrey.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: karasetGrey.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: karasetYellow, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: karasetRed, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: karasetRed, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: karasetYellow,
            foregroundColor: karasetOutline,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: karasetWhite,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge:
              TextStyle(color: karasetWhite, fontWeight: FontWeight.bold),
          headlineMedium:
              TextStyle(color: karasetWhite, fontWeight: FontWeight.bold),
          headlineSmall:
              TextStyle(color: karasetWhite, fontWeight: FontWeight.bold),
          titleLarge:
              TextStyle(color: karasetWhite, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: karasetWhite),
          titleSmall: TextStyle(color: karasetWhite),
          bodyLarge: TextStyle(color: karasetWhite),
          bodyMedium: TextStyle(color: karasetWhite),
          bodySmall: TextStyle(color: karasetGrey),
          labelLarge:
              TextStyle(color: karasetOutline, fontWeight: FontWeight.bold),
        ).apply(),
        listTileTheme: ListTileThemeData(
          iconColor: karasetYellow,
          titleTextStyle: const TextStyle(
            color: karasetWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
          subtitleTextStyle: TextStyle(
            color: karasetGrey,
            fontFamily: 'Cairo',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: karasetGrey.withOpacity(0.3),
          thickness: 1,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(karasetOutline),
          fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return karasetRed;
            }
            return karasetGrey;
          }),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return karasetRed;
            }
            return karasetGrey;
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return karasetRed;
            }
            return karasetGrey;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return karasetRed.withOpacity(0.5);
            }
            return karasetDarkBlue;
          }),
        ),
        iconTheme: const IconThemeData(
          color: karasetWhite,
          size: 24.0,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: karasetDarkBlue.withOpacity(0.5),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: karasetGrey.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: karasetGrey.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: karasetYellow, width: 2.0),
            ),
          ),
          textStyle: const TextStyle(color: karasetWhite),
          menuStyle: MenuStyle(
            backgroundColor:
                MaterialStateProperty.all(karasetDarkBlue.withRed(50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],
      locale: const Locale('ar'),
      home: const HomeScreen(),
    );
  }
}
