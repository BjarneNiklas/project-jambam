import 'package:flutter/material.dart';

class AppColors {
  // Palette from style_guide.md
  static const Color primary = Color(0xFF673AB7); // Deep Purple
  static const Color primaryLight = Color(0xFFD1C4E9); // Light Purple
  static const Color secondary = Color(0xFFFFC107); // Amber
  static const Color accent = Color(0xFF009688); // Teal
  static const Color background = Color(0xFFF7F7F9); // Off-White
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF212121); // Dark Grey
  static const Color textSecondary = Color(0xFF757575); // Medium Grey
  static const Color error = Color(0xFFD32F2F); // Red

  // Dark Theme specific colors (can be adjusted)
  static const Color backgroundDark = Color(0xFF121212); // Common dark theme background
  static const Color surfaceDark = Color(0xFF1E1E1E); // Common dark theme surface (slightly lighter than background)
  static const Color textPrimaryDark = Color(0xFFE0E0E0); // Light grey for text on dark backgrounds
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Medium light grey for secondary text

  // Contrast colors (primarily for text/icons on colored backgrounds)
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = textPrimary; // Dark Grey on Amber
  static const Color onAccent = Colors.white; // White on Teal
  static const Color onError = Colors.white;

  // Dark theme contrast colors
  static const Color onPrimaryDark = Colors.white;
  static const Color onSecondaryDark = textPrimary; // Dark Grey on Amber (might need adjustment if Amber is lightened for dark theme)
  static const Color onAccentDark = Colors.white; // White on Teal
  static const Color onErrorDark = Colors.black; // If error color is lightened for dark theme, else white
}
