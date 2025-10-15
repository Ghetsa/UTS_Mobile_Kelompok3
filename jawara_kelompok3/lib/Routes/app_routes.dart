import 'package:flutter/material.dart';

// Import semua halaman
import '../Dashboard/dashboard_page.dart';
import '../DataWargaDanRumah/data_warga_page.dart';
import '../LaporanKeuangan/laporan_keuangan.dart';
import '../ManajemenPengguna/manajemen_pengguna.dart';
import '../ChannelTransfer/channel_transfer.dart';
import '../LogAktifitas/log_aktifitas.dart';
import '../PesanWarga/pesan_warga.dart';
import '../KegiatanDanBroadcast/kegiatan.dart';
import '../Pengeluaran/pengeluaran.dart';
import '../MutasiKeluarga/mutasi_keluarga.dart';
import '../Pemasukan/kategoriIuran/pages/iuran_page.dart';
import '../Pemasukan/kategoriIuran/pages/tambah_iuran_page.dart';
import '../Pemasukan/kategoriIuran/pages/detail_page.dart';
import '../Pemasukan/tagihIuran/tagih_iuran_page.dart';
import '../Pemasukan/tagihan/tagihan_page.dart';
import '../Pemasukan/pemasukanLain/daftar_page.dart';
import '../Pemasukan/pemasukanLain/tambah_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
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
  };
}
