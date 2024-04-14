import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color.fromARGB(255, 76, 255, 79),
    secondary: Colors.white,
    tertiary: Colors.white
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
      )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 34, 87, 36),
    primary: Color.fromARGB(255, 47, 121, 50),
    secondary: Color.fromARGB(255, 34, 87, 36),
    tertiary: Colors.white
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
      )
);


  Color get lightTextColor => Colors.white;
  Color get darkTextColor => Colors.black;