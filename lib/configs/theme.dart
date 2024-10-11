import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medpocket/configs/colors.dart';

import '../widgets/widgets.dart';

// Define your custom theme in a separate file
class AppTheme {
  // Create a method to return ThemeData
  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'Poppins',
      // Primary color used across major components like AppBar, buttons, etc.
      primaryColor: AppColors.primary, // Dark Blue

      // The color used for primary elements on the screen like buttons, floating action buttons, etc.
      primaryColorLight: AppColors.blue, // Blue
      primaryColorDark: AppColors.primary, // Dark Background
      cardColor: AppColors.bg,
      canvasColor: AppColors.bg,
      dividerColor: AppColors.primary,
      dialogBackgroundColor: AppColors.bg,

      // Background color used in Scaffold, dialogs, etc.
      scaffoldBackgroundColor: AppColors.bg, // Dark Background

      // The color of the app bar
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        color: AppColors.bg,// AppBar background color (Dark Blue)
        foregroundColor: AppColors.bg, // AppBar text and icon color (White)
        titleTextStyle: myText(fontSize: 16.sp, color: AppColors.textColorb1,  fontWeight: FontWeight.w500).copyWith(fontFamily: "Poppins"),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      // The color used for floating action buttons
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary, // Background color of FAB (Blue)
        foregroundColor: AppColors.bg, // Icon color of FAB (White)
      ),

      // The color used for icons across the app
      iconTheme: const IconThemeData(
        color: AppColors.primary, 
      ),

      // The color used for text fields
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // Background color of text fields 
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary), // Border color when focused 
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary), // Border color when enabled 
        ),
      ),

      colorScheme: const ColorScheme(
        primary: AppColors.primary, // Primary color (Dark Blue)
        primaryContainer: AppColors.secondary, // Secondary color (Darker Blue)
        secondary: AppColors.blue, // Accent color (Blue)
        secondaryContainer: AppColors.bg, // Scaffold background color (Light Blue)
        surface: AppColors.bg, // Background color for cards, sheets, etc. (Dark Blue)
        onPrimary: AppColors.textColorw1, // Text color on primary color (White with 70% opacity)
        onSecondary: AppColors.textColorw2, // Text color on secondary color (White with 60% opacity)
        onSurface: AppColors.textColorb1, // Text color on background (Black with 54% opacity)
        error: AppColors.red, // Error color
        onError: AppColors.red, // Text color on error color
        brightness: Brightness.light, // Specify whether the color scheme is light or dark
      ),
    );
  }
}
