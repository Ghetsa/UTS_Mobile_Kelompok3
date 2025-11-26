import 'package:flutter/material.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/layout/header.dart';

import '../widgets/card/keuangan_stat_card.dart';
import '../widgets/card/keuangan_stat_card_row.dart'; // ⬅️ BARU
import '../widgets/card/keuangan_bar_chart_card.dart';
import '../widgets/card/keuangan_pie_card.dart';

class DashboardKeuanganPage extends StatelessWidget {
  const DashboardKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
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

            /// ===== BODY SCROLL =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ====== STAT CARD 2 KOLOM DINAMIS ======
                    StatCardRow(
                      cards: const [
                        StatCard(
                          title: "Total Pemasukan",
                          value: "50 jt",
                          background: Colors.white,
                          textColor: AppTheme.greenDark,
                        ),
                        StatCard(
                          title: "Total Pengeluaran",
                          value: "2.1 rb",
                          background: Colors.white,
                          textColor: AppTheme.redDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// ====== STAT CARD 1 KOLOM (FULL WIDTH) ======
                    const StatCard(
                      title: "Jumlah Transaksi",
                      value: "5",
                      centered: true,
                      background: Colors.white,
                      textColor: AppTheme.yellowDark,
                    ),

                    const SizedBox(height: 16),

                    /// ===== BAR CHART PEMASUKAN =====
                    BarChartCard(
                      title: "📈 Pemasukan per Bulan",
                      textColor: AppTheme.greenDark,
                      data: {
                        'Jan': 120000,
                        'Feb': 80000,
                        'Mar': 160000,
                        'Apr': 100000,
                        'Mei': 200000,
                        'Jun': 120000,
                        'Jul': 80000,
                        'Agu': 160000,
                        'Sep': 100000,
                        'Okt': 200000,
                        'Nov': 160000,
                        'Des': 100000,
                      },
                    ),

                    const SizedBox(height: 16),

                    /// ===== BAR CHART PENGELUARAN =====
                    BarChartCard(
                      title: "📉 Pengeluaran per Bulan",
                      textColor: AppTheme.blueDark,
                      data: {
                        'Jan': 30000,
                        'Feb': 30000,
                        'Mar': 160000,
                        'Apr': 100000,
                        'Mei': 180000,
                        'Jun': 50000,
                        'Jul': 60000,
                        'Agu': 150000,
                        'Sep': 110000,
                        'Okt': 140000,
                        'Nov': 120000,
                        'Des': 150000,
                      },
                    ),

                    const SizedBox(height: 16),

                    /// ===== PIE PEMASUKAN =====
                    PieCard(
                      title: "🧾 Pemasukan Berdasarkan Kategori",
                      textColor: AppTheme.yellowSuperDark,
                      data: {
                        "Dana Bantuan Pemerintah": 100,
                        "Pendapatan Lainnya": 0,
                      },
                    ),

                    const SizedBox(height: 16),

                    /// ===== PIE PENGELUARAN =====
                    PieCard(
                      title: "🧾 Pengeluaran Berdasarkan Kategori",
                      textColor: AppTheme.yellowSuperDark,
                      data: {
                        "Operasional RT/RW": 0,
                        "Pemeliharaan Fasilitas": 100,
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
