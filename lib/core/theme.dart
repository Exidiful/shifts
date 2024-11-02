// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFFFF0000); // Red
  static const Color _accentColor = Color(0xFF808080); // Grey

  static const Color _backgroundColorDark = Color(0xFF000000); // Black
  static const Color _surfaceColorDark = Color(0xFF121212); // Dark Grey
  static const Color _errorColor = Color(0xFFCF6679);

  static const Color _backgroundColorLight = Color(0xFFFFFFFF); // White
  static const Color _surfaceColorLight = Color(0xFFF5F5F5); // Light Grey

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      secondary: _accentColor,
      surface: _surfaceColorDark,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: _primaryColor),
      titleTextStyle: TextStyle(color: _primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _backgroundColorDark,
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      color: _surfaceColorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: _surfaceColorDark,
      labelStyle: const TextStyle(color: _primaryColor),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _primaryColor),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
      bodyLarge: TextStyle(fontSize: 16, color: _accentColor),
      bodyMedium: TextStyle(fontSize: 14, color: _accentColor),
    ),
    extensions: [
      CustomThemeExtension(
        cardBackgroundColor: _surfaceColorDark.withOpacity(0.8),
        listTileColor: _surfaceColorDark.withOpacity(0.5),
      ),
    ],
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _accentColor,
      surface: _surfaceColorLight,
      error: _errorColor,
    ),
    scaffoldBackgroundColor: _backgroundColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: _primaryColor),
      titleTextStyle: TextStyle(color: _primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _backgroundColorLight,
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      color: _surfaceColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: _surfaceColorLight,
      labelStyle: const TextStyle(color: _primaryColor),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _primaryColor),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
      bodyLarge: TextStyle(fontSize: 16, color: _accentColor),
      bodyMedium: TextStyle(fontSize: 14, color: _accentColor),
    ),
    extensions: [
      CustomThemeExtension(
        cardBackgroundColor: _surfaceColorLight.withOpacity(0.8),
        listTileColor: _surfaceColorLight.withOpacity(0.5),
      ),
    ],
  );
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? cardBackgroundColor;
  final Color? listTileColor;

  CustomThemeExtension({
    this.cardBackgroundColor,
    this.listTileColor,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? cardBackgroundColor,
    Color? listTileColor,
  }) {
    return CustomThemeExtension(
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      listTileColor: listTileColor ?? this.listTileColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      cardBackgroundColor: Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t),
      listTileColor: Color.lerp(listTileColor, other.listTileColor, t),
    );
  }
}
