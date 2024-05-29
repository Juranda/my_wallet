import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color.fromRGBO(2, 115, 234, 1),
    primary: Color.fromRGBO(25, 27, 52, 1),
    secondary: Colors.white,
    tertiary: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 50,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 30,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromRGBO(25, 27, 52, 1),
    primary: Color.fromRGBO(2, 115, 234, 1),
    secondary: Colors.white,
    tertiary: Colors.white,
  ),
  textTheme: TextTheme(
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
  ),
);

Color get lightTextColor => Color.fromRGBO(25, 27, 52, 1);
Color get darkTextColor => Colors.white;
