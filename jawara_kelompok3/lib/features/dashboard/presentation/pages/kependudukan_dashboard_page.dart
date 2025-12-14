import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

// ✅ pakai card baru
import '../widgets/card/kependudukan_stat_warga_card.dart';
import '../widgets/card/kependudukan_stat_keluarga_card.dart';

import '../widgets/card/kependudukan_pie_card.dart';
import '../widgets/card/kependudukan_bar_card.dart';

class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  /// Helper: konversi jumlah → persen (%)
  Map<String, double> _toPercent(Map<String, int> counts) {
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return {};
    return counts.map((k, v) => MapEntry(k, v * 100.0 / total));
  }

  /// Helper: tambah 1 ke map count (untuk pie/bar)
  void _incrementCount(Map<String, int> map, String? rawKey) {
    final key = (rawKey == null || rawKey.isEmpty) ? 'Lainnya' : rawKey;
    map[key] = (map[key] ?? 0) + 1;
  }

  int _sumCounts(Map<String, int> map) {
    return map.values.fold<int>(0, (a, b) => a + b);
  }

  /// Helper: normalisasi string status (biar aman)
  String _norm(String? s) => (s ?? '').toString().trim().toLowerCase();

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

                  // ====== Untuk Pie/Bar ======
                  final statusCounts = <String, int>{};
                  final jkCounts = <String, int>{};
                  final pekerjaanCounts = <String, int>{};
                  final agamaCounts = <String, int>{};
                  final pendidikanCounts = <String, int>{};

                  // ====== Untuk Card Warga ======
                  int wargaAktif = 0;
                  int wargaNonaktif = 0;

                  for (final doc in wargaDocs) {
                    final data = doc.data() as Map<String, dynamic>;

                    // pie/bar
                    _incrementCount(
                        statusCounts, data['status_warga'] as String?);
                    _incrementCount(jkCounts, data['jenis_kelamin'] as String?);
                    _incrementCount(
                        pekerjaanCounts, data['pekerjaan'] as String?);
                    _incrementCount(agamaCounts, data['agama'] as String?);
                    _incrementCount(
                        pendidikanCounts, data['pendidikan'] as String?);

                    // card warga (hanya aktif/nonaktif)
                    final st = _norm(data['status_warga'] as String?);
                    if (st == 'aktif') wargaAktif++;
                    if (st == 'nonaktif') wargaNonaktif++;
                  }

                  // Konversi ke persentase (pie)
                  final statusPie = _toPercent(statusCounts);
                  final jkPie = _toPercent(jkCounts);
                  final pekerjaanPie = _toPercent(pekerjaanCounts);
                  final agamaPie = _toPercent(agamaCounts);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            /// KELUARGA CARD (ambil dari koleksi keluarga)
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('keluarga')
                                  .snapshots(),
                              builder: (context, keluargaSnapshot) {
                                if (!keluargaSnapshot.hasData) {
                                  return const KeluargaStatCard(
                                    aktif: 0,
                                    pindah: 0,
                                    sementara: 0,
                                  );
                                }

                                final keluargaDocs =
                                    keluargaSnapshot.data!.docs;

                                int keluargaAktif = 0;
                                int keluargaPindah = 0;
                                int keluargaSementara = 0;

                                for (final doc in keluargaDocs) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final st =
                                      _norm(data['status_keluarga'] as String?);

                                  if (st == 'aktif')
                                    keluargaAktif++;
                                  else if (st == 'pindah')
                                    keluargaPindah++;
                                  else if (st == 'sementara')
                                    keluargaSementara++;
                                }

                                return KeluargaStatCard(
                                  aktif: keluargaAktif,
                                  pindah: keluargaPindah,
                                  sementara: keluargaSementara,
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            /// WARGA CARD (dari stream warga yang sudah dihitung di atas)
                            WargaStatCard(
                              aktif: wargaAktif,
                              nonaktif: wargaNonaktif,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// PIE CHARTS
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              KependudukanPieCard(
                                title: "Status Penduduk",
                                data: statusPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : statusPie,
                                totalCount: _sumCounts(statusCounts),
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Jenis Kelamin",
                                data: jkPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : jkPie,
                                totalCount: _sumCounts(jkCounts),
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Pekerjaan Penduduk",
                                data: pekerjaanPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : pekerjaanPie,
                                totalCount: _sumCounts(pekerjaanCounts),
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Agama",
                                data: agamaPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : agamaPie,
                                totalCount: _sumCounts(agamaCounts),
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
