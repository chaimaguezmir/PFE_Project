// app theme configuration
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF245960); // Main brand color (dark teal)
const Color secondaryColor = Color(0xff249689);
const ternaryColor = Color(0xffE5E7EB); // Light grey for tertiary elements
// Returns the main ThemeData for the app
ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: ternaryColor,
      onPrimary: Colors.black,
      // Text/icon color on primary
      onSecondary: Colors.white,
      onTertiary: Colors.grey,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: primaryColor),
      ),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIconColor: Colors.grey,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}

// Linear gradient used for backgrounds or containers
const LinearGradient appGradient = LinearGradient(
  colors: [Color(0xFFF5F7FF), Colors.white],
  // Gradient from light blue to white
  begin: Alignment.topCenter,
  // Start at the top
  end: Alignment.bottomCenter, // End at the bottom
);
