import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Display - Playfair Display (elegant serif for headings)
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.3,
  );

  // Headings
  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.35,
  );

  static TextStyle get headlineMedium => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.4,
  );

  static TextStyle get headlineSmall => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.4,
  );

  // Body - Lato (clean sans-serif)
  static TextStyle get bodyLarge => GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.6,
  );

  static TextStyle get bodySmall => GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.5,
  );

  // Labels
  static TextStyle get labelLarge => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.5,
  );

  static TextStyle get labelMedium => GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonText => GoogleFonts.lato(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static TextStyle get priceText => GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );

  static TextStyle get caption => GoogleFonts.lato(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    letterSpacing: 0.3,
  );
}
