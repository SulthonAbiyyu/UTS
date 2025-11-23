// constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);

  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color accentLight = Color(0xFF81C784);

  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceLight = Color(0xFFF0FAF4);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static const Color divider = Color(0xFFE6ECEB);
  static const Color shadow = Color(0x1A000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
