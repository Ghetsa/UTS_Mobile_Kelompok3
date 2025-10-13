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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE6D7C4),   // background halaman
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

/// Widget Sidebar
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF4B3D1A), // warna background sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF4B3D1A)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 25, backgroundColor: Colors.white),
                  SizedBox(height: 10),
                  Text("Admin Jawara",
                      style: TextStyle(color: Color(0xFFE6D7C4), fontSize: 16)),
                  Text("admin1@gmail.com",
                      style: TextStyle(color: Color(0xFFE6D7C4), fontSize: 12)),
                ],
              ),
            ),
            _buildMenuItem(Icons.dashboard, "Dashboard", "/", context),
            _buildMenuItem(Icons.people, "Data Warga & Rumah", "/data", context),
            _buildMenuItem(Icons.receipt_long, "Pemasukan", "/iuran", context),
            _buildMenuItem(Icons.insert_chart, "Laporan Keuangan", "/laporan", context),
            _buildMenuItem(Icons.people_alt, "Manajemen Pengguna", "/manajemen", context),
            _buildMenuItem(Icons.swap_horiz, "Channel Transfer", "/channel", context),
            _buildMenuItem(Icons.history, "Log Aktifitas", "/log", context),
            _buildMenuItem(Icons.message, "Pesan Warga", "/pesan", context),
            _buildMenuItem(Icons.event, "Kegiatan & Broadcast", "/kegiatan", context),
            _buildMenuItem(Icons.wallet, "Pengeluaran", "/pengeluaran", context),
            _buildMenuItem(Icons.family_restroom, "Mutasi Keluarga", "/mutasi", context),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem(
      IconData icon, String title, String route, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE6D7C4)), // ikon warna krem
      title: Text(title, style: const TextStyle(color: Color(0xFFE6D7C4))), // teks krem
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
