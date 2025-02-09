import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4CAF50), // Primary Green
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light Grey Background
    cardColor: Colors.white, // Surface
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4CAF50), // Primary Green
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF212121)), // Primary Text
      bodyMedium: TextStyle(color: Color(0xFF757575)), // Secondary Text
    ),

    iconTheme: const IconThemeData(color: Color(0xFF616161)), // Icon Color
    dividerColor: const Color(0xFFE0E0E0), // Divider
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF4CAF50), // Primary Button
      disabledColor: Color(0xFFBDBDBD), // Disabled Button
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFFC8E6C9), // Light Green Accent
      surface: Colors.white,
      error: Color(0xFFD32F2F),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF66BB6A), // Dark Mode Primary Green
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark Background
    cardColor: const Color(0xFF1E1E1E), // Dark Surface
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF66BB6A),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)), // Light Text in Dark Mode
      bodyMedium: TextStyle(color: Color(0xFF9E9E9E)), // Secondary Text
    ),
    iconTheme: const IconThemeData(color: Colors.white), // White Icons
    dividerColor: const Color(0xFF757575), // Dark Dividers
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF66BB6A), // Primary Button in Dark Mode
      disabledColor: Color(0xFF757575), // Disabled Button
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF66BB6A),
      secondary: Color(0xFF1E1E1E),
      surface: Color(0xFF1E1E1E),
      error: Color(0xFFD32F2F),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.black,
    ),
  );
}
