import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  // Load theme preference from SharedPreferences
  _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Toggle theme between light and dark
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  // Save theme preference to SharedPreferences
  _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Get the current theme data
  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Light theme
  final ThemeData _lightTheme = ThemeData(
    primaryColor: Color(0xFFD4A6B9),
    colorScheme: ColorScheme.light(
      primary: Color(0xFFD4A6B9),
      secondary: Color(0xFFF8E1EB),
    ),
    scaffoldBackgroundColor: Color.fromARGB(255, 254, 254, 254),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFD4A6B9),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
  );

  // Dark theme
  final ThemeData _darkTheme = ThemeData(
    primaryColor: Color(0xFFD4A6B9),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFD4A6B9),
      secondary: Color(0xFF8C6677),
      surface: Color(0xFF303030),
      background: Color(0xFF121212),
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF8C6677),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF303030),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}