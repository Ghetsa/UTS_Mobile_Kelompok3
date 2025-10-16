import 'package:flutter/material.dart';

// === Dashboard ===
import '../Dashboard/kegiatan.dart';
import '../Dashboard/keuangan.dart';
import '../Dashboard/kependudukan.dart';

// === Menu Utama ===
import '../DataWargaDanRumah/data_warga_page.dart';
import '../LaporanKeuangan/laporan_keuangan.dart';
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
import '../Pemasukan/kategoriIuran/pages/detail_page.dart';
import '../Pemasukan/tagihIuran/tagih_iuran_page.dart';
import '../Pemasukan/tagihan/tagihan_page.dart';
import '../Pemasukan/pemasukanLain/daftar_page.dart';
import '../Pemasukan/pemasukanLain/tambah_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // === Default Route ===
    '/': (context) => const DashboardKegiatanPage(),

    // === Dashboard ===
    '/dashboard/kegiatan': (context) => const DashboardKegiatanPage(),
    '/dashboard/keuangan': (context) => const DashboardKeuanganPage(),
    '/dashboard/kependudukan': (context) => const DashboardKependudukanPage(),

    // === Pemasukan: Kategori Iuran ===
    '/pemasukan/kategori': (context) => const KategoriIuranPage(),
    '/pemasukan/kategori/tambah': (context) => const TambahKategoriPage(),
    '/pemasukan/kategori/detail': (context) => const DetailKategoriPage(),

    // === Pemasukan: Tagih dan Tagihan ===
    '/pemasukan/tagih-iuran': (context) => const TagihIuranPage(),
    '/pemasukan/tagihan': (context) => const TagihanPage(),

    // === Pemasukan: Lain-lain ===
    '/pemasukan/lain/daftar': (context) => const PemasukanLainDaftarPage(),
    '/pemasukan/lain/tambah': (context) => const PemasukanLainTambahPage(),

    // === Pengeluaran ===
    '/pengeluaran': (context) => const PengeluaranPage(),

    // === Kegiatan & Broadcast ===
    '/kegiatan': (context) => const KegiatanBroadcastPage(),

    // === Data Warga dan Rumah ===
    '/data': (context) => const DataWargaPage(),

    // === Mutasi Keluarga ===
    '/mutasi': (context) => const MutasiKeluargaPage(),

    // === Laporan Keuangan ===
    '/laporan': (context) => const LaporanKeuanganPage(),

    // === Manajemen Pengguna ===
    '/manajemen': (context) => const ManajemenPenggunaPage(),

    // === Channel Transfer ===
    '/channel': (context) => const ChannelTransferPage(),

    // === Log Aktivitas ===
    '/log': (context) => const LogAktifitasPage(),

    // === Pesan Warga ===
    '/pesan': (context) => const PesanWargaPage(),
  };
}
