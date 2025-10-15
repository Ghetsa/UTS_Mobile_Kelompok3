import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1E3A8A); // Biru navy
  static const Color lightBlue = Color(0xFFDBEAFE); // Biru muda lembut
  static const Color backgroundBlueWhite = Color(0xFFF8FAFC); // Putih kebiruan

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundBlueWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: lightBlue,
      ),
      iconTheme: const IconThemeData(color: primaryBlue),
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: lightBlue,
      ),
    );
  }
}
