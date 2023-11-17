import 'package:flutter/material.dart';

class Styles {
  static ThemeData get lightThemeData => ThemeData(
        textTheme: textThemeLight,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 76, 255, 79),
        ).copyWith(
          primary: Color.fromARGB(255, 76, 255, 79),
          secondary: Colors.white,
        ),
      );

  static ThemeData get darkThemeData => ThemeData(
        textTheme: textThemeDark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 34, 87, 36),
        ).copyWith(
          primary: Color.fromARGB(255, 47, 121, 50),
          secondary: Color.fromARGB(255, 27, 63, 27),
        ),
      );

  static TextTheme get textThemeLight => TextTheme(
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
        bodySmall: TextStyle(),
        titleLarge: TextStyle(
          fontSize: 50,
        ),
        titleMedium: TextStyle(
          fontSize: 30,
        ),
        titleSmall: TextStyle(
          fontSize: 20,
        ),
      );

  static TextTheme get textThemeDark => TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );

  static get linkTextStyle => TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
        decoration: TextDecoration.underline,
        decorationColor: Colors.white,
      );

  static Color get lightTextColor => Colors.white;
  static Color get darkTextColor => Colors.black;
}
