import 'package:flutter/material.dart';

// === Login ===
import '../login/login.dart';

// === Register ===
import '../register/register.dart';

// === Dashboard ===
import '../Dashboard/kegiatan.dart';
import '../Dashboard/keuangan.dart';
import '../Dashboard/kependudukan.dart';

// === Menu Utama ===
import '../DataWargaDanRumah/data_warga_page.dart';
import '../LaporanKeuangan/pages/semua_pemasukan_page.dart';
import '../LaporanKeuangan/pages/semua_pengeluaran_page.dart';
import '../LaporanKeuangan/pages/cetak_laporan_page.dart';
import '../ManajemenPengguna/manajemen_pengguna.dart';
import '../ChannelTransfer/channel_transfer.dart';
import '../LogAktifitas/log_aktifitas.dart';
import '../PesanWarga/pesan_warga.dart';
import '../KegiatanDanBroadcast/kegiatan.dart';
import '../Pengeluaran/pengeluaran.dart';
import '../MutasiKeluarga/mutasi_keluarga.dart';

// === Pemasukan ===
import '../Pemasukan/kategoriIuran/pages/iuran_page.dart';
import '../Pemasukan/kategoriIuran/pages/tambah_iuran_page.dart';
import '../Pemasukan/tagihIuran/tagih_iuran_page.dart';
import '../Pemasukan/tagihan/tagihan_page.dart';
import '../Pemasukan/pemasukanLain/daftar_page.dart';
import '../Pemasukan/pemasukanLain/tambah_page.dart';

// === Manajemen Pengguna ===
import '../ManajemenPengguna/Daftar/daftar_pengguna.dart';
import '../ManajemenPengguna/Tambah/tambah_pengguna.dart';

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

    // === Pemasukan ===
    '/pemasukan/pages/kategori': (context) => const KategoriIuranPage(),
    '/pemasukan/pages/tambah_kategori': (context) => const TambahKategoriPage(),
    '/pemasukan/tagihIuran': (context) => const TagihIuranPage(),
    '/pemasukan/tagihan': (context) => const TagihanPage(),
    '/pemasukan/pemasukanLain-daftar': (context) =>
        const PemasukanLainDaftarPage(),
    '/pemasukan/pemasukanLain-tambah': (context) =>
        const PemasukanLainTambahPage(),

    // === Pengeluaran ===
    '/pengeluaran': (context) => const PengeluaranPage(),

    // === Kegiatan & Broadcast ===
    '/kegiatan': (context) => const KegiatanBroadcastPage(),

    // === Data Warga dan Rumah ===
    '/data': (context) => const DataWargaPage(),
    // '/laporan': (context) => const LaporanKeuanganPage(),

    // === Manajemen Pengguna ===
    '/manajemen': (context) => const ManajemenPenggunaPage(),
    '/pengguna/penggunaDaftar': (context) => const DaftarPenggunaPage(),
    '/pengguna/penggunaTambah': (context) => const TambahPenggunaPage(),

    // === Channel Transfer ===
    '/channel': (context) => const ChannelTransferPage(),

    // === Log Aktivitas ===
    '/log': (context) => const LogAktifitasPage(),

    // === Pesan Warga ===
    '/pesan': (context) => const PesanWargaPage(),
  };
}
