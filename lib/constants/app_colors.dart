import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /* Primary Colors - Koyu Lacivert Tema */
  static const Color primary = Color(0xFF0A1929);
  static const Color primaryDark = Color(0xFF050E18);
  static const Color primaryLight = Color(0xFF1A2F42);
  
  /* Accent Colors */
  static const Color accent = Color(0xFF4FC3F7);
  static const Color accentDark = Color(0xFF0288D1);
  static const Color accentLight = Color(0xFF81D4FA);
  
  /* Secondary Colors */
  static const Color secondary = Color(0xFF7C4DFF);
  static const Color secondaryDark = Color(0xFF5E35B1);
  static const Color secondaryLight = Color(0xFFB39DDB);
  
  /* Background Colors */
  static const Color background = Color(0xFF0A1929);
  static const Color surface = Color(0xFF132F4C);
  static const Color cardBackground = Color(0xFF1A2F42);
  
  /* Text Colors */
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textTertiary = Color(0xFF78909C);
  static const Color textHint = Color(0xFF546E7A);
  
  /* Status Colors */
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFCA28);
  static const Color info = Color(0xFF42A5F5);
  
  /* Rating Colors */
  static const Color ratingGold = Color(0xFFFFD700);
  static const Color ratingStarFilled = Color(0xFFFFB300);
  static const Color ratingStarEmpty = Color(0xFF455A64);
  
  /* Divider & Border */
  static const Color divider = Color(0xFF263238);
  static const Color border = Color(0xFF37474F);
  static const Color borderLight = Color(0xFF455A64);
  
  /* Gradient Colors */
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A1929),
      Color(0xFF1A2F42),
    ],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4FC3F7),
      Color(0xFF0288D1),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A2F42),
      Color(0xFF0F1E2E),
    ],
  );
  
  /* Overlay Colors */
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xCC000000);
  
  /* Shimmer Colors (Loading) */
  static const Color shimmerBase = Color(0xFF1A2F42);
  static const Color shimmerHighlight = Color(0xFF2A3F52);
}
