import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary blue palette
  static const primary = Color(0xFF1565C0); // deep blue
  static const primaryLight = Color(0xFF1E88E5); // medium blue
  static const primaryDark = Color(0xFF0D47A1); // darker blue for gradient
  static const primarySurface = Color(0xFFE3F2FD); // light blue surface
  static const accent = Color(0xFF0288D1); // cyan-blue accent

  // Neutrals
  static const background = Color(0xFFF5F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const cardBg = Color(0xFFF8FBFF);
  static const divider = Color(0xFFDDE7F5);
  static const border = Color(0xFFBDD4F0);

  // Text
  static const textPrimary = Color(0xFF0D1B40);
  static const textSecondary = Color(0xFF4A6080);
  static const textHint = Color(0xFF8FA8C8);

  // Status
  static const statusActive = Color(0xFF1565C0);
  static const statusPending = Color(0xFFF57C00);
  static const statusReturned = Color(0xFF388E3C);
  static const statusOverdue = Color(0xFFD32F2F);
  static const statusAvailable = Color(0xFF388E3C);
  static const statusBorrowed = Color(0xFFF57C00);
}

class AppTextStyles {
  AppTextStyles._();

  static const headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );
}

class AppDecoration {
  AppDecoration._();

  static BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.border, width: 1),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.06),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration primaryCard = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primaryLight, AppColors.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryDark.withValues(alpha: 0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration inputField = BoxDecoration(
    color: AppColors.cardBg,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.border, width: 1),
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(primary: AppColors.primary, surface: AppColors.background),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'sans-serif',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // We'll use Ink for gradients
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) => AppColors.primaryDark),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
