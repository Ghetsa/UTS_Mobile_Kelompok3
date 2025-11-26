import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/card/kependudukan_stat_card.dart';
import '../widgets/card/kependudukan_pie_card.dart';

class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER – mengikuti Dashboard Kegiatan
            const MainHeader(
              title: "Dashboard Kependudukan",
              searchHint: "Cari penduduk...",
              showSearchBar: false,
              showFilterButton: false,
            ),

            // const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// ==== STAT CARDS ====
                    Row(
                      children: const [
                        Expanded(
                          child: KependudukanStatCard(
                            title: "Total Keluarga",
                            value: "6",
                            background: AppTheme.greenDark,
                            textColor: Colors.white,
                            centered: false,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: KependudukanStatCard(
                            title: "Total Penduduk",
                            value: "8",
                            background: AppTheme.redDark,
                            textColor: Colors.white,
                            centered: false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// ==== PIE CHARTS SCROLL HORIZONTAL ====
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          KependudukanPieCard(
                            title: "Status Penduduk",
                            data: {'Aktif': 50, 'Pindah': 30, 'Wafat': 20},
                          ),
                          SizedBox(width: 16),
                          KependudukanPieCard(
                            title: "Jenis Kelamin",
                            data: {'Laki-laki': 88, 'Perempuan': 12},
                          ),
                          SizedBox(width: 16),
                          KependudukanPieCard(
                            title: "Pekerjaan Penduduk",
                            data: {'Lainnya': 100},
                          ),
                          SizedBox(width: 16),
                          KependudukanPieCard(
                            title: "Peran dalam Keluarga",
                            data: {
                              'Kepala Keluarga': 75,
                              'Anak': 13,
                              'Anggota Lain': 12,
                            },
                          ),
                          SizedBox(width: 16),
                          KependudukanPieCard(
                            title: "Agama",
                            data: {
                              'Islam': 50,
                              'Katolik': 10,
                              'Protestan': 15,
                              'Hindu': 10,
                              'Budha': 5,
                              'Konghucu': 7,
                              'Lainnya': 3,
                            },
                          ),
                          SizedBox(width: 16),
                          KependudukanPieCard(
                            title: "Pendidikan",
                            data: {
                              'S2': 5,
                              'Sarjana/Diploma': 15,
                              'SMA': 40,
                              'SMP': 10,
                              'SD': 30,
                            },
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
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
