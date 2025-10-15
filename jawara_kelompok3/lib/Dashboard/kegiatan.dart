import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Theme/app_theme.dart';
import '../layout/sidebar.dart';

class DashboardKegiatanPage extends StatelessWidget {
  const DashboardKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    // Jumlah kolom responsif
    int topColumns = 1;
    int bottomColumns = 1;
    if (width > 1100) {
      topColumns = 3;
      bottomColumns = 2;
    } else if (width > 700) {
      topColumns = 2;
      bottomColumns = 2;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text('Dashboard Kegiatan'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.appBarTheme.foregroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== BAGIAN ATAS ======
              GridView.count(
                crossAxisCount: topColumns,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    title: "🎉 Total Kegiatan",
                    value: "1",
                    subtitle: "Jumlah seluruh event yang sudah ada",
                    background: Colors.blue.shade50,
                    accent: Colors.blue.shade700,
                  ),
                  PieCard(
                    title: "📂 Kegiatan per Kategori",
                    background: Colors.green.shade50,
                    accent: Colors.green.shade800,
                  ),
                  StatCard(
                    title: "⏰ Kegiatan berdasarkan Waktu",
                    value: "3",
                    subtitle: "Sudah Lewat: 1\nHari Ini: 0\nAkan Datang: 0",
                    background: Colors.yellow.shade50,
                    accent: Colors.orange.shade700,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ====== BAGIAN BAWAH ======
              GridView.count(
                crossAxisCount: bottomColumns,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ExpandedListCard(),
                  BarChartCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== WIDGET KARTU STATISTIK ======
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color background;
  final Color accent;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle = '',
    this.background = const Color(0xFFE6F0FF),
    this.accent = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: background,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
            const SizedBox(height: 6),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: accent.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ====== WIDGET PIE CHART ======
class PieCard extends StatelessWidget {
  final String title;
  final Color background;
  final Color accent;

  const PieCard({
    super.key,
    required this.title,
    required this.background,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: background,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, color: accent, size: 22),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 45,
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      value: 100,
                      color: accent,
                      radius: 60,
                      title: '100%',
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 10,
              children: const [
                LegendDot(color: Colors.blue, text: 'Komunitas & Sosial'),
                LegendDot(color: Colors.green, text: 'Keamanan'),
                LegendDot(color: Colors.orange, text: 'Keagamaan'),
                LegendDot(color: Colors.purple, text: 'Pendidikan'),
                LegendDot(color: Colors.pink, text: 'Olahraga'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== TITIK LEGEND WARNA ======
class LegendDot extends StatelessWidget {
  final Color color;
  final String text;
  const LegendDot({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// ====== LIST KARTU PENANGGUNG JAWAB ======
class ExpandedListCard extends StatelessWidget {
  const ExpandedListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.purple.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👤 Penanggung Jawab Terbanyak",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                title: Text("Pak Joko"),
                trailing: Text("1"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== KARTU BAR CHART ======
class BarChartCard extends StatelessWidget {
  const BarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.pink.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📅 Kegiatan per Bulan (Tahun Ini)",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.pink.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) {
                          const bulan = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
                          return Text(bulan[v.toInt() % 12]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 9,
                      barRods: [
                        BarChartRodData(
                          toY: 1,
                          color: Colors.pink.shade400,
                          width: 18,
                        ),
                      ],
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
