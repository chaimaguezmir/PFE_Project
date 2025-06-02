// app theme configuration
import 'package:flutter/material.dart';

// Returns the main ThemeData for the app
ThemeData theme() {
  const Color backgroundColor = Color(0xFFFFFFFF); // App background color (white)
  const Color primaryColor = Color(0xFF245960); // Main brand color (dark teal)
  const Color secondaryColor = Color(0xFF249689); // Accent/secondary color (teal)

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor, // Used to generate color scheme
      primary: primaryColor, // Main color for app elements
      secondary: secondaryColor, // Secondary/accent color
      surface: Colors.white, // Default surface color
      error: Color(0xFFB00020), // Error color (red)
      onPrimary: Colors.black, // Text/icon color on primary
      onSecondary: Colors.white, // Text/icon color on secondary
      surfaceContainerHighest: backgroundColor, // Highest surface container color (black)
      onSurface: Color(0xFFFFFFFF), // Text/icon color on surface
      onError: Colors.white, // Text/icon color on error
    ),
  );
}

// Linear gradient used for backgrounds or containers
const LinearGradient appGradient = LinearGradient(
  colors: [Color(0xFFF5F7FF), Colors.white], // Gradient from light blue to white
  begin: Alignment.topCenter, // Start at the top
  end: Alignment.bottomCenter, // End at the bottom
);
