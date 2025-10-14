import 'package:flutter/material.dart';
import 'Pemasukan/pages/iuran_page.dart';
import 'Pemasukan/pages/tambah_iuran_page.dart';
import 'Pemasukan/pages/detail_page.dart';
import 'Channel transfer/channel_transfer.dart';
import 'Dashboard/dashboard_page.dart';
import 'Data warga dan rumah/data_warga_page.dart';
import 'Kegiatan dan broadcast/kegiatan.dart';
import 'Laporan keuangan/laporan_keuangan.dart';
import 'Log aktifitas/log_aktifitas.dart';
import 'Manajemen pengguna/manajemen_pengguna.dart';
import 'Mutasi keluarga/mutasi_keluarga.dart';
import 'Pengeluaran/pengeluaran.dart';
import 'Pesan warga/pesan_warga.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color primaryDark = Color(0xFF5C4E43); // Coklat gelap elegan
  static const Color secondaryCream = Color(0xFFEDE8D2); // Krem lembut
  static const Color accentGold = Color(0xFFC7B68D); // Emas lembut
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iuran Warga',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.secondaryCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(),
        '/iuran': (context) => const IuranPage(),
        '/tambah': (context) => const TambahIuranPage(),
        '/detail': (context) => const DetailPage(),
        '/data': (context) => const DataWargaPage(),
        '/laporan': (context) => const LaporanKeuanganPage(),
        '/manajemen': (context) => const ManajemenPenggunaPage(),
        '/channel': (context) => const ChannelTransferPage(),
        '/log': (context) => const LogAktifitasPage(),
        '/pesan': (context) => const PesanWargaPage(),
        '/kegiatan': (context) => const KegiatanBroadcastPage(),
        '/pengeluaran': (context) => const PengeluaranPage(),
        '/mutasi': (context) => const MutasiKeluargaPage(),
      },
    );
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';

    return Drawer(
      child: Container(
        color: AppColors.secondaryCream, // ☕ sidebar warna krem lembut
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryDark, // 🟤 header coklat gelap elegan
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 25, backgroundColor: AppColors.secondaryCream),
                  SizedBox(height: 10),
                  Text(
                    "Admin Jawara",
                    style: TextStyle(
                      color: AppColors.accentGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "admin1@gmail.com",
                    style: TextStyle(
                      color: Color(0xFFF8F7F3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _buildMenuItem(Icons.dashboard, "Dashboard", "/", context, currentRoute),
            _buildMenuItem(Icons.people, "Data Warga & Rumah", "/data", context, currentRoute),
            _buildMenuItem(Icons.receipt_long, "Pemasukan", "/iuran", context, currentRoute),
            _buildMenuItem(Icons.insert_chart, "Laporan Keuangan", "/laporan", context, currentRoute),
            _buildMenuItem(Icons.people_alt, "Manajemen Pengguna", "/manajemen", context, currentRoute),
            _buildMenuItem(Icons.swap_horiz, "Channel Transfer", "/channel", context, currentRoute),
            _buildMenuItem(Icons.history, "Log Aktifitas", "/log", context, currentRoute),
            _buildMenuItem(Icons.message, "Pesan Warga", "/pesan", context, currentRoute),
            _buildMenuItem(Icons.event, "Kegiatan & Broadcast", "/kegiatan", context, currentRoute),
            _buildMenuItem(Icons.wallet, "Pengeluaran", "/pengeluaran", context, currentRoute),
            _buildMenuItem(Icons.family_restroom, "Mutasi Keluarga", "/mutasi", context, currentRoute),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem(
      IconData icon, String title, String route, BuildContext context, String currentRoute) {
    final bool isActive = route == currentRoute;

    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryDark // 🟤 warna aktif (coklat gelap)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? AppColors.accentGold // ✨ ikon emas saat aktif
              : AppColors.primaryDark, // ikon coklat gelap saat nonaktif
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive
                ? AppColors.accentGold // teks emas saat aktif
                : AppColors.primaryDark, // teks coklat saat nonaktif
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
