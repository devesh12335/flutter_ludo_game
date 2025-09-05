import 'package:ludo_game/presentation/resources/color_manager.dart';

// color_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color get primaryColor => ColorManager().primary;
  bool get isDarkMode => _isDarkMode;

  ColorProvider() {
    _loadThemeMode();
  }

  void updatePrimaryColor(Color color) {
    ColorManager().setPrimaryColor(color);
    notifyListeners(); // Notify widgets of color updates
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    if (_isDarkMode) {
      ColorManager.applyDarkTheme();
    } else {
      ColorManager.applyLightTheme();
    }

    await _saveThemeMode();
    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Load theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    if (_isDarkMode) {
      ColorManager.applyDarkTheme();
    } else {
      ColorManager.applyLightTheme();
    }

    notifyListeners();
  }
}
