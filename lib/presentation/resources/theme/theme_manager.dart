import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AppThemes {

  static AppThemes instance = AppThemes._();
  AppThemes._();

  ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[800],
    ),
  );

  // Persist theme state
Future<void> saveThemePreference(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', isDarkMode);
  // GlobalState.instance.isDarkMode.value = isDarkMode;
  this.isDarkMode.value = isDarkMode;
  }

// Load theme state
Future<bool> loadThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  // GlobalState.instance.isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  return prefs.getBool('isDarkMode') ?? false;

}
}




