import 'package:flutter/material.dart';

class AppColors {
  // Modern Teal-based Palette
  static const Color primary = Color(0xFF009688); // Teal
  static const Color primaryLight = Color(0xFFB2DFDB); // Light Teal
  static const Color primaryDark = Color(0xFF00695C); // Dark Teal
  static const Color secondary = Color(0xFFFFC107); // Amber
  static const Color accent = Color(0xFF00BCD4); // Cyan
  static const Color background = Color(0xFF0A0A0A); // Dark Background
  static const Color surface = Color(0xFF1A1A1A); // Dark Surface
  static const Color textPrimary = Color(0xFFE0E0E0); // Light Grey
  static const Color textSecondary = Color(0xFFBDBDBD); // Medium Grey
  static const Color error = Color(0xFFD32F2F); // Red

  // Dark Theme specific colors (Glassmorphism ready)
  static const Color backgroundDark = Color(0xFF0A0A0A); // Deep Dark Background
  static const Color surfaceDark = Color(0xFF1A1A1A); // Dark Surface
  static const Color surfaceDarkGlass = Color(0x1AFFFFFF); // Glassmorphism surface
  static const Color textPrimaryDark = Color(0xFFE0E0E0); // Light grey for text
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Medium light grey

  // Glassmorphism specific colors
  static const Color glassPrimary = Color(0x1A009688); // Teal with transparency
  static const Color glassSecondary = Color(0x1AFFC107); // Amber with transparency
  static const Color glassAccent = Color(0x1A00BCD4); // Cyan with transparency
  static const Color glassBorder = Color(0x33FFFFFF); // White border with transparency

  // Contrast colors (primarily for text/icons on colored backgrounds)
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = textPrimary; // Light Grey on Amber
  static const Color onAccent = Colors.white; // White on Cyan
  static const Color onError = Colors.white;

  // Dark theme contrast colors
  static const Color onPrimaryDark = Colors.white;
  static const Color onSecondaryDark = textPrimary; // Light Grey on Amber
  static const Color onAccentDark = Colors.white; // White on Cyan
  static const Color onErrorDark = Colors.white;

  // Gradient colors for modern UI
  static const List<Color> primaryGradient = [Color(0xFF009688), Color(0xFF00695C)];
  static const List<Color> accentGradient = [Color(0xFF00BCD4), Color(0xFF0097A7)];
  static const List<Color> glassGradient = [Color(0x1AFFFFFF), Color(0x0AFFFFFF)];
}
