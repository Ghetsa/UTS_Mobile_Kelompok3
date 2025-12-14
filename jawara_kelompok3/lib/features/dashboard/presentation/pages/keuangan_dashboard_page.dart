import 'package:flutter/material.dart';

import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/layout/header.dart';

// SESUAIKAN PATH MODEL & SERVICE
import '../../data/models/keuangan_dashboard_model.dart';
import '../../data/services/keuangan_dashboard_service.dart';

import '../widgets/card/keuangan_stat_card.dart';
import '../widgets/card/keuangan_stat_card_row.dart';
import '../widgets/card/keuangan_bar_chart_card.dart';
import '../widgets/card/keuangan_pie_card.dart';
import '../widgets/card/keuangan_summary_card.dart';
import '../widgets/card/keuangan_kas_card.dart';

class DashboardKeuanganPage extends StatelessWidget {
  DashboardKeuanganPage({super.key});

  final KeuanganService _service = KeuanganService();

  /// Format angka pendek: 1.2 jt / 2.1 rb / 950
  String _formatShortNominal(double value) {
    final v = value.abs(); // biar -1.2jt tetap tampil rapi
    if (v >= 1000000) {
      final s = (v / 1000000).toStringAsFixed(1);
      return value < 0 ? '-$s jt' : '$s jt';
    } else if (v >= 1000) {
      final s = (v / 1000).toStringAsFixed(1);
      return value < 0 ? '-$s rb' : '$s rb';
    } else {
      final s = v.toStringAsFixed(0);
      return value < 0 ? '-$s' : s;
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: "Dashboard Keuangan",
              searchHint: "Cari transaksi...",
              showSearchBar: false,
              showFilterButton: false,
            ),
            Expanded(
              child: FutureBuilder<List<KeuanganModel>>(
                future: _service.getAllKeuangan(),
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

                  final list = snapshot.data ?? [];
                  final jumlahTransaksi = list.length;

                  double totalPemasukan = 0;
                  double totalPengeluaran = 0;

                  int countPemasukan = 0;
                  int countPengeluaran = 0;

                  final pemasukanPerBulan = _initMonthMap();
                  final pengeluaranPerBulan = _initMonthMap();

                  // map NOMINAL per kategori
                  final pemasukanKategori = <String, double>{};
                  final pengeluaranKategori = <String, double>{};

                  for (final t in list) {
                    final nominal = t.nominal;
                    if (nominal == 0) continue;

                    final bulanLabel = _monthLabelFromDate(t.tanggal);
                    final kategori = t.kategori;
                    final tipeLower = t.tipe.toLowerCase();

                    final isPemasukan = tipeLower == 'pemasukan';
                    final isPengeluaran = tipeLower == 'pengeluaran';

                    if (isPemasukan) {
                      totalPemasukan += nominal;
                      countPemasukan++;

                      if (bulanLabel.isNotEmpty &&
                          pemasukanPerBulan.containsKey(bulanLabel)) {
                        pemasukanPerBulan[bulanLabel] =
                            (pemasukanPerBulan[bulanLabel] ?? 0) + nominal;
                      }

                      _incrementKategori(pemasukanKategori, kategori, nominal);
                    } else if (isPengeluaran) {
                      totalPengeluaran += nominal;
                      countPengeluaran++;

                      if (bulanLabel.isNotEmpty &&
                          pengeluaranPerBulan.containsKey(bulanLabel)) {
                        pengeluaranPerBulan[bulanLabel] =
                            (pengeluaranPerBulan[bulanLabel] ?? 0) + nominal;
                      }

                      _incrementKategori(
                          pengeluaranKategori, kategori, nominal);
                    }
                  }

                  // ✅ TOTAL KAS
                  final double totalKas = totalPemasukan - totalPengeluaran;

                  final screenWidth = MediaQuery.of(context).size.width;
                  final cardWidth = screenWidth * 0.85;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // ====== TOTAL PEMASUKAN / PENGELUARAN ======
                        StatCardRow(
                          cards: [
                            StatCard(
                              title: "Total Pemasukan",
                              value: _formatShortNominal(totalPemasukan),
                              subtitle: "Sampai hari ini",
                              background: Colors.white,
                              textColor: AppTheme.greenDark,
                            ),
                            StatCard(
                              title: "Total Pengeluaran",
                              value: _formatShortNominal(totalPengeluaran),
                              subtitle: "Sampai hari ini",
                              background: Colors.white,
                              textColor: AppTheme.redDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ====== TOTAL KAS SAAT INI (CARD KHUSUS) ======
                        KeuanganKasCard(
                          value: _formatShortNominal(totalKas),
                          isNegative: totalKas < 0,
                        ),

                        const SizedBox(height: 16),

                        // ====== TOTAL TRANSAKSI ala 'Total Kegiatan' ======
                        KeuanganSummaryCard(
                          pemasukanCount: countPemasukan,
                          pengeluaranCount: countPengeluaran,
                          totalTransaksi: jumlahTransaksi,
                        ),

                        const SizedBox(height: 16),

                        // ===== PIE CHART (1 BARIS, SCROLL HORIZONTAL) =====
                        SizedBox(
                          height: 320,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: cardWidth,
                                child: PieCard(
                                  title: "Pemasukan Berdasarkan Kategori",
                                  textColor: AppTheme.greenDark,
                                  data: pemasukanKategori.isEmpty
                                      ? {"Belum ada data": 1}
                                      : pemasukanKategori,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: cardWidth,
                                child: PieCard(
                                  title: "Pengeluaran Berdasarkan Kategori",
                                  textColor: AppTheme.redDark,
                                  data: pengeluaranKategori.isEmpty
                                      ? {"Belum ada data": 1}
                                      : pengeluaranKategori,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== BAR CHART (1 BARIS, SCROLL HORIZONTAL) =====
                        SizedBox(
                          height: 450,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: cardWidth,
                                child: BarChartCard(
                                  title: "Pemasukan per Bulan",
                                  textColor: AppTheme.greenDark,
                                  data: pemasukanPerBulan,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: cardWidth,
                                child: BarChartCard(
                                  title: "Pengeluaran per Bulan",
                                  textColor: AppTheme.redDark,
                                  data: pengeluaranPerBulan,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
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
