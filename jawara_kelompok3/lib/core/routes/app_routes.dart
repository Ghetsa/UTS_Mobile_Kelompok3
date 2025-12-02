import 'package:flutter/material.dart';

// === Login ===
import '../../features/auth/presentation/pages/login.dart';

// === Register ===
import '../../features/auth/presentation/pages/register.dart';

// === Dashboard ===
import '../../features/dashboard/presentation/pages/kegiatan_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/kependudukan_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/keuangan_dashboard_page.dart';

// === Data Warga & Rumah ===
import '../../features/warga/presentation/pages/warga/daftar_warga_page.dart';
import '../../features/warga/presentation/pages/warga/tambah_warga_page.dart';

import '../../features/warga/presentation/pages/rumah/daftar_rumah_page.dart';
import '../../features/warga/presentation/pages/rumah/tambah_rumah_page.dart';

import '../../features/warga/presentation/pages/keluarga/keluarga_page.dart';

// === Mutasi Keluarga ===
import '../../features/warga/presentation/pages/mutasi/daftar_mutasi_page.dart';
import '../../features/warga/presentation/pages/mutasi/tambah_mutasi_page.dart';

// === Pengeluaran ===
import '../../features/laporan/presentation/pages/pengeluaran/daftar_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/tambah_pengeluaran_page.dart';

// === Laporan Keuangan ===
import '../../features/laporan/presentation/pages/pemasukan/semua_pemasukan_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/cetak_laporan_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/semua_pengeluaran_page.dart';

// === Kegiatan & Broadcast ===
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/daftar_kegiatan_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/tambah_kegiatan_page.dart';

import '../../features/kegiatan_broadcast/presentation/pages/broadcast/daftar_broadcast_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/broadcast/tambah_broadcast_page.dart';

// === Manajemen Pengguna ===
import '../../features/manajemen_pengguna/presentation/pages/manajemen_pengguna_page.dart';
import '../../features/manajemen_pengguna/presentation/pages/daftar_pengguna_page.dart';

// === Channel Transfer ===
import '../../features/channel_transfer/channel_transfer_page.dart';
import '../../features/channel_transfer/presentation/pages/daftar_channel_page.dart';
import '../../features/channel_transfer/presentation/pages/tambah_channel_page.dart';

//  === Aspirasi Warga ===
import '../../features/pesan_warga/presentation/pages/informasi_aspirasi_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // === Default Route ===
    '/': (context) => const LoginScreen(),

    // === Login ===
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),

    // === Dashboard ===
    '/dashboard/kegiatan': (context) => const DashboardKegiatanPage(),
    '/dashboard/keuangan': (context) => const DashboardKeuanganPage(),
    '/dashboard/kependudukan': (context) => const DashboardKependudukanPage(),

    // ============================================================
    // DATA WARGA
    // ============================================================
    '/data-warga/daftar': (context) => const DaftarWargaPage(),
    '/data-warga/tambah': (context) => const TambahWargaPage(),

    // ============================================================
    // DATA RUMAH
    // ============================================================
    '/data-rumah/daftar': (context) => const DaftarRumahPage(),
    '/data-rumah/tambah': (context) => const TambahRumahPage(),

    // ============================================================
    // DATA KELUARGA
    // ============================================================
    '/data-keluarga': (context) => const DaftarKeluargaPage(),

    // ============================================================
    // MUTASI KELUARGA
    // ============================================================
    '/mutasi/daftar': (context) => const MutasiDaftarPage(),
    '/mutasi/tambah': (context) => const MutasiTambahPage(),

    // === Pengeluaran ===
    '/pengeluaran/daftar': (context) => const PengeluaranDaftarPage(),
    '/pengeluaran/tambah': (context) => const TambahPengeluaranPage(),

    // === Laporan Keuangan ===
    '/laporan/semua-pemasukan': (context) => const SemuaPemasukanPage(),
    '/laporan/semua-pengeluaran': (context) => const SemuaPengeluaranPage(),
    '/laporan/cetak': (context) => const CetakLaporanPage(),

    // === Kegiatan ===
    '/kegiatan/daftar': (context) => const DaftarKegiatanPage(),
    '/kegiatan/tambah': (context) => const TambahKegiatanPage(),

    // === Broadcast ===
    '/broadcast/daftar': (context) => const DaftarBroadcastPage(),
    '/broadcast/tambah': (context) => const TambahBroadcastPage(),

    // === Manajemen Pengguna ===
    '/manajemen': (context) => const ManajemenPenggunaPage(),
    '/pengguna/daftar': (context) => const DaftarPenggunaPage(),

    // === Channel Transfer ===
    '/channel': (context) => const ChannelTransferPage(),
    '/channel/daftar': (context) => const DaftarChannelPage(),
    '/channel/tambah': (context) => const TambahChannelPage(),

    // ============================================================
    // PESAN WARGA → INFORMASI & ASPIRASI
    // ============================================================
    '/informasiAspirasi': (context) => const SemuaAspirasi(),
  };
}
