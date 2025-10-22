import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Theme/app_theme.dart';
import '../layout/sidebar.dart';

class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text('Dashboard Kependudukan'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // === Total Keluarga & Total Penduduk ===
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    title: "Total Keluarga",
                    value: "6",
                    background: AppTheme.blueSuperLight,
                    textColor: AppTheme.blueDark,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Total Penduduk",
                    value: "8",
                    background: AppTheme.blueSuperLight,
                    textColor: AppTheme.blueDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // === Pie Cards ===
            ..._buildPieCards(),
          ],
        ),
      ),
    );
  }

  // ==================== PIE CHART CARDS ====================
  static List<Widget> _buildPieCards() {
    return const [
      _PieCard(
        title: 'Status Penduduk',
        color: AppTheme.backgroundBlueWhite,
        textColor: AppTheme.blueDark,
        data: {'Aktif': 50, 'Pindah': 30, 'Wafat': 20},
      ),
      _PieCard(
        title: 'Jenis Kelamin',
        color: AppTheme.backgroundBlueWhite,
        textColor: AppTheme.blueDark,
        data: {'Laki-laki': 88, 'Perempuan': 12},
      ),
      _PieCard(
        title: 'Pekerjaan Penduduk',
        color: AppTheme.backgroundBlueWhite,
        textColor: AppTheme.blueDark,
        data: {'Lainnya': 100},
      ),
      _PieCard(
        title: 'Peran dalam Keluarga',
        color: AppTheme.backgroundBlueWhite,
        textColor: AppTheme.blueDark,
        data: {'Kepala Keluarga': 75, 'Anak': 13, 'Anggota Lain': 12},
      ),
      _PieCard(
        title: 'Agama',
        color: AppTheme.backgroundBlueWhite,
        textColor: AppTheme.blueDark,
        data: {
          'Islam': 50,
          'Katolik': 10,
          'Protestan': 15,
          'Hindu': 10,
          'Budha': 5,
          'Konghucu': 7,
          'Lainnya': 3
        },
      ),
      _PieCard(
        title: 'Pendidikan',
        color: AppTheme.backgroundBlueWhite,
        textColor: AppTheme.blueDark,
        data: {'S2': 5, 'Sarjana/Diploma': 15, 'SMA': 40, 'SMP': 10, 'SD': 30},
      ),
    ];
  }
}

// ==================== STAT CARD ====================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color background;
  final Color textColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppTheme.blueDark.withOpacity(0.05),
        //     blurRadius: 8,
        //     offset: const Offset(2, 4),
        //   ),
        // ],
        border: Border.all(
          color: AppTheme.blueExtraLight,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: textColor,
              fontSize: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PIE CARD ====================
class _PieCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final Color color;
  final Color textColor;

  const _PieCard({
    required this.title,
    required this.data,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final chartSize = isMobile ? 180.0 : 200.0;

    // Warna kategori (dari AppTheme)
    final colorList = [
      AppTheme.yellowMediumLight,
      AppTheme.greenMediumLight,
      AppTheme.redMediumLight,
      AppTheme.blueMedium,
      AppTheme.pinkSoft,
      AppTheme.blueMediumLight,
      AppTheme.yellowMediumDark,
      AppTheme.pinkPinky,
    ];

    // Hitung total semua kegiatan
    final total = data.values.fold<double>(0, (sum, item) => sum + item);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 8,
        //     offset: const Offset(2, 4),
        //   ),
        // ],
        border: Border.all(
          color: AppTheme.grayExtraLight,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri judul
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // 🔹 Sama dengan Pie Kegiatan Per Kategori
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Layout chart dan legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: chartSize,
                    width: chartSize,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius:
                            chartSize / 3, // 🔹 Sama ukuran bolong tengah
                        sections: data.entries.map((e) {
                          final index = data.keys.toList().indexOf(e.key);
                          return PieChartSectionData(
                            value: e.value,
                            color: colorList[index % colorList.length],
                            radius:
                                chartSize / 6, // 🔹 Sama ukuran radius slice
                            showTitle: false,
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // 🔹 Teks di tengah pie
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        total.toStringAsFixed(0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              22, // 🔹 Sama seperti Pie Kegiatan Per Kategori
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jumlah\nKegiatan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12, // 🔹 Sama ukuran keterangan tengah
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildLegend(data, colorList, textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====== LEGEND ======
  Widget _buildLegend(
      Map<String, double> data, List<Color> colorList, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((e) {
        final index = data.keys.toList().indexOf(e.key);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colorList[index % colorList.length],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "${e.key} (${e.value.toStringAsFixed(0)}%)",
                  style: TextStyle(
                    color: textColor,
                    fontSize:
                        13, // 🔹 Sama seperti legend Pie Kegiatan Per Kategori
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
