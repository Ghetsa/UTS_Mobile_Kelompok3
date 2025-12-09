import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/card/kependudukan_stat_card.dart';
import '../widgets/card/kependudukan_pie_card.dart';
import '../widgets/card/kependudukan_bar_card.dart';

class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  /// Helper: konversi jumlah → persen (%)
  Map<String, double> _toPercent(Map<String, int> counts) {
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return {};
    return counts.map(
      (k, v) => MapEntry(k, v * 100.0 / total),
    );
  }

  /// Helper: tambah 1 ke map count
  void _incrementCount(Map<String, int> map, String? rawKey) {
    final key = (rawKey == null || rawKey.isEmpty) ? 'Lainnya' : rawKey;
    map[key] = (map[key] ?? 0) + 1;
  }

  int _sumCounts(Map<String, int> map) {
    return map.values.fold<int>(0, (a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final wargaStream =
        FirebaseFirestore.instance.collection('warga').snapshots();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: "Dashboard Kependudukan",
              searchHint: "Cari penduduk...",
              showSearchBar: false,
              showFilterButton: false,
            ),

            /// ====== KONTEN DINAMIS DARI FIRESTORE (warga) ======
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: wargaStream,
                builder: (context, wargaSnapshot) {
                  if (wargaSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (wargaSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Terjadi error: ${wargaSnapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final wargaDocs = wargaSnapshot.data?.docs ?? [];
                  final totalPenduduk = wargaDocs.length;

                  // ====== Hitung distribusi berdasarkan field di koleksi `warga` ======
                  final statusCounts = <String, int>{};
                  final jkCounts = <String, int>{};
                  final pekerjaanCounts = <String, int>{};
                  final agamaCounts = <String, int>{};
                  final pendidikanCounts = <String, int>{};

                  for (final doc in wargaDocs) {
                    final data = doc.data() as Map<String, dynamic>;

                    _incrementCount(
                      statusCounts,
                      data['status_warga'] as String?, // <-- ganti sesuai field
                    );
                    _incrementCount(
                      jkCounts,
                      data['jenis_kelamin']
                          as String?, // ex: "Laki-laki"/"Perempuan"
                    );
                    _incrementCount(
                      pekerjaanCounts,
                      data['pekerjaan']
                          as String?, // ex: "PNS", "Wiraswasta", ...
                    );
                    _incrementCount(
                      agamaCounts,
                      data['agama'] as String?,
                    );
                    _incrementCount(
                      pendidikanCounts,
                      data['pendidikan']
                          as String?, // ex: "SD", "SMP", "SMA", "S1"
                    );
                  }

                  // Konversi ke persentase
                  final statusPie = _toPercent(statusCounts);
                  final jkPie = _toPercent(jkCounts);
                  final pekerjaanPie = _toPercent(pekerjaanCounts);
                  final agamaPie = _toPercent(agamaCounts);
// final pendidikanPie = _toPercent(pendidikanCounts);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// ==== STAT CARDS (Total Keluarga, Total Penduduk) ====
                        Row(
                          children: [
                            /// Total Keluarga dari koleksi `keluarga`
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('keluarga')
                                    .snapshots(),
                                builder: (context, keluargaSnapshot) {
                                  if (!keluargaSnapshot.hasData) {
                                    return const KependudukanStatCard(
                                      title: "Total Keluarga",
                                      value: "-",
                                      background: Colors.white,
                                      textColor: AppTheme.greenDark,
                                      centered: false,
                                    );
                                  }

                                  final totalKeluarga =
                                      keluargaSnapshot.data!.docs.length;

                                  return KependudukanStatCard(
                                    title: "Total Keluarga",
                                    value: totalKeluarga.toString(),
                                    background: Colors.white,
                                    textColor: AppTheme.greenDark,
                                    centered: false,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),

                            /// Total Penduduk dari jumlah dokumen `warga`
                            Expanded(
                              child: KependudukanStatCard(
                                title: "Total Penduduk",
                                value: totalPenduduk.toString(),
                                background: Colors.white,
                                textColor: AppTheme.redDark,
                                centered: false,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ==== PIE CHARTS SCROLL HORIZONTAL (DINAMIS) ====
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              KependudukanPieCard(
                                title: "Status Penduduk",
                                data: statusPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : statusPie,
                                totalCount: _sumCounts(statusCounts), // 🔥
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Jenis Kelamin",
                                data: jkPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : jkPie,
                                totalCount: _sumCounts(jkCounts), // 🔥
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Pekerjaan Penduduk",
                                data: pekerjaanPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : pekerjaanPie,
                                totalCount: _sumCounts(pekerjaanCounts), // 🔥
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Agama",
                                data: agamaPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : agamaPie,
                                totalCount: _sumCounts(agamaCounts), // 🔥
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        KependudukanBarCard(
                          title: "Pendidikan Penduduk",
                          data: pendidikanCounts,
                        ),

                        const SizedBox(height: 30),

                        const SizedBox(height: 30),
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
