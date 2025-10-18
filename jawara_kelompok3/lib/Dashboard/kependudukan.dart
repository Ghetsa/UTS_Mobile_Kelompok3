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
      backgroundColor: AppTheme.backgroundBlueWhite,
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
                    background: AppTheme.blueExtraLight,
                    textColor: AppTheme.blueDark,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Total Penduduk",
                    value: "8",
                    background: AppTheme.blueExtraLight,
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
        color: AppTheme.blueLight,
        textColor: AppTheme.blueDark,
        data: {'Aktif': 100},
      ),
      _PieCard(
        title: 'Jenis Kelamin',
        color: AppTheme.blueMediumLight,
        textColor: AppTheme.blueDark,
        data: {'Laki-laki': 88, 'Perempuan': 12},
      ),
      _PieCard(
        title: 'Pekerjaan Penduduk',
        color: AppTheme.blueMedium,
        textColor: AppTheme.blueDark,
        data: {'Lainnya': 100},
      ),
      _PieCard(
        title: 'Peran dalam Keluarga',
        color: AppTheme.blueMediumDark,
        textColor: AppTheme.blueExtraLight,
        data: {'Kepala Keluarga': 75, 'Anak': 13, 'Anggota Lain': 12},
      ),
      _PieCard(
        title: 'Agama',
        color: AppTheme.blueDark,
        textColor: AppTheme.blueExtraLight,
        data: {'Islam': 50, 'Katolik': 50},
      ),
      _PieCard(
        title: 'Pendidikan',
        color: AppTheme.blueSuperDark,
        textColor: AppTheme.blueExtraLight,
        data: {'Sarjana/Diploma': 100},
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
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

    // 🎨 Warna kuning-oranye diambil dari AppTheme
    final colorList = [
      AppTheme.yellowSoft,
      AppTheme.orangeAccent,
      AppTheme.orangeAccent.withOpacity(0.8),
      AppTheme.orangeAccent.withOpacity(0.6),
      AppTheme.yellowSoft.withOpacity(0.7),
    ];

    final isMobile = width < 600;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Layout responsif
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: isMobile ? 180 : 200,
                width: isMobile ? 180 : 200,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 0,
                    sectionsSpace: 2,
                    sections: data.entries.map((e) {
                      final index = data.keys.toList().indexOf(e.key);
                      return PieChartSectionData(
                        value: e.value,
                        color: colorList[index % colorList.length],
                        radius: 90,
                      );
                    }).toList(),
                  ),
                ),
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
                    fontSize: 15,
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
