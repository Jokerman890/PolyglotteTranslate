import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7C4DFF),     // Leuchtendes Violett
      secondary: Color(0xFF00B0FF),    // Leuchtendes Blau
      tertiary: Color(0xFFFF4081),     // Leuchtendes Pink
      background: Color(0xFF1A1A1A),   // Sehr dunkles Grau
      surface: Color(0xFF2D1F3D),      // Dunkles Violett
      error: Color(0xFFFF5252),        // Leuchtendes Rot
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
  );

  static final glassEffect = BoxDecoration(
    color: Colors.black.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Colors.white.withOpacity(0.1),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 8,
        spreadRadius: 1,
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.1),
        Colors.white.withOpacity(0.05),
      ],
    ),
  );

  static final glowingBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color(0xFF7C4DFF).withOpacity(0.5),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7C4DFF).withOpacity(0.2),
        blurRadius: 8,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: const Color(0xFF00B0FF).withOpacity(0.2),
        blurRadius: 8,
        spreadRadius: 1,
      ),
    ],
  );

  static final inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.black.withOpacity(0.3),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.1),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.1),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF7C4DFF),
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  );
}
