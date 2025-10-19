import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Theme/app_theme.dart';
import '../layout/sidebar.dart';

class DashboardKeuanganPage extends StatelessWidget {
  const DashboardKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const AppSidebar(),
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text(
          'Dashboard Keuangan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _StatCard(
              title: "📥 Total Pemasukan",
              value: "50 jt",
              background: AppTheme.blueExtraLight,
              textColor: AppTheme.blueDark,
            ),
            const SizedBox(height: 12),

            const _StatCard(
              title: "📤 Total Pengeluaran",
              value: "2.1 rb",
              background: AppTheme.greenExtraLight,
              textColor: AppTheme.greenDark,
            ),
            const SizedBox(height: 20),

            const _StatCard(
              title: "📊 Jumlah Transaksi",
              value: "5",
              background: AppTheme.yellowExtraLight,
              textColor: AppTheme.yellowDark,
            ),
            const SizedBox(height: 20),

            // === Ganti jadi Bar Chart ===
            const _BarChartCard(
              title: '📈 Pemasukan per Bulan',
              color: Color(0xFFF3E8FF), // ungu muda
              textColor: AppTheme.blueDark,
              data: {
                'Agu': 0,
                'Okt': 50,
              },
            ),
            const _BarChartCard(
              title: '📉 Pengeluaran per Bulan',
              color: Color(0xFFFFEBEE), // merah muda
              textColor: AppTheme.redDark,
              data: {
                'Okt': 2.1,
              },
              isRupiah: false,
            ),

            const _PieCard(
              title: '🧾 Pemasukan Berdasarkan Kategori',
              color: AppTheme.blueExtraLight,
              textColor: AppTheme.blueDark,
              colorType: _PieColorType.defaultColor,
              data: {'Dana Bantuan Pemerintah': 100, 'Pendapatan Lainnya': 0},
            ),
            const _PieCard(
              title: '🧾 Pengeluaran Berdasarkan Kategori',
              color: AppTheme.greenExtraLight,
              textColor: AppTheme.greenDark,
              colorType: _PieColorType.defaultColor,
              data: {'Operasional RT/RW': 0, 'Pemeliharaan Fasilitas': 100},
            ),
          ],
        ),
      ),
    );
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
      width: double.infinity,
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
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ENUM UNTUK TIPE WARNA ====================
enum _PieColorType { green, red, blue, defaultColor }

// ==================== PIE CARD ====================
class _PieCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final Color color;
  final Color textColor;
  final _PieColorType colorType;

  const _PieCard({
    required this.title,
    required this.data,
    required this.color,
    required this.textColor,
    required this.colorType,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final colorListDefault = [
      AppTheme.yellowLight,
      AppTheme.yellowMedium,
      AppTheme.yellowDark,
    ];

    List<Color> selectedList = colorListDefault;

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
                    color: selectedList[index % selectedList.length],
                    radius: 90,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BAR CHART CARD ====================
class _BarChartCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final Color color;
  final Color textColor;
  final bool isRupiah;

  const _BarChartCard({
    required this.title,
    required this.data,
    required this.color,
    required this.textColor,
    this.isRupiah = true,
  });

  @override
  Widget build(BuildContext context) {
    final spots = data.entries.toList();
    final barGroups = spots.map((e) {
      final index = spots.indexOf(e);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: AppTheme.blueMedium,
            width: 30,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

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
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          spots[value.toInt()].key,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
