import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

import '../widgets/card/kegiatan_list_card.dart';
import '../widgets/card/kegiatan_stat_card.dart';
import '../widgets/card/kegiatan_pie_card.dart';
import '../widgets/card/kegiatan_bar_chart_card.dart';
import '../widgets/card/kegiatan_waktu_card.dart';

// 🔹 import halaman daftar kegiatan
import '../../../kegiatan/presentation/pages/daftar_kegiatan_page.dart';

class DashboardKegiatanPage extends StatelessWidget {
  const DashboardKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 4,
        icon: const Icon(Icons.event_note, color: Colors.white),
        label: const Text(
          "Lihat Kegiatan",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DaftarKegiatanPage(),
            ),
          );
        },
      ),
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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  int total = docs.length;
                  int lewat = 0;
                  int sedangBerlangsung = 0; // ⬅️ BUKAN lagi "hari ini"
                  int akanDatang = 0;

                  final List<int> perBulan = List.filled(12, 0);
                  final Map<String, double> kategoriMap = {};
                  final Map<String, int> pjMap = {};

                  for (final d in docs) {
                    final data = d.data();

                    DateTime? tglMulai;
                    DateTime? tglSelesai;

                    // tanggal_mulai
                    if (data['tanggal_mulai'] != null &&
                        data['tanggal_mulai'] is Timestamp) {
                      tglMulai = (data['tanggal_mulai'] as Timestamp).toDate();
                    }

                    // tanggal_selesai (opsional)
                    if (data['tanggal_selesai'] != null &&
                        data['tanggal_selesai'] is Timestamp) {
                      tglSelesai =
                          (data['tanggal_selesai'] as Timestamp).toDate();
                    }

                    if (tglMulai != null) {
                      final mulaiDate = DateTime(
                        tglMulai.year,
                        tglMulai.month,
                        tglMulai.day,
                      );

                      // kalau tidak ada tanggal_selesai → anggap 1 hari
                      final selesaiDate = tglSelesai != null
                          ? DateTime(
                              tglSelesai.year,
                              tglSelesai.month,
                              tglSelesai.day,
                            )
                          : mulaiDate;

                      // 🔹 KLASIFIKASI:
                      // lewat      : selesai < hari ini
                      // akan datang: mulai  > hari ini
                      // berlangsung: today berada di interval [mulai, selesai]
                      if (selesaiDate.isBefore(today)) {
                        lewat++;
                      } else if (mulaiDate.isAfter(today)) {
                        akanDatang++;
                      } else {
                        // today di antara mulai–selesai
                        sedangBerlangsung++;
                      }

                      // Hitung per bulan pakai bulan MULAI (0 = Jan, 11 = Des)
                      final monthIndex = mulaiDate.month - 1;
                      if (monthIndex >= 0 && monthIndex < 12) {
                        perBulan[monthIndex]++;
                      }
                    }

                    // 🔹 kategori
                    final kategori = (data['kategori'] ?? 'Lainnya').toString();
                    kategoriMap[kategori] = (kategoriMap[kategori] ?? 0) + 1;

                    // 🔹 penanggung jawab
                    final pj = (data['penanggung_jawab'] ?? 'Tidak diketahui')
                        .toString();
                    pjMap[pj] = (pjMap[pj] ?? 0) + 1;
                  }

                  final Map<String, double> kategoriPersen = {};
                  if (total > 0) {
                    kategoriMap.forEach((key, value) {
                      kategoriPersen[key] = (value / total.toDouble()) * 100.0;
                    });
                  }

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
                        // ⬇️ hariIni diganti sedangBerlangsung
                        KegiatanWaktuCard(
                          lewat: lewat,
                          hariIni: sedangBerlangsung,
                          akanDatang: akanDatang,
                        ),

                        const SizedBox(height: 16),

                        KegiatanPieCard(
                          data: kategoriPersen,
                          totalKegiatan: total,
                        ),
                        const SizedBox(height: 16),

                        KegiatanBarChartCard(
                          monthlyData: perBulan,
                        ),
                        const SizedBox(height: 16),

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
