import 'package:flutter/material.dart';
import 'ChannelTransfer/channel_transfer.dart';
import 'Dashboard/dashboard_page.dart';
import 'DataWargaDanRumah/data_warga_page.dart';
import 'KegiatanDanBroadcast/kegiatan.dart';
import 'LaporanKeuangan/laporan_keuangan.dart';
import 'LogAktifitas/log_aktifitas.dart';
import 'ManajemenPengguna/manajemen_pengguna.dart';
import 'MutasiKeluarga/mutasi_keluarga.dart';
import 'Pengeluaran/pengeluaran.dart';
import 'PesanWarga/pesan_warga.dart';
import 'Pemasukan/kategoriIuran/pages/iuran_page.dart';
import 'Pemasukan/kategoriIuran/pages/tambah_iuran_page.dart';
import 'Pemasukan/kategoriIuran/pages/detail_page.dart';
import 'Pemasukan/tagihIuran/tagih_iuran_page.dart';
import 'Pemasukan/tagihan/tagihan_page.dart';
import 'Pemasukan/pemasukanLain/daftar_page.dart';
import 'Pemasukan/pemasukanLain/tambah_page.dart';

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
        scaffoldBackgroundColor: const Color(0xFFE6D7C4), // background halaman
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(),

        // === Pemasukan ===
       '/pemasukan/pages/kategori': (context) => const KategoriIuranPage(),
       '/pemasukan/pages/tambah_kategori': (context) => const TambahKategoriPage(),
       '/pemasukan/pages/detail_kategori': (context) => const DetailKategoriPage(),
       '/pemasukan/tagihIuran': (context) => const TagihIuranPage(),
       '/pemasukan/tagihan': (context) => const TagihanPage(),
       '/pemasukan/pemasukanLain-daftar': (context) => const PemasukanLainDaftarPage(),
       '/pemasukan/pemasukanLain-tambah': (context) => const PemasukanLainTambahPage(),

        // === Menu utama lain ===
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

/// Sidebar 
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF4B3D1A),
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

            // === Menu utama ===
            _buildMenuItem(Icons.dashboard, "Dashboard", "/", context),
            _buildMenuItem(Icons.people, "Data Warga & Rumah", "/data", context),

            // === Pemasukan ===
            ExpansionTile(
              leading: const Icon(Icons.receipt_long, color: Color(0xFFE6D7C4)),
              title: const Text("Pemasukan",
                  style: TextStyle(color: Color(0xFFE6D7C4))),
              children: [
                _buildSubMenuItem("Kategori Iuran", "/pemasukan/pages/kategori", context),
                _buildSubMenuItem("Tagih Iuran", "/pemasukan/tagihIuran", context),
                _buildSubMenuItem("Tagihan", "/pemasukan/tagihan", context),
                _buildSubMenuItem("Pemasukan Lain - Daftar", "/pemasukan/pemasukanLain-daftar", context),
                _buildSubMenuItem("Pemasukan Lain - Tambah", "/pemasukan/pemasukanLain-tambah", context),
              ],
            ),

            // === Kegiatan ===
            ExpansionTile(
              leading: const Icon(Icons.receipt_long, color: Color(0xFFE6D7C4)),
              title: const Text("Pemasukan",
                  style: TextStyle(color: Color(0xFFE6D7C4))),
              children: [
                _buildSubMenuItem("Kegiatan - Daftar", "/pemasukan/pages/kategori", context),
                _buildSubMenuItem("Kegiatan - Tambah", "/pemasukan/tagihIuran", context),
                _buildSubMenuItem("Broadcast - Daftar", "/pemasukan/tagihan", context),
                _buildSubMenuItem("Broadcast - Tambah", "/pemasukan/tagihan", context),
              ],
            ),

            // === Menu utama lain ===
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

  /// Menu utama biasa
  static Widget _buildMenuItem(
      IconData icon, String title, String route, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE6D7C4)),
      title: Text(title, style: const TextStyle(color: Color(0xFFE6D7C4))),
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  /// Submenu
  static Widget _buildSubMenuItem(
      String title, String route, BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 60.0), // indent
      title: Text(title,
          style: const TextStyle(color: Color(0xFFE6D7C4), fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
