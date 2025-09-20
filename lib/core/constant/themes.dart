import 'package:flutter/material.dart';

class AppThemes{

  static const Color primaryColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF000000);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color textColor = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFF000000);
  static const Color cardColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFF000000);
  static const Color errorColor = Color(0xFF000000);
  static const Color successColor = Color(0xFF000000);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
      error: Colors.red,

    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
  );

}