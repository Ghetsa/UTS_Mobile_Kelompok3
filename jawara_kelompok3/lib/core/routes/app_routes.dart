import 'package:flutter/material.dart';

// === Login ===
import '../../features/auth/presentation/pages/login.dart';

// === Register ===
import '../../features/auth/presentation/pages/register.dart';

// === Dashboard ===
import '../../features/dashboard/presentation/pages/kegiatan_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/kependudukan_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/keuangan_dashboard_page.dart';

// === Warga dan Rumah ===
import '../../features/warga/presentation/pages/rumah/daftar_rumah_page.dart';
import '../../features/warga/presentation/pages/rumah/tambah_rumah_page.dart';
import '../../features/warga/presentation/pages/warga/daftar_warga_page.dart';
import '../../features/warga/presentation/pages/warga/tambah_warga_page.dart';
import '../../features/warga/presentation/pages/keluarga/keluarga_page.dart';

// === Menu Utama ===
import '../../features/laporan/presentation/pages/pemasukan/semua_pemasukan_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/semua_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/cetak_laporan_page.dart';
import '../../features/manajemen_pengguna/presentation/pages/manajemen_pengguna_page.dart';
import '../../features/channel_transfer/channel_transfer_page.dart';
// Removed imports for LogAktifitas and PesanWarga - no corresponding files found

// === Kegiatan & Broadcast ===
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/daftar_kegiatan_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/tambah_kegiatan_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/detail_kegiatan_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/edit_kegiatan_page.dart';

import '../../features/kegiatan_broadcast/presentation/pages/broadcast/daftar_broadcast_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/broadcast/tambah_broadcast_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/broadcast/detail_broadcast_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/broadcast/edit_broadcast_page.dart';

// === Pemasukan ===
import '../../features/laporan/presentation/pages/pemasukan/semua_pemasukan_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/cetak_laporan_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/semua_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/daftar_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/tambah_pengeluaran_page.dart';

// === Pengeluaran ===
import '../../features/laporan/presentation/pages/pengeluaran/daftar_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/tambah_pengeluaran_page.dart';

// === Mutasi Keluarga ===
import '../../features/warga/presentation/pages/mutasi/daftar_mutasi_page.dart';
import '../../features/warga/presentation/pages/mutasi/tambah_mutasi_page.dart';

// === Manajemen Pengguna ===
import '../../features/manajemen_pengguna/presentation/pages/daftar_pengguna_page.dart';
// Removed tambah_pengguna import as file is missing

// === Channel Transfer ===
import '../../features/channel_transfer/presentation/pages/tambah_channel_page.dart';
import '../../features/channel_transfer/presentation/pages/daftar_channel_page.dart';

// Removed Log Aktifitas and Pesan Warga imports due to no files found

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

    // === Data Warga & Rumah ===
    '/warga/daftar': (context) => const DaftarWargaPage(),
    '/warga/tambah': (context) => const TambahWargaPage(),
    '/rumah/daftar': (context) => const DaftarRumahPage(),
    '/rumah/tambah': (context) => const TambahRumahPage(),
    '/keluarga': (context) => const DaftarKeluargaPage(),

    // === Pemasukan ===
    // '/pemasukan/pages/kategori': (context) => const KategoriIuranPage(),
    // '/pemasukan/pages/tambah_kategori': (context) => const TambahKategoriPage(),
    // '/pemasukan/tagihIuran': (context) => const TagihIuranPage(),
    // '/pemasukan/tagihan': (context) => const TagihanPage(),
    // '/pemasukan/pemasukanLain-daftar': (context) =>
    //     const PemasukanLainDaftarPage(),
    // '/pemasukan/pemasukanLain-tambah': (context) =>
    //     const PemasukanLainTambahPage(),

    // === Pengeluaran ===
    '/pengeluaran/daftar': (context) => const PengeluaranDaftarPage(),
    '/pengeluaran/tambah': (context) => const TambahPengeluaranPage(),

    // === Laporan Keuangan ===
    '/laporan/semua-pemasukan': (context) => const SemuaPemasukanPage(),
    '/laporan/semua-pengeluaran': (context) => const SemuaPengeluaranPage(),
    '/laporan/cetak': (context) => const CetakLaporanPage(),

    // === Kegiatan & Broadcast ===
    '/kegiatan/daftar': (context) => const DaftarKegiatanPage(),
    '/kegiatan/tambah': (context) => const TambahKegiatanPage(),
    // Broadcast
    '/broadcast/daftar': (context) => const DaftarBroadcastPage(),
    '/broadcast/tambah': (context) => const TambahBroadcastPage(),

    // === Mutasi Keluarga ===
    '/mutasi/daftar': (context) => const MutasiDaftarPage(),
    '/mutasi/tambah': (context) => const MutasiTambahPage(),

    // === Manajemen Pengguna ===
    '/manajemen': (context) => const ManajemenPenggunaPage(),
    '/pengguna/penggunaDaftar': (context) => const DaftarPenggunaPage(),
    // Removed '/pengguna/penggunaTambah' route due to missing page

    // === Channel Transfer ===
    '/channel': (context) => const ChannelTransferPage(),
    '/channel/channelDaftar': (context) => const DaftarChannelPage(),
    '/channel/channelTambah': (context) => const TambahChannelPage(),

    // === Removed Log Aktifitas and Pesan Warga routes due to missing pages
  };
}
