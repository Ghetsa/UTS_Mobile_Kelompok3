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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iuran Warga',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // putih kebiruan lembut
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A), // biru navy modern
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
        color: const Color(0xFFDBEAFE), // 💙 biru muda lembut untuk sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1E3A8A), // 🔵 biru gelap (sama dengan AppBar)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 25, backgroundColor: Color(0xFFF8FAFC)),
                  SizedBox(height: 10),
                  Text(
                    "Admin Jawara",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "admin1@gmail.com",
                    style: TextStyle(
                      color: Color(0xFFE0E7FF), // teks biru muda lembut
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
            ? const Color(0xFF1E3A8A) // biru tua untuk item aktif
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? Colors.white
              : const Color(0xFF1E40AF), // ikon biru gelap untuk nonaktif
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : const Color(0xFF1E293B), // teks abu kebiruan
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
