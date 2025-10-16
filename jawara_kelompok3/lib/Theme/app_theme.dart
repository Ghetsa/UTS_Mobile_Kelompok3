import 'package:flutter/material.dart';

class AppTheme {
  // === Warna utama (biru) ===
  static const Color primaryBlue = Color(0xFF1E3A8A); // Biru navy (utama)
  static const Color lightBlue = Color(0xFFDBEAFE); // Biru muda lembut
  static const Color backgroundBlueWhite = Color(0xFFF8FAFC); // Putih kebiruan

  // === Warna tambahan (hijau) ===
  static const Color primaryGreen = Color(0xFF065F46); // Hijau tua (teks / aksen)
  static const Color lightGreen = Color(0xFFD1FAE5); // Hijau muda (latar lembut)

  // === Warna tombol kontras ===
  static const Color purpleDeep = Color(0xFFAC25EB); // Ungu tua cerah (tombol Filter)
  static const Color pinkPinky = Color(0xFFE010AC); // Pink fuchsia terang (tombol Tambah)
  static const Color orangeDeep = Color(0xFFE07410); // Oranye dalam (aksen atau peringatan)

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
        surface: backgroundBlueWhite,
        tertiary: lightGreen,
        onTertiary: primaryGreen,
      ),
    );
  }
}
