import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Theme/app_theme.dart';
import '../layout/sidebar.dart';

class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(), // ✅ Tambahkan sidebar agar konsisten
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
            // ======= STAT KOTAK ATAS =======
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "🏠 Total Keluarga",
                    value: "6",
                    background: AppTheme.lightBlue,
                    textColor: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "👥 Total Penduduk",
                    value: "8",
                    background: AppTheme.lightGreen,
                    textColor: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ======= GRID CHARTS =======
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              children: const [
                _PieCard(
                  title: '🔘 Status Penduduk',
                  color: AppTheme.lightGreen,
                  textColor: AppTheme.primaryGreen,
                  data: {'Aktif': 100},
                ),
                _PieCard(
                  title: '⚤ Jenis Kelamin',
                  color: AppTheme.lightBlue,
                  textColor: AppTheme.primaryBlue,
                  data: {'Laki-laki': 88, 'Perempuan': 12},
                ),
                _PieCard(
                  title: '💼 Pekerjaan Penduduk',
                  color: AppTheme.lightGreen,
                  textColor: AppTheme.primaryGreen,
                  data: {'Lainnya': 100},
                ),
                _PieCard(
                  title: '👪 Peran dalam Keluarga',
                  color: AppTheme.lightBlue,
                  textColor: AppTheme.primaryBlue,
                  data: {'Kepala Keluarga': 75, 'Anak': 13, 'Anggota Lain': 12},
                ),
                _PieCard(
                  title: '🙏 Agama',
                  color: AppTheme.lightGreen,
                  textColor: AppTheme.primaryGreen,
                  data: {'Islam': 50, 'Katolik': 50},
                ),
                _PieCard(
                  title: '👨🏻‍🎓 Pendidikan',
                  color: AppTheme.lightBlue,
                  textColor: AppTheme.primaryBlue,
                  data: {'Sarjana/Diploma': 100},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGET: STAT CARD ====================
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: textColor, fontSize: 36)),
        ],
      ),
    );
  }
}

// ==================== WIDGET: PIE CARD ====================
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
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                sections: data.entries.map((e) {
                  final index = data.keys.toList().indexOf(e.key);
                  final colorList = [
                    AppTheme.primaryGreen,
                    AppTheme.primaryBlue,
                    Colors.orange,
                    Colors.pink,
                    Colors.indigo,
                  ];
                  return PieChartSectionData(
                    value: e.value,
                    title: "${e.key} ${e.value.toStringAsFixed(0)}%",
                    color: colorList[index % colorList.length],
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
