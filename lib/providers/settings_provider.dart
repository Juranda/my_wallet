import 'package:flutter/material.dart';
import 'package:my_wallet/theme.dart';

class SettingsProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _gameAudio = true;
  bool get gameAudio => _gameAudio;

  set gameAudio(bool value) {
    _gameAudio = value;
    notifyListeners();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
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
