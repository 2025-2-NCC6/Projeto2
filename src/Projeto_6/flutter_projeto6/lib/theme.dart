import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1C1C1E),
    primaryColor: const Color(0xFFFFC61A),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFC61A),
      secondary: Color(0xFF2C2C2E),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2C2C2E),
      elevation: 0,
    ),
  );
}
