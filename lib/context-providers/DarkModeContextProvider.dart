import 'package:flutter/material.dart';

class DarkMode {
  bool _active = true;

  void toggle() => _active = !_active;
  bool get active => _active;
  bool diff(DarkMode newValue) => _active != newValue._active;
}

class DarkModeContextProvider extends InheritedWidget {
  DarkModeContextProvider({required super.child});
  final DarkMode state = DarkMode();

  static DarkModeContextProvider? of(BuildContext contex) {
    return contex.dependOnInheritedWidgetOfExactType<DarkModeContextProvider>();
  }

  @override
  bool updateShouldNotify(covariant DarkModeContextProvider oldWidget) {
    return oldWidget.state.diff(state);
  }
}
