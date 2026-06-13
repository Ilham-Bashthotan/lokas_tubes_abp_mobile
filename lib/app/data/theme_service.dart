import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeModeKey = 'app_theme_mode';

  // Save theme mode preference
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode.toString());
  }

  // Get saved theme mode preference
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey) ?? 'ThemeMode.system';
    
    return switch (themeModeString) {
      'ThemeMode.light' => ThemeMode.light,
      'ThemeMode.dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  // Clear theme preference (revert to system default)
  static Future<void> clearThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeModeKey);
  }
}
