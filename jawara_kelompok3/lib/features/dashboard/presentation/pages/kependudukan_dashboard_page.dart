import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

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

  /// Helper: tambah 1 ke map count (untuk pie/bar) — aman untuk null/kosong
  void _incrementCount(Map<String, int> map, String? rawKey) {
    final key =
        (rawKey == null || rawKey.trim().isEmpty) ? 'Lainnya' : rawKey.trim();
    map[key] = (map[key] ?? 0) + 1;
  }

  /// Helper: normalisasi string status (biar aman)
  String _norm(String? s) => (s ?? '').toString().trim().toLowerCase();

  /// ✅ ambil TOP N kategori, sisanya jadi "Lainnya"
  /// - keep: jumlah kategori teratas yang ditampilkan
  /// - Jika sudah ada key "Lainnya" di data, tetap aman (digabung)
  Map<String, int> _topNWithOthers(Map<String, int> counts, {int keep = 4}) {
    if (counts.isEmpty) return {};

    // urutkan desc berdasarkan jumlah
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // kalau kategori <= keep, tidak perlu digabung
    if (entries.length <= keep) return Map<String, int>.fromEntries(entries);

    final top = entries.take(keep).toList();
    final rest = entries.skip(keep);

    int others = 0;
    for (final e in rest) {
      others += e.value;
    }

    final result = <String, int>{};
    for (final e in top) {
      result[e.key] = (result[e.key] ?? 0) + e.value;
    }

    // gabungkan sisa ke "Lainnya"
    result['Lainnya'] = (result['Lainnya'] ?? 0) + others;

    if (result['Lainnya'] == 0) result.remove('Lainnya');

    return result;
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

                  final statusCounts = <String, int>{};
                  final jkCounts = <String, int>{};
                  final pekerjaanCounts = <String, int>{};
                  final agamaCounts = <String, int>{};
                  final pendidikanCounts = <String, int>{};

                  int wargaAktif = 0;
                  int wargaNonaktif = 0;

                  int totalWargaUntukChart = 0;

                  for (final doc in wargaDocs) {
                    final data = (doc.data() as Map<String, dynamic>);

                    final stNorm = _norm(data['status_warga'] as String?);
                    final bool isAktif = stNorm == 'aktif';
                    final bool isNonaktif = stNorm == 'nonaktif';
                    if (!isAktif && !isNonaktif) continue;

                    totalWargaUntukChart++;

                    if (isAktif) wargaAktif++;
                    if (isNonaktif) wargaNonaktif++;

                    _incrementCount(
                        statusCounts, isAktif ? "Aktif" : "Nonaktif");

                    _incrementCount(
                        jkCounts, (data['jenis_kelamin'] as String?)?.trim());
                    _incrementCount(pekerjaanCounts,
                        (data['pekerjaan'] as String?)?.trim());
                    _incrementCount(
                        agamaCounts, (data['agama'] as String?)?.trim());
                    _incrementCount(pendidikanCounts,
                        (data['pendidikan'] as String?)?.trim());
                  }

                  // ✅ khusus pekerjaan: TOP 4 + Lainnya
                  final pekerjaanCountsTop =
                      _topNWithOthers(pekerjaanCounts, keep: 4);

                  // ✅ khusus agama: TOP 5 + Lainnya
                  final agamaCountsTop = _topNWithOthers(agamaCounts, keep: 5);

                  final statusPie = _toPercent(statusCounts);
                  final jkPie = _toPercent(jkCounts);
                  final pekerjaanPie = _toPercent(pekerjaanCountsTop);
                  final agamaPie = _toPercent(agamaCountsTop);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Column(
                          children: [
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
                                      (doc.data() as Map<String, dynamic>);
                                  final st =
                                      _norm(data['status_keluarga'] as String?);

                                  if (st == 'aktif') {
                                    keluargaAktif++;
                                  } else if (st == 'pindah') {
                                    keluargaPindah++;
                                  } else if (st == 'sementara') {
                                    keluargaSementara++;
                                  }
                                }

                                return KeluargaStatCard(
                                  aktif: keluargaAktif,
                                  pindah: keluargaPindah,
                                  sementara: keluargaSementara,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            WargaStatCard(
                              aktif: wargaAktif,
                              nonaktif: wargaNonaktif,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              KependudukanPieCard(
                                title: "Status Penduduk",
                                data: statusPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : statusPie,
                                totalCount: totalWargaUntukChart,
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Jenis Kelamin",
                                data: jkPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : jkPie,
                                totalCount: totalWargaUntukChart,
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Pekerjaan Penduduk",
                                data: pekerjaanPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : pekerjaanPie,
                                totalCount: totalWargaUntukChart,
                              ),
                              const SizedBox(width: 16),
                              KependudukanPieCard(
                                title: "Agama",
                                data: agamaPie.isEmpty
                                    ? {"Belum ada data": 100}
                                    : agamaPie,
                                totalCount: totalWargaUntukChart,
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
