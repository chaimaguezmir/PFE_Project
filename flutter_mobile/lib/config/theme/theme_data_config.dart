// app theme configuration
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color primaryColor = Color(0xFF245960);
const Color secondaryColor = Color(0xff249689);
const Color ternaryColor = Color(0xffE5E7EB);
const Color onPrimaryColor = Colors.black;
const Color onSecondaryColor = Colors.white;
const Color onTertiaryColor = Colors.grey;
const Color surfaceColor = Colors.white;
const Color onSurfaceColor = Colors.black;
const Color errorColor = Colors.red;
const Color onErrorColor = Colors.white;
// Returns the main ThemeData for the app
ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: ternaryColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onTertiary: onTertiaryColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      error: errorColor,
      onError: onErrorColor,
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 2.0,
      selectedItemColor: secondaryColor,
      unselectedItemColor: onTertiaryColor,
      selectedIconTheme:  IconThemeData(size: 40.sp),
      unselectedIconTheme:  IconThemeData(size: 40.sp),
      selectedLabelStyle:  TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 35.sp,
      ),
      unselectedLabelStyle:  TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 35.sp,
      ),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,

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
