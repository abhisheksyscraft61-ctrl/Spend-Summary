import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9B8FFF);
  static const Color primaryDark = Color(0xFF4834D4);

  // Accent
  static const Color accent = Color(0xFF00CEC9);
  static const Color accentWarm = Color(0xFFFD79A8);

  // Background
  static const Color background = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF1A1928);
  static const Color surfaceVariant = Color(0xFF252438);
  static const Color cardBg = Color(0xFF1E1D30);

  // Text
  static const Color textPrimary = Color(0xFFF8F8FF);
  static const Color textSecondary = Color(0xFFB2B0C9);
  static const Color textMuted = Color(0xFF6B698A);

  // Semantic
  static const Color income = Color(0xFF00B894);
  static const Color expense = Color(0xFFFF7675);
  static const Color warning = Color(0xFFFDCB6E);

  // Category colors
  static const Color catFood = Color(0xFFFF7675);
  static const Color catTravel = Color(0xFF74B9FF);
  static const Color catShopping = Color(0xFFA29BFE);
  static const Color catHealth = Color(0xFF55EFC4);
  static const Color catEntertainment = Color(0xFFFDCB6E);
  static const Color catBills = Color(0xFFFF9F43);
  static const Color catEducation = Color(0xFF0984E3);
  static const Color catOthers = Color(0xFFB2B0C9);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF252438), Color(0xFF1A1928)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
