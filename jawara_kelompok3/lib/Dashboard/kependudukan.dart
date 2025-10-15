import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart'; // pastikan path ini sesuai dengan struktur project-mu

class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Dashboard Kependudukan'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ======= STAT KOTAK ATAS =======
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "🏠 Total Keluarga",
                    value: "6",
                    background: Colors.blue.shade100,
                    textColor: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "👥 Total Penduduk",
                    value: "8",
                    background: Colors.green.shade100,
                    textColor: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
                  color: Colors.yellow,
                  data: {'Aktif': 100},
                ),
                _PieCard(
                  title: '⚤ Jenis Kelamin',
                  color: Colors.purple,
                  data: {'Laki-laki': 88, 'Perempuan': 12},
                ),
                _PieCard(
                  title: '💼 Pekerjaan Penduduk',
                  color: Colors.pink,
                  data: {'Lainnya': 100},
                ),
                _PieCard(
                  title: '👪 Peran dalam Keluarga',
                  color: Colors.indigo,
                  data: {'Kepala Keluarga': 75, 'Anak': 13, 'Anggota Lain': 12},
                ),
                _PieCard(
                  title: '🙏 Agama',
                  color: Colors.red,
                  data: {'Islam': 50, 'Katolik': 50},
                ),
                _PieCard(
                  title: '👨🏻‍🎓 Pendidikan',
                  color: Colors.teal,
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
  final MaterialColor color;

  const _PieCard({
    required this.title,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: color.shade100,
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
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color.shade800),
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
                    color.shade800,
                    Colors.red.shade400,
                    Colors.green.shade600,
                    Colors.blue.shade600,
                    Colors.orange.shade600,
                  ];
                  return PieChartSectionData(
                    value: e.value,
                    title: "${e.key} ${e.value.toStringAsFixed(0)}%",
                    color: colorList[index % colorList.length],
                    titleStyle: TextStyle(
                      color: theme.colorScheme.onPrimary,
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
