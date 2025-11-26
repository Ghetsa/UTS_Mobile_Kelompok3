import 'package:flutter/material.dart';
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
            /// Header (sama seperti keluarga)
            const MainHeader(
              title: "Dashboard Kegiatan",
              searchHint: "Cari kegiatan...",
              showSearchBar: false,
              showFilterButton: false,
            ),

            // const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    KegiatanStatCard(
                      title: "Total Kegiatan",
                      value: "1",
                      subtitle: "Jumlah seluruh event yang sudah ada",
                    ),
                    SizedBox(height: 16),
                    KegiatanStatCard(
                      title: "Kegiatan berdasarkan Waktu",
                      value: "3",
                      subtitle: "Lewat: 1 • Hari Ini: 0 • Akan Datang: 0",
                    ),
                    SizedBox(height: 16),
                    KegiatanPieCard(),
                    SizedBox(height: 16),

                    KegiatanBarChartCard(),
                    SizedBox(height: 16),

                    // ➕ Card Baru: List Penanggung Jawab
                    KegiatanListCard(),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
