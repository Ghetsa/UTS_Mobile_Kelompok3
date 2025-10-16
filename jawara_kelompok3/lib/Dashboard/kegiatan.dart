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
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 32) / (width > 1100
                      ? 3
                      : width > 700
                          ? 2
                          : 1);
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: StatCard(
                          title: "🎉 Total Kegiatan",
                          value: "1",
                          subtitle: "Jumlah seluruh event yang sudah ada",
                          background: Colors.blue.shade50,
                          accent: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: PieCard(
                          title: "📂 Kegiatan per Kategori",
                          background: Colors.green.shade50,
                          accent: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: StatCard(
                          title: "⏰ Kegiatan berdasarkan Waktu",
                          value: "3",
                          subtitle: "Sudah Lewat: 1\nHari Ini: 0\nAkan Datang: 0",
                          background: Colors.yellow.shade50,
                          accent: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // ====== BAGIAN BAWAH ======
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 16) / (width > 700 ? 2 : 1);
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: const ExpandedListCard(),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: const BarChartCard(),
                      ),
                    ],
                  );
                },
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
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 36,
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
    final width = MediaQuery.of(context).size.width;
    final chartSize = width > 700 ? 160.0 : 120.0;

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
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: chartSize,
              width: chartSize, // pastikan width sama dengan height
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 0, 
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      value: 100,
                      color: accent,
                      radius: chartSize / 2, 
                      title: '100%',
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontSize: chartSize / 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
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

/// ====== LEGEND ======
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
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

/// ====== BAR CHART ======
class BarChartCard extends StatelessWidget {
  const BarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final chartHeight = width > 700 ? 300.0 : 250.0;

    // Data contoh
    final List<String> bulan = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    final List<double> values = [5, 3, 4, 2, 6, 1, 0, 3, 2, 4, 5, 1];

    final maxValue = values.reduce((a, b) => a > b ? a : b) + 1;

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
            SizedBox(
              height: chartHeight,
              child: BarChart(
                BarChartData(
                  maxY: maxValue, // skala horizontal
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: 12,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < bulan.length) {
                            return Text(
                              bulan[value.toInt()],
                              style: TextStyle(fontSize: width > 700 ? 12 : 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 70,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: width > 700 ? 12 : 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  barGroups: List.generate(bulan.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barsSpace: 4,
                      barRods: [
                        BarChartRodData(
                          toY: values[index], 
                          width: width > 700 ? 18 : 12,
                          color: Colors.pink.shade400,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
                swapAnimationDuration: const Duration(milliseconds: 400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}