import 'package:flutter/material.dart';
import 'package:jawara_kelompok3/features/laporan/presentation/pages/pemasukan/pemasukan_lain/tambah_pemasukan_lain_page.dart';

// === Login ===
import '../../features/auth/presentation/pages/login/login.dart';
import '../../features/auth/presentation/pages/login/login_wrapper.dart';

// === Register ===
import '../../features/auth/presentation/pages/register/register_screen.dart';

// === Dashboard ===
import '../../features/dashboard/presentation/pages/kegiatan_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/kependudukan_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/keuangan_dashboard_page.dart';

// === Data Warga & Rumah ===
import '../../features/kependudukan/presentation/pages/warga/daftar_warga_page.dart';
import '../../features/kependudukan/presentation/pages/warga/tambah_warga_page.dart';

import '../../features/kependudukan/presentation/pages/rumah/daftar_rumah_page.dart';
import '../../features/kependudukan/presentation/pages/rumah/tambah_rumah_page.dart';

import '../../features/kependudukan/presentation/pages/keluarga/keluarga_page.dart';

// === Mutasi Keluarga ===
import '../../features/kependudukan/presentation/pages/mutasi/daftar_mutasi_page.dart';
import '../../features/kependudukan/presentation/pages/mutasi/tambah_mutasi_page.dart';

// === Pengeluaran ===
import '../../features/laporan/presentation/pages/pengeluaran/daftar_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/semua_pengeluaran_page.dart';
import '../../features/laporan/presentation/pages/pengeluaran/tambah_pengeluaran_page.dart';

// === Laporan Keuangan ===
import '../../features/laporan/presentation/pages/pemasukan/cetak_laporan_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/kategori_iuran/iuran_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/pemasukan_lain/daftar_pemasukan_lain_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/tagih_iuran/tagih_iuran_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/tagihan/tagihan_page.dart';
import '../../features/laporan/presentation/pages/pemasukan/pemasukan_page.dart';

// === Kegiatan & Broadcast ===
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/daftar_kegiatan_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan/tambah_kegiatan_page.dart';

import '../../features/kegiatan_broadcast/presentation/pages/broadcast/daftar_broadcast_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/broadcast/tambah_broadcast_page.dart';

// === Manajemen Pengguna ===
import '../../features/manajemen_pengguna/presentation/manajemen_pengguna_page.dart';
import '../../features/manajemen_pengguna/presentation/pages/daftar_pengguna_page.dart';
import '../../features/manajemen_pengguna/presentation/pages/tambah_pengguna_page.dart';

// === Channel Transfer ===
import '../../features/channel_transfer/channel_transfer_page.dart';
import '../../features/channel_transfer/presentation/pages/daftar_channel_page.dart';
import '../../features/channel_transfer/presentation/pages/tambah_channel_page.dart';

//  === Aspirasi Warga ===
import '../../features/pesan_warga/presentation/pages/informasi_aspirasi_page.dart';
import '../../features/pesan_warga/presentation/pages/tambah_aspirasi_page.dart';

// === Log Aktivitas ===
import '../../features/aktivitas/presentation/log_aktivitas_page.dart';
import '../../features/aktivitas/presentation/pages/daftar_log_aktivitas.dart';

// Gate route (auto pilih dashboard sesuai role)
import '../../features/dashboard/presentation/pages/dashboard_gate_page.dart';

// Halaman warga yang kamu buat
import '../../features/WARGA/presentation/pages/warga_dashboard_page.dart';
import '../../features/WARGA/presentation/pages/warga_kegiatan_page.dart';
import '../../features/WARGA/presentation/pages/warga_aspirasi_page.dart';
import '../../features/WARGA/presentation/pages/warga_profile_page.dart';
import '../../features/WARGA/presentation/pages/warga_tagihan_page.dart';
import '../../features/WARGA/presentation/pages/warga_bayar_tagihan_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // === Default Route ===
    '/': (context) => const LoginScreenWrapper(),

    // === Login ===
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),

    // Dashboard role-based
    '/dashboard/admin': (context) => const DashboardKegiatanPage(),
    '/dashboard/rt': (context) => const DashboardKegiatanPage(),
    '/dashboard/rw': (context) => const DashboardKegiatanPage(),
    '/dashboard/bendahara': (context) => const DashboardKegiatanPage(),
    '/dashboard/sekretaris': (context) => const DashboardKegiatanPage(),

    // === Dashboard ===
    '/dashboard/kegiatan': (context) => const DashboardGatePage(),
    '/dashboard/keuangan': (context) => DashboardKeuanganPage(),
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

    // ============================================================
    // PEMASUKAN
    // ============================================================
    '/pemasukan/pages/kategori': (context) => const KategoriIuranPage(),
    '/pemasukan/tagihIuran': (context) => const TagihIuranPage(),
    '/pemasukan/tagihan': (context) => const TagihanPage(),
    '/pemasukan/pemasukanLain-daftar': (context) =>
        const PemasukanLainDaftarPage(),
    '/pemasukan/pemasukanLain-tambah': (context) =>
        const PemasukanLainTambahPage(),
    '/pemasukan': (context) => const PemasukanPage(),

    // === Pengeluaran ===
    '/pengeluaran': (context) => const PengeluaranDaftarPage(),
    '/pengeluaran/daftar': (context) => const PengeluaranDaftarPage(),
    '/pengeluaran/semua': (context) => const SemuaPengeluaranPage(),
    '/pengeluaran/tambah': (context) => const TambahPengeluaranPage(),

    // === Laporan Keuangan ===
    '/laporan/semua-pengeluaran': (context) => const PengeluaranDaftarPage(),
    '/laporan/cetak': (context) => const CetakLaporanPage(),

    // === Kegiatan ===
    '/kegiatan/daftar': (context) => const DaftarKegiatanPage(),
    '/kegiatan/tambah': (context) => const TambahKegiatanPage(),

    // === Broadcast ===
    '/broadcast/daftar': (context) => const DaftarBroadcastPage(),
    '/broadcast/tambah': (context) => const TambahBroadcastPage(),

    // === Manajemen Pengguna ===
    '/manajemen': (context) => const ManajemenPenggunaPage(),
    '/pengguna/penggunaDaftar': (context) => const DaftarPenggunaPage(),
    '/pengguna/penggunaTambah': (context) => const TambahPenggunaPage(),

    // === Channel Transfer ===
    '/channel': (context) => const ChannelTransferPage(),
    '/channel/channelDaftar': (context) => const DaftarChannelPage(),
    '/channel/channelTambah': (context) => const TambahChannelPage(),

    // === Log Aktivitas ===
    '/aktivitas': (context) => const LogAktivitasPage(),
    '/aktivitas/daftar': (context) => const DaftarLogAktivitasPage(),

    // === Pesan/Aspirasi Warga ===
    '/aspirasi/informasiAspirasi': (context) => const InformasiAspirasi(),
    '/aspirasi/tambahAspirasi': (context) => const TambahAspirasiPage(),

    // =====================
// WARGA ROUTES
// =====================
    '/warga/dashboard': (context) => const WargaDashboardPage(),
    '/warga/kegiatan': (context) => const WargaKegiatanPage(),
    '/warga/aspirasi': (context) => const WargaAspirasiPage(),
    '/warga/profil': (context) => const WargaProfilePage(),
    '/warga/tagihan': (context) => const TagihanWargaPage(), 
    '/warga/bayarTagihan': (context) => const BayarTagihanPage(),
  };
}
