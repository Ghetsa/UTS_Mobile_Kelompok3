import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

import '../widgets/card/kegiatan_list_card.dart';
import '../widgets/card/kegiatan_stat_card.dart';
import '../widgets/card/kegiatan_pie_card.dart';
import '../widgets/card/kegiatan_bar_chart_card.dart';

class DashboardKegiatanPage extends StatelessWidget {
  const DashboardKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: "Dashboard Kegiatan",
              searchHint: "Cari kegiatan...",
              showSearchBar: false,
              showFilterButton: false,
            ),

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                // 🔴 SESUAIKAN NAMA KOLEKSI DI SINI
                stream: FirebaseFirestore.instance
                    .collection('kegiatan')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Terjadi kesalahan memuat data\n${snapshot.error}",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // =============== OLAH DATA ===============
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  int total = docs.length;
                  int lewat = 0;
                  int hariIni = 0;
                  int akanDatang = 0;

                  // 12 bulan, index 0=Jan, …, 11=Des
                  final List<int> perBulan = List.filled(12, 0);

                  // kategori → jumlah
                  final Map<String, double> kategoriMap = {};

                  // penanggung_jawab → jumlah
                  final Map<String, int> pjMap = {};

                  for (final d in docs) {
                    final data = d.data();

                    // 🔹 tanggal (pastikan field 'tanggal' di Firestore)
                    DateTime? tgl;
                    if (data['tanggal'] != null &&
                        data['tanggal'] is Timestamp) {
                      tgl = (data['tanggal'] as Timestamp).toDate();
                    }

                    // Klasifikasi lewat / hari ini / akan datang
                    if (tgl != null) {
                      final onlyDate =
                          DateTime(tgl.year, tgl.month, tgl.day);

                      if (onlyDate.isBefore(today)) {
                        lewat++;
                      } else if (onlyDate.isAtSameMomentAs(today)) {
                        hariIni++;
                      } else {
                        akanDatang++;
                      }

                      // Hitung per bulan
                      final monthIndex = tgl.month - 1;
                      if (monthIndex >= 0 && monthIndex < 12) {
                        perBulan[monthIndex]++;
                      }
                    }

                    // 🔹 kategori (field 'kategori', ubah kalau beda)
                    final kategori =
                        (data['kategori'] ?? 'Lainnya').toString();
                    kategoriMap[kategori] =
                        (kategoriMap[kategori] ?? 0) + 1;

                    // 🔹 penanggung_jawab (field 'penanggung_jawab', ubah kalau beda)
                    final pj = (data['penanggung_jawab'] ??
                            'Tidak diketahui')
                        .toString();
                    pjMap[pj] = (pjMap[pj] ?? 0) + 1;
                  }

                  final totalWaktu = lewat + hariIni + akanDatang;
                  final subtitleWaktu =
                      "Lewat: $lewat • Hari Ini: $hariIni • Akan Datang: $akanDatang";

                  // Konversi kategori ke persen (%)
                  final Map<String, double> kategoriPersen = {};
                  if (total > 0) {
                    kategoriMap.forEach((key, value) {
                      kategoriPersen[key] =
                          (value / total.toDouble()) * 100.0;
                    });
                  }

                  // Penanggung jawab terbanyak
                  String topPj = "-";
                  int topCount = 0;
                  if (pjMap.isNotEmpty) {
                    final sorted = pjMap.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));

                    topPj = sorted.first.key;
                    topCount = sorted.first.value;
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // TOTAL KEGIATAN
                        KegiatanStatCard(
                          title: "Total Kegiatan",
                          value: total.toString(),
                          subtitle:
                              "Jumlah seluruh kegiatan yang tercatat",
                        ),

                        const SizedBox(height: 16),

                        // KEGIATAN BERDASARKAN WAKTU
                        KegiatanStatCard(
                          title: "Kegiatan berdasarkan Waktu",
                          value: totalWaktu.toString(),
                          subtitle: subtitleWaktu,
                        ),

                        const SizedBox(height: 16),

                        // PIE KATEGORI
                        KegiatanPieCard(
                          data: kategoriPersen,
                        ),

                        const SizedBox(height: 16),

                        // BAR PER BULAN
                        KegiatanBarChartCard(
                          monthlyData: perBulan,
                        ),

                        const SizedBox(height: 16),

                        // PENANGGUNG JAWAB TERBANYAK
                        KegiatanListCard(
                          nama: topPj,
                          jumlah: topCount,
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
