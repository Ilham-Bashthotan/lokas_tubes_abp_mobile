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

// Dark mode colors
class AppColorsDark {
  AppColorsDark._();

  // Primary blue palette (adjusted for dark mode)
  static const primary = Color(0xFF64B5F6); // lighter blue for dark
  static const primaryLight = Color(0xFF90CAF9); // even lighter
  static const primaryDark = Color(0xFF1565C0); // keep original
  static const primarySurface = Color(0xFF1A237E); // dark blue surface
  static const accent = Color(0xFF81D4FA); // light cyan accent

  // Neutrals (dark mode)
  static const background = Color(0xFF121212); // true black
  static const surface = Color(0xFF1E1E1E); // dark surface
  static const cardBg = Color(0xFF2A2A2A); // dark card background
  static const divider = Color(0xFF3A3A3A); // darker divider
  static const border = Color(0xFF404040); // darker border

  // Text (dark mode)
  static const textPrimary = Color(0xFFE8EAF6); // light text
  static const textSecondary = Color(0xFFB0BEC5); // medium text
  static const textHint = Color(0xFF78909C); // hint text

  // Status (dark mode - adjusted for visibility)
  static const statusActive = Color(0xFF64B5F6); // light blue
  static const statusPending = Color(0xFFFFB74D); // light orange
  static const statusReturned = Color(0xFF81C784); // light green
  static const statusOverdue = Color(0xFFEF5350); // light red
  static const statusAvailable = Color(0xFF81C784); // light green
  static const statusBorrowed = Color(0xFFFFB74D); // light orange
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

// Dark mode text styles
class AppTextStylesDark {
  AppTextStylesDark._();

  static const headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColorsDark.textPrimary,
    letterSpacing: -0.5,
  );

  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColorsDark.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColorsDark.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColorsDark.textSecondary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColorsDark.textHint,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColorsDark.textSecondary,
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

// Dark mode decorations
class AppDecorationDark {
  AppDecorationDark._();

  static BoxDecoration card = BoxDecoration(
    color: AppColorsDark.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColorsDark.border, width: 1),
    boxShadow: [
      BoxShadow(
        color: AppColorsDark.primary.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration primaryCard = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColorsDark.primaryLight, AppColorsDark.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: AppColorsDark.primaryDark.withValues(alpha: 0.4),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration inputField = BoxDecoration(
    color: AppColorsDark.cardBg,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColorsDark.border, width: 1),
  );
}

ThemeData buildAppTheme({Brightness brightness = Brightness.light}) {
  final isDark = brightness == Brightness.dark;
  final colors = isDark ? _getDarkColors() : _getLightColors();

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors['primary'] as Color,
      brightness: brightness,
    ).copyWith(
      primary: colors['primary'] as Color,
      surface: colors['background'] as Color,
    ),
    scaffoldBackgroundColor: colors['background'] as Color,
    fontFamily: 'sans-serif',
    appBarTheme: AppBarTheme(
      backgroundColor: colors['surface'] as Color,
      foregroundColor: colors['textPrimary'] as Color,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colors['textPrimary'] as Color,
      ),
      iconTheme: IconThemeData(color: colors['textPrimary'] as Color),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
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
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => colors['primaryDark'] as Color,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors['primary'] as Color,
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(
          color: colors['border'] as Color,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors['cardBg'] as Color,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors['border'] as Color),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors['border'] as Color),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: colors['primary'] as Color,
          width: 1.5,
        ),
      ),
      hintStyle: TextStyle(
        color: colors['textHint'] as Color,
        fontSize: 14,
      ),
      labelStyle: TextStyle(
        color: colors['textSecondary'] as Color,
        fontSize: 13,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors['surface'] as Color,
      selectedItemColor: colors['primary'] as Color,
      unselectedItemColor: colors['textHint'] as Color,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors['primary'] as Color;
        }
        return colors['textHint'] as Color;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return (colors['primary'] as Color).withValues(alpha: 0.5);
        }
        return colors['border'] as Color;
      }),
    ),
  );
}

// Helper function to get light mode colors
Map<String, Color> _getLightColors() {
  return {
    'primary': AppColors.primary,
    'primaryLight': AppColors.primaryLight,
    'primaryDark': AppColors.primaryDark,
    'primarySurface': AppColors.primarySurface,
    'accent': AppColors.accent,
    'background': AppColors.background,
    'surface': AppColors.surface,
    'cardBg': AppColors.cardBg,
    'divider': AppColors.divider,
    'border': AppColors.border,
    'textPrimary': AppColors.textPrimary,
    'textSecondary': AppColors.textSecondary,
    'textHint': AppColors.textHint,
  };
}

// Helper function to get dark mode colors
Map<String, Color> _getDarkColors() {
  return {
    'primary': AppColorsDark.primary,
    'primaryLight': AppColorsDark.primaryLight,
    'primaryDark': AppColorsDark.primaryDark,
    'primarySurface': AppColorsDark.primarySurface,
    'accent': AppColorsDark.accent,
    'background': AppColorsDark.background,
    'surface': AppColorsDark.surface,
    'cardBg': AppColorsDark.cardBg,
    'divider': AppColorsDark.divider,
    'border': AppColorsDark.border,
    'textPrimary': AppColorsDark.textPrimary,
    'textSecondary': AppColorsDark.textSecondary,
    'textHint': AppColorsDark.textHint,
  };
}
