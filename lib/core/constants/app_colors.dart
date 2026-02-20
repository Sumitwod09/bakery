import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Palette
  static const Color primary = Color(0xFFC8956C); // Warm terracotta / caramel
  static const Color primaryLight = Color(0xFFE8C4A8); // Light caramel
  static const Color primaryDark = Color(0xFF9E6B44); // Deep caramel
  static const Color secondary = Color(0xFFF5E6D3); // Cream / parchment
  static const Color accent = Color(0xFF8B4513); // Dark chocolate brown
  static const Color background = Color(0xFFFDFAF6); // Off-white
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textDark = Color(0xFF2C1810); // Dark espresso
  static const Color textMedium = Color(0xFF6B4226); // Medium brown
  static const Color textLight = Color(0xFF9E7B5E); // Light brown
  static const Color divider = Color(0xFFEDD8C4); // Soft divider

  // Semantic
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C1810), Color(0xFF8B4513)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDFAF6), Color(0xFFF5E6D3)],
  );

  // Dark Mode Palette
  static const Color backgroundDark = Color(0xFF1E1E1E); // Dark Grey/Black
  static const Color surfaceDark = Color(0xFF2C2C2C); // Slightly lighter grey
  static const Color textLightDark = Color(0xFFE0E0E0); // Off-white for text
  static const Color textDimDark =
      Color(0xFFAAAAAA); // Dimmed text for dark mode
}
