import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Color.fromRGBO(55, 152, 255, 1),
    primary: Color.fromRGBO(2, 115, 234, 1),
    secondary: Color.fromRGBO(25, 27, 52, 1),
    tertiary: Color.fromRGBO(6, 8, 34, 1),
    onBackground: Colors.black,
    onTertiary: Colors.white,
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(
  //     color: lightTextColor,
  //   ),
  //   bodyMedium: TextStyle(
  //     color: lightTextColor,
  //   ),
  //   bodySmall: TextStyle(
  //     color: lightTextColor,
  //   ),
  //   titleLarge: TextStyle(
  //     color: lightTextColor,
  //     fontSize: 50,
  //   ),
  //   titleMedium: TextStyle(
  //     color: lightTextColor,
  //     fontSize: 30,
  //   ),
  //   titleSmall: TextStyle(
  //     color: lightTextColor,
  //     fontSize: 20,
  //   ),
  // ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Color.fromRGBO(6, 8, 34, 1),
    primary: Color.fromRGBO(25, 27, 52, 1),
    secondary: Color.fromRGBO(2, 115, 234, 1),
    tertiary: Color.fromRGBO(55, 152, 255, 1),
    onBackground: Colors.white,
    onTertiary: Colors.white,
  ),
  // textTheme: TextTheme(
  //   bodyLarge: TextStyle(
  //     color: darkTextColor,
  //   ),
  //   bodyMedium: TextStyle(
  //     color: darkTextColor,
  //   ),
  //   bodySmall: TextStyle(
  //     color: darkTextColor,
  //   ),
  //   titleLarge: TextStyle(
  //     color: darkTextColor,
  //     fontSize: 50,
  //   ),
  //   titleMedium: TextStyle(
  //     color: darkTextColor,
  //     fontSize: 30,
  //   ),
  //   titleSmall: TextStyle(
  //     color: darkTextColor,
  //     fontSize: 20,
  //   ),
  // ),
);
