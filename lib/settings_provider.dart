import 'package:flutter/material.dart';
import 'package:my_wallet/theme.dart';

class SettingsProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _isDarkMode = false;
    notifyListeners();
  }

  void toggleDarkMode() {
    if (themeData == lightMode) {
      themeData = darkMode;
      _isDarkMode = true;
    } else {
      themeData = lightMode;
      _isDarkMode = false;
    }
  }
}
