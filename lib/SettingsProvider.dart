import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
