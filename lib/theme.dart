import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color.fromARGB(255, 76, 255, 79),
    secondary: Colors.white
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 34, 87, 36),
    primary: Color.fromARGB(255, 47, 121, 50),
    secondary: Color.fromARGB(255, 34, 87, 36),
  )
);