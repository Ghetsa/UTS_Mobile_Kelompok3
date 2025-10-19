import 'package:flutter/material.dart';

// === Login ===
import '../login/login.dart';

// === Register ===
import '../register/register.dart';

// === Dashboard ===
import '../Dashboard/kegiatan.dart';
import '../Dashboard/keuangan.dart';
import '../Dashboard/kependudukan.dart';

// === Warga dan Rumah ===
import '../DataWargaDanRumah/Rumah/DaftarRumah.dart';
import '../DataWargaDanRumah/Rumah/TambahRumah.dart';
import '../DataWargaDanRumah/Warga/DaftarWarga.dart';
import '../DataWargaDanRumah/Warga/TambahWarga.dart';

// === Menu Utama ===
import '../LaporanKeuangan/pages/semua_pemasukan_page.dart';
import '../LaporanKeuangan/pages/semua_pengeluaran_page.dart';
import '../LaporanKeuangan/pages/cetak_laporan_page.dart';
import '../ManajemenPengguna/manajemen_pengguna.dart';
import '../ChannelTransfer/channel_transfer.dart';
import '../LogAktifitas/log_aktifitas.dart';
import '../PesanWarga/pesan_warga.dart';
import '../KegiatanDanBroadcast/kegiatan.dart';

// === Pemasukan ===
import '../Pemasukan/kategoriIuran/pages/iuran_page.dart';
import '../Pemasukan/kategoriIuran/pages/tambah_iuran_page.dart';
import '../Pemasukan/tagihIuran/tagih_iuran_page.dart';
import '../Pemasukan/tagihan/tagihan_page.dart';
import '../Pemasukan/pemasukanLain/daftar_page.dart';
import '../Pemasukan/pemasukanLain/tambah_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // === Default Route ===
    '/': (context) => const LoginScreen(),

    // === Login ===
    '/login': (context) => const LoginScreen(),

    // === Register ===
    '/register': (context) => const RegisterScreen(),

    // === Dashboard ===
    '/dashboard/kegiatan': (context) => const DashboardKegiatanPage(),
    '/dashboard/keuangan': (context) => const DashboardKeuanganPage(),
    '/dashboard/kependudukan': (context) => const DashboardKependudukanPage(),

    // === Data Warga ===
    '/warga/daftar': (context) => const DaftarWargaPage(),
    '/warga/tambah': (context) => const TambahWargaPage(),

    // === Data Rumah ===
    '/rumah/daftar': (context) => const DaftarRumahPage(),
    '/rumah/tambah': (context) => const TambahRumahPage(),

    // === Pemasukan ===
    '/pemasukan/pages/kategori': (context) => const KategoriIuranPage(),
    '/pemasukan/pages/tambah_kategori': (context) => const TambahKategoriPage(),
    '/pemasukan/tagihIuran': (context) => const TagihIuranPage(),
    '/pemasukan/tagihan': (context) => const TagihanPage(),
    '/pemasukan/pemasukanLain-daftar': (context) => const PemasukanLainDaftarPage(),
    '/pemasukan/pemasukanLain-tambah': (context) => const PemasukanLainTambahPage(),

    // === Laporan Keuangan ===
    '/laporan/semua-pemasukan': (context) => const SemuaPemasukanPage(),
    '/laporan/semua-pengeluaran': (context) => const SemuaPengeluaranPage(),
    '/laporan/cetak': (context) => const CetakLaporanPage(),

    // === Pengeluaran ===
    '/pengeluaran/daftar': (context) => const PengeluaranDaftarPage(), // ✅ Tambahan
    '/pengeluaran/tambah': (context) => const PengeluaranTambahPage(), // ✅ Tambahan

    // === Kegiatan & Broadcast ===
    '/kegiatan': (context) => const KegiatanBroadcastPage(),

    // === Data Warga dan Rumah ===
    '/data': (context) => const DataWargaPage(),
    // '/laporan': (context) => const LaporanKeuanganPage(),
    '/manajemen': (context) => const ManajemenPenggunaPage(),
    '/pengguna/penggunaDaftar': (context) => const DaftarPenggunaPage(),
    '/pengguna/penggunaTambah': (context) => const TambahPenggunaPage(),

    // === Channel Transfer ===
    '/channel': (context) => const ChannelTransferPage(),
    '/channel/channelDaftar': (context) => const DaftarChannelPage(),
    '/channel/channelTambah': (context) => const TambahChannelPage(),

    // === Log Aktivitas ===
    '/log': (context) => const LogAktifitasPage(),
    '/semuaAktifitas': (context) => const SemuaAktifitasPage(),

    // === Pesan Warga ===
    '/pesan': (context) => const PesanWargaPage(),
  };
}
