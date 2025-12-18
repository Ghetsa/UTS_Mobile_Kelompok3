import 'package:flutter/material.dart';

import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/layout/header.dart';

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

  String _formatShortNominal(double value) {
    final v = value.abs();
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

  void _inc(Map<String, double> map, String key, double value) {
    final k = key.trim().isEmpty ? 'Lainnya' : key.trim();
    map[k] = (map[k] ?? 0) + value;
  }

  String _monthLabel(DateTime date) {
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

  /// ✅ Ambil TOP N kategori, sisanya digabung ke "Lainnya"
  Map<String, double> topNWithOthers(
    Map<String, double> source, {
    int topN = 4,
  }) {
    if (source.isEmpty) return {};
    if (source.length <= topN) return source;

    // urutkan dari nominal terbesar
    final entries = source.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top = entries.take(topN).toList();
    final rest = entries.skip(topN);

    double othersTotal = 0;
    for (final e in rest) {
      othersTotal += e.value;
    }

    final Map<String, double> result = {};
    for (final e in top) {
      result[e.key] = (result[e.key] ?? 0) + e.value;
    }

    // gabungkan sisa ke "Lainnya" (aman kalau "Lainnya" sudah ada)
    result['Lainnya'] = (result['Lainnya'] ?? 0) + othersTotal;

    if ((result['Lainnya'] ?? 0) == 0) {
      result.remove('Lainnya');
    }

    return result;
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

                  // ✅ Pie: pakai JENIS sebagai kategori
                  final pemasukanByJenis = <String, double>{};
                  final pengeluaranByJenis = <String, double>{};

                  for (final t in list) {
                    final nominal = t.nominal;
                    if (nominal == 0) continue;

                    final bulan = _monthLabel(t.tanggal);
                    final jenis =
                        t.jenis.trim().isEmpty ? 'Lainnya' : t.jenis.trim();

                    // ✅ PEMASUKAN vs PENGELUARAN ditentukan dari KOLEKSI (sumber)
                    if (t.sumber == 'pemasukan') {
                      totalPemasukan += nominal;
                      countPemasukan++;

                      if (pemasukanPerBulan.containsKey(bulan)) {
                        pemasukanPerBulan[bulan] =
                            (pemasukanPerBulan[bulan] ?? 0) + nominal;
                      }

                      _inc(pemasukanByJenis, jenis, nominal);
                    } else if (t.sumber == 'pengeluaran') {
                      totalPengeluaran += nominal;
                      countPengeluaran++;

                      if (pengeluaranPerBulan.containsKey(bulan)) {
                        pengeluaranPerBulan[bulan] =
                            (pengeluaranPerBulan[bulan] ?? 0) + nominal;
                      }

                      _inc(pengeluaranByJenis, jenis, nominal);
                    }
                  }

                  final totalKas = totalPemasukan - totalPengeluaran;

                  final screenWidth = MediaQuery.of(context).size.width;
                  final cardWidth = screenWidth * 0.85;

                  //  LIMIT PIE CHART KE TOP 4
                  final pemasukanPieLimited =
                      topNWithOthers(pemasukanByJenis, topN: 4);

                  final pengeluaranPieLimited =
                      topNWithOthers(pengeluaranByJenis, topN: 4);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
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
                        KeuanganKasCard(
                          value: _formatShortNominal(totalKas),
                          isNegative: totalKas < 0,
                        ),
                        const SizedBox(height: 16),
                        KeuanganSummaryCard(
                          pemasukanCount: countPemasukan,
                          pengeluaranCount: countPengeluaran,
                          totalTransaksi: jumlahTransaksi,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 370,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: cardWidth,
                                child: PieCard(
                                  title: "Pemasukan Berdasarkan Jenis",
                                  textColor: AppTheme.greenDark,
                                  data: pemasukanPieLimited.isEmpty
                                      ? {"Belum ada data": 1}
                                      : pemasukanPieLimited,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: cardWidth,
                                child: PieCard(
                                  title: "Pengeluaran Berdasarkan Jenis",
                                  textColor: AppTheme.redDark,
                                  data: pengeluaranPieLimited.isEmpty
                                      ? {"Belum ada data": 1}
                                      : pengeluaranPieLimited,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
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
