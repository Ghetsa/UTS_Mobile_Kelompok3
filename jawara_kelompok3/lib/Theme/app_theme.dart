import 'package:flutter/material.dart';

class AppTheme {
  // === Warna utama (biru) ===
  static const Color primaryBlue = Color(0xFF1E3A8A); // Biru navy (utama)
  static const Color lightBlue = Color(0xFFDBEAFE); // Biru muda lembut
  static const Color backgroundBlueWhite = Color(0xFFF8FAFC); // Putih kebiruan

  // === Gradasi biru tambahan ===
  static const Color blueExtraLight = Color.fromARGB(255, 205, 233, 252); // Biru sangat lembut (hampir putih)
  static const Color blueLight = Color.fromARGB(255, 166, 207, 255); // Biru terang
  static const Color blueMediumLight = Color.fromARGB(255, 120, 170, 251); // Biru sedang
  static const Color blueMedium = Color.fromARGB(255, 84, 149, 255); // Biru sedang
  static const Color blueMediumDark = Color.fromARGB(255, 34, 103, 213); // Biru sedang
  static const Color blueDark = Color(0xFF1E40AF); // Biru gelap (lebih pekat)
  static const Color blueSuperDark = Color.fromARGB(255, 18, 41, 116); // Biru gelap (lebih pekat)

  // === Gradasi kuning-oranye tambahan ===
  static const Color yellowExtraLight = Color.fromARGB(255, 255, 242, 219); // Kuning sangat lembut (hampir putih)
  static const Color yellowLight = Color.fromARGB(255, 255, 230, 153); // Kuning pastel lembut
  static const Color yellowMediumLight = Color.fromARGB(255, 255, 213, 128); // Kuning-oranye terang
  static const Color yellowMedium = Color.fromARGB(255, 255, 186, 73); // Oranye sedang (utama)
  static const Color yellowMediumDark = Color.fromARGB(255, 234, 136, 40); // Oranye gelap hangat
  static const Color yellowDark = Color.fromARGB(255, 202, 99, 19); // Oranye tua pekat (mendekati coklat keemasan)
  static const Color yellowSuperDark = Color.fromARGB(255, 165, 87, 8); // Oranye sangat tua (gelap ke coklat)

  // === Gradasi merah tambahan ===
  static const Color redExtraLight = Color.fromARGB(255, 255, 228, 230); // Merah sangat lembut (hampir pink muda)
  static const Color redLight = Color.fromARGB(255, 255, 186, 193); // Merah terang lembut
  static const Color redMediumLight = Color.fromARGB(255, 255, 138, 148); // Merah sedang terang
  static const Color redMedium = Color.fromARGB(255, 239, 68, 68); // Merah utama (cerah dan kuat)
  static const Color redMediumDark = Color.fromARGB(255, 200, 30, 30); // Merah agak tua
  static const Color redDark = Color(0xFF991B1B); // Merah tua pekat
  static const Color redSuperDark = Color.fromARGB(255, 69, 10, 10); // Merah sangat tua (hampir marun gelap)

  // === Gradasi hijau tambahan ===
  static const Color greenExtraLight = Color.fromARGB(255, 204, 247, 218); // Hijau sangat lembut (hampir putih)
  static const Color greenLight = Color.fromARGB(255, 166, 232, 189); // Hijau terang
  static const Color greenMediumLight = Color.fromARGB(255, 120, 210, 155); // Hijau sedang terang
  static const Color greenMedium = Color.fromARGB(255, 76, 187, 123); // Hijau sedang (netral)
  static const Color greenMediumDark = Color.fromARGB(255, 34, 153, 84); // Hijau agak tua (stabil)
  static const Color greenDark = Color(0xFF166534); // Hijau tua (lebih pekat)
  static const Color greenSuperDark = Color.fromARGB(255, 9, 44, 22); // Hijau sangat tua (hampir hitam kehijauan)

  // === Warna tambahan (hijau) ===
  static const Color primaryGreen = Color(0xFF065F46); // Hijau tua (teks / aksen)
  static const Color lightGreen = Color(0xFFD1FAE5); // Hijau muda (latar lembut)

  // === Warna kontras dan cerah ===
  static const Color purpleDeep = Color(0xFFAC25EB); // Ungu tua cerah (tombol Filter)
  static const Color pinkPinky = Color(0xFFE010AC); // Pink fuchsia terang (tombol Tambah)
  static const Color orangeDeep = Color(0xFFE07410); // Oranye dalam (aksen atau peringatan)
  static const Color orangeAccent = Color(0xFFFFA500); // Oranye terang aksen (lebih cerah)

  // === Palet tambahan (biru & ungu) ===
  static const Color violetSoft = Color(0xFF7C3AED);
  static const Color lavenderLight = Color(0xFFE9D5FF);
  static const Color pinkSoft = Color(0xFFFBCFE8);
  static const Color blueViolet = Color(0xFF6366F1);
  static const Color skyLight = Color(0xFFBAE6FD);
  static const Color magentaBright = Color(0xFFD946EF);

  // === Palet tambahan (kuning & oranye lembut untuk grafik) ===
  static const Color yellowSoft = Color(0xFFFEF9C3); // Kuning lembut
  static const Color yellowBright = Color(0xFFFACC15); // Kuning cerah
  static const Color orangeSoft = Color(0xFFFFEDD5); // Oranye pastel lembut

  // === Tema umum aplikasi ===
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
