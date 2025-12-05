import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/layout/header.dart';

import '../widgets/card/keuangan_stat_card.dart';
import '../widgets/card/keuangan_stat_card_row.dart';
import '../widgets/card/keuangan_bar_chart_card.dart';
import '../widgets/card/keuangan_pie_card.dart';

class DashboardKeuanganPage extends StatelessWidget {
  const DashboardKeuanganPage({super.key});

  // ====== KONFIGURASI NAMA KOLEKSI & FIELD FIRESTORE ======
  static const String collectionName = 'keuangan'; // << ganti kalau beda
  static const String fieldTipe = 'tipe'; // 'pemasukan' / 'pengeluaran'
  static const String fieldNominal = 'nominal'; // num
  static const String fieldTanggal = 'tanggal'; // Timestamp
  static const String fieldKategori = 'kategori'; // String

  /// Format angka pendek: 1.2 jt / 2.1 rb / 950
  String _formatShortNominal(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)} rb';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  /// Inisialisasi map 12 bulan
  Map<String, double> _initMonthMap() {
    return {
      'Jan': 0,
      'Feb': 0,
      'Mar': 0,
      'Apr': 0,
      'Mei': 0,
      'Jun': 0,
      'Jul': 0,
      'Agu': 0,
      'Sep': 0,
      'Okt': 0,
      'Nov': 0,
      'Des': 0,
    };
  }

  /// Konversi Map nilai → persentase (%)
  Map<String, double> _toPercent(Map<String, double> source) {
    final total = source.values.fold<double>(0, (a, b) => a + b);
    if (total == 0) return {};
    return source.map(
      (k, v) => MapEntry(k, (v / total) * 100),
    );
  }

  void _incrementKategori(
      Map<String, double> map, String? rawKey, double value) {
    final key = (rawKey == null || rawKey.isEmpty) ? 'Lainnya' : rawKey;
    map[key] = (map[key] ?? 0) + value;
  }

  String _monthLabelFromDate(DateTime? date) {
    if (date == null) return '';
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'Mei';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Agu';
      case 9:
        return 'Sep';
      case 10:
        return 'Okt';
      case 11:
        return 'Nov';
      case 12:
        return 'Des';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final keuanganStream =
        FirebaseFirestore.instance.collection(collectionName).snapshots();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            /// ===== HEADER =====
            const MainHeader(
              title: "Dashboard Keuangan",
              searchHint: "Cari transaksi...",
              showSearchBar: false,
              showFilterButton: false,
            ),

            /// ===== BODY (STREAM BUILDER FIRESTORE) =====
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: keuanganStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Terjadi error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  final jumlahTransaksi = docs.length;

                  double totalPemasukan = 0;
                  double totalPengeluaran = 0;

                  // per bulan
                  final pemasukanPerBulan = _initMonthMap();
                  final pengeluaranPerBulan = _initMonthMap();

                  // kategori
                  final pemasukanKategori = <String, double>{};
                  final pengeluaranKategori = <String, double>{};

                  for (final doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;

                    final tipe = (data[fieldTipe] as String?)?.toLowerCase();
                    final nominalRaw = data[fieldNominal] as num?;
                    final nominal = (nominalRaw ?? 0).toDouble();

                    final timestamp = data[fieldTanggal] as Timestamp?;
                    final tanggal = timestamp?.toDate();
                    final bulanLabel = _monthLabelFromDate(tanggal);

                    final kategori = data[fieldKategori] as String?;

                    if (tipe == 'pemasukan') {
                      totalPemasukan += nominal;

                      if (bulanLabel.isNotEmpty &&
                          pemasukanPerBulan.containsKey(bulanLabel)) {
                        pemasukanPerBulan[bulanLabel] =
                            (pemasukanPerBulan[bulanLabel] ?? 0) + nominal;
                      }

                      _incrementKategori(pemasukanKategori, kategori, nominal);
                    } else if (tipe == 'pengeluaran') {
                      totalPengeluaran += nominal;

                      if (bulanLabel.isNotEmpty &&
                          pengeluaranPerBulan.containsKey(bulanLabel)) {
                        pengeluaranPerBulan[bulanLabel] =
                            (pengeluaranPerBulan[bulanLabel] ?? 0) + nominal;
                      }

                      _incrementKategori(
                          pengeluaranKategori, kategori, nominal);
                    }
                  }

                  // Konversi kategori ke persen untuk PIE
                  final pemasukanKategoriPercent =
                      _toPercent(pemasukanKategori);
                  final pengeluaranKategoriPercent =
                      _toPercent(pengeluaranKategori);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// ====== STAT CARD 2 KOLOM DINAMIS ======
                        StatCardRow(
                          cards: [
                            StatCard(
                              title: "Total Pemasukan",
                              value: _formatShortNominal(totalPemasukan),
                              background: Colors.white,
                              textColor: AppTheme.greenDark,
                            ),
                            StatCard(
                              title: "Total Pengeluaran",
                              value: _formatShortNominal(totalPengeluaran),
                              background: Colors.white,
                              textColor: AppTheme.redDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ====== STAT CARD JUMLAH TRANSAKSI ======
                        StatCard(
                          title: "Jumlah Transaksi",
                          value: jumlahTransaksi.toString(),
                          centered: true,
                          background: Colors.white,
                          textColor: AppTheme.yellowDark,
                        ),

                        const SizedBox(height: 16),

                        /// ===== BAR CHART PEMASUKAN =====
                        BarChartCard(
                          title: "📈 Pemasukan per Bulan",
                          textColor: AppTheme.greenDark,
                          data: pemasukanPerBulan,
                        ),

                        const SizedBox(height: 16),

                        /// ===== BAR CHART PENGELUARAN =====
                        BarChartCard(
                          title: "📉 Pengeluaran per Bulan",
                          textColor: AppTheme.blueDark,
                          data: pengeluaranPerBulan,
                        ),

                        const SizedBox(height: 16),

                        /// ===== PIE PEMASUKAN KATEGORI =====
                        PieCard(
                          title: "🧾 Pemasukan Berdasarkan Kategori",
                          textColor: AppTheme.yellowSuperDark,
                          data: pemasukanKategoriPercent.isEmpty
                              ? {"Belum ada data": 100}
                              : pemasukanKategoriPercent,
                        ),

                        const SizedBox(height: 16),

                        /// ===== PIE PENGELUARAN KATEGORI =====
                        PieCard(
                          title: "🧾 Pengeluaran Berdasarkan Kategori",
                          textColor: AppTheme.yellowSuperDark,
                          data: pengeluaranKategoriPercent.isEmpty
                              ? {"Belum ada data": 100}
                              : pengeluaranKategoriPercent,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
