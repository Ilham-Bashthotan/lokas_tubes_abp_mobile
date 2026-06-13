import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/theme_service.dart';

class ThemeController extends GetxController {
  final themeMode = ThemeMode.system.obs;
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedTheme();
  }

  // Load saved theme preference from SharedPreferences
  Future<void> loadSavedTheme() async {
    final saved = await ThemeService.getThemeMode();
    themeMode.value = saved;
    _updateDarkModeFlag();
  }

  // Toggle between light and dark mode
  void toggleDarkMode() {
    if (themeMode.value == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  // Set a specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await ThemeService.saveThemeMode(mode);
    _updateDarkModeFlag();
    
    // Apply the theme change to the GetMaterialApp
    Get.changeThemeMode(mode);
  }

  // Update isDarkMode flag based on current themeMode
  void _updateDarkModeFlag() {
    if (themeMode.value == ThemeMode.dark) {
      isDarkMode.value = true;
    } else if (themeMode.value == ThemeMode.light) {
      isDarkMode.value = false;
    } else {
      // ThemeMode.system - use light as default display (actual theme handled by GetMaterialApp)
      isDarkMode.value = false;
    }
  }

  // Get human-readable theme name for display
  String getThemeDisplayName() {
    return switch (themeMode.value) {
      ThemeMode.light => 'Terang',
      ThemeMode.dark => 'Gelap',
      ThemeMode.system => 'Sistem',
    };
  }
}
