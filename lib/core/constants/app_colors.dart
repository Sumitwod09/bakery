import 'package:flutter/material.dart';

/// Anmol Bakery — Premium Design System
/// Light Mode: "Warm Artisan" | Dark Mode: "Luxury Cocoa"
class AppColors {
  AppColors._();

  // ── Light Mode — Warm Artisan ───────────────────────────────────────────

  // Brand
  static const Color primary = Color(0xFF4A2C2A); // Chocolate Brown
  static const Color secondary = Color(0xFFC89B3C); // Soft Gold
  static const Color accent = Color(0xFFF6C1C7); // Rose Cream
  static const Color highlight = Color(0xFFF4A261); // Bakery Peach

  // Aliases used across legacy widgets
  static const Color primaryLight =
      Color(0xFFE6B76E); // Metallic gold (dark mode primary)
  static const Color primaryDark = Color(0xFF3A1F1E); // Hover brown

  // Background system
  static const Color background = Color(0xFFF8EFE5); // Main background
  static const Color surface = Color(0xFFFFFFFF); // Cards
  static const Color softSection = Color(0xFFF3E6D8); // Soft section bg
  static const Color footerBg = Color(0xFF2E1A1A); // Footer

  // Text
  static const Color textDark = Color(0xFF2E1A1A); // Primary text
  static const Color textMedium = Color(0xFF6D4C41); // Secondary text
  static const Color textLight = Color(0xFFA1887F); // Muted text

  // UI States
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFF4A261);
  static const Color error = Color(0xFFD64545);
  static const Color info = Color(0xFF5C6BC0);

  // Divider / border
  static const Color divider = Color(0xFFE8D5C4);

  // ── Dark Mode — Luxury Cocoa ────────────────────────────────────────────

  // Brand (dark)
  static const Color primaryDarkMode = Color(0xFFE6B76E); // Warm gold
  static const Color secondaryDarkMode = Color(0xFFF4A261);
  static const Color accentDarkMode = Color(0xFFD98C8C);

  // Backgrounds (dark)
  static const Color backgroundDark = Color(0xFF1C1412); // Main bg
  static const Color surfaceDark = Color(0xFF2A1F1C); // Cards
  static const Color elevatedCardDark = Color(0xFF332623); // Elevated
  static const Color footerDark = Color(0xFF120D0C);

  // Text (dark)
  static const Color textLightDark = Color(0xFFF5EDE6); // Primary
  static const Color textDimDark = Color(0xFFD7C2B8); // Secondary
  static const Color textMutedDark = Color(0xFFA58E84); // Muted

  // UI States (dark adjusted)
  static const Color successDark = Color(0xFF66BB6A);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color infoDark = Color(0xFF7986CB);

  // Divider (dark)
  static const Color dividerDark = Color(0xFF3D2E2A);

  // ── Gradients ───────────────────────────────────────────────────────────

  static const LinearGradient heroGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8EFE5), Color(0xFFF3E6D8), Color(0xFFF6C1C7)],
  );

  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C1412), Color(0xFF2A1F1C), Color(0xFF332623)],
  );

  /// Metallic gold — use on CTA buttons, dividers, price highlights
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC89B3C), Color(0xFFE6B76E), Color(0xFFB88A2F)],
  );

  // Legacy alias (hero slider uses this)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E1A1A), Color(0xFF4A2C2A)],
  );

  // ── Theme-aware helpers ─────────────────────────────────────────────────

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Scaffold / page background
  static Color bg(BuildContext context) =>
      isDark(context) ? backgroundDark : background;

  /// Card / container surface
  static Color surfaceColor(BuildContext context) =>
      isDark(context) ? surfaceDark : surface;

  /// Elevated card (one level above surface in dark mode)
  static Color elevatedCard(BuildContext context) =>
      isDark(context) ? elevatedCardDark : surface;

  /// Soft section fill (about, testimonials, etc.)
  static Color secondaryFill(BuildContext context) =>
      isDark(context) ? elevatedCardDark : softSection;

  /// Primary text color
  static Color textPrimary(BuildContext context) =>
      isDark(context) ? textLightDark : textDark;

  /// Secondary text color
  static Color textSecondary(BuildContext context) =>
      isDark(context) ? textDimDark : textMedium;

  /// Muted / tertiary text
  static Color textTertiary(BuildContext context) =>
      isDark(context) ? textMutedDark : textLight;

  /// Divider / border
  static Color dividerColor(BuildContext context) =>
      isDark(context) ? dividerDark : divider;

  /// Accent text / brand heading color
  static Color accentColor(BuildContext context) =>
      isDark(context) ? primaryDarkMode : primary;

  /// Shadow color
  static Color shadowColor(BuildContext context) => isDark(context)
      ? Colors.black.withValues(alpha: 0.4)
      : Colors.black.withValues(alpha: 0.07);

  /// Primary interactive color (brand brown in light, warm gold in dark)
  static Color brandPrimary(BuildContext context) =>
      isDark(context) ? primaryDarkMode : primary;

  /// Gold accent (secondary brand)
  static Color goldAccent(BuildContext context) =>
      isDark(context) ? secondaryDarkMode : secondary;
}
