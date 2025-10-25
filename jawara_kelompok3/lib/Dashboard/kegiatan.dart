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
        child: Container(
          color: AppTheme.backgroundBlueWhite,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== BAGIAN ATAS ======
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Lebar layar saat ini
                    final width = constraints.maxWidth;

                    if (width > 1100) {
                      // 🖥️ Desktop: 3 kolom
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: "🎉 Total Kegiatan",
                              value: "1",
                              subtitle: "Jumlah seluruh event yang sudah ada",
                              background: Colors.white,
                              accent: AppTheme.blueDark,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: PieCard(
                              title: "📂 Kegiatan per Kategori",
                              background: Colors.white,
                              accent: AppTheme.blueDark,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: "⏰ Kegiatan berdasarkan Waktu",
                              value: "3",
                              subtitle:
                                  "Sudah Lewat: 1\nHari Ini: 0\nAkan Datang: 0",
                              background: Colors.white,
                              accent: AppTheme.blueDark,
                            ),
                          ),
                        ],
                      );
                    } else if (width > 700) {
                      // 💻 Tablet: 2 kolom
                      return Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(
                                child: StatCard(
                                  title: "🎉 Total Kegiatan",
                                  value: "1",
                                  subtitle:
                                      "Jumlah seluruh event yang sudah ada",
                                  background: Colors.white,
                                  accent: AppTheme.blueDark,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: PieCard(
                                  title: "📂 Kegiatan per Kategori",
                                  background: Colors.white,
                                  accent: AppTheme.blueDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const StatCard(
                            title: "⏰ Kegiatan berdasarkan Waktu",
                            value: "3",
                            subtitle:
                                "Sudah Lewat: 1\nHari Ini: 0\nAkan Datang: 0",
                            background: Colors.white,
                            accent: AppTheme.blueDark,
                          ),
                        ],
                      );
                    } else {
                      // 📱 Mobile: 1 kolom (full width semua)
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: const StatCard(
                              title: "🎉 Total Kegiatan",
                              value: "1",
                              subtitle: "Jumlah seluruh event yang sudah ada",
                              background: Colors.white,
                              accent: AppTheme.blueDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: const PieCard(
                              title: "📂 Kegiatan per Kategori",
                              background: Colors.white,
                              accent: AppTheme.blueDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: const StatCard(
                              title: "⏰ Kegiatan berdasarkan Waktu",
                              value: "3",
                              subtitle:
                                  "Sudah Lewat: 1\nHari Ini: 0\nAkan Datang: 0",
                              background: Colors.white,
                              accent: AppTheme.blueDark,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                // ====== BAGIAN BAWAH ======
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (width > 700) {
                      // Tampilan desktop/tablet — dua kolom
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(child: ExpandedListCard()),
                          SizedBox(width: 16),
                          Expanded(child: BarChartCard()),
                        ],
                      );
                    } else {
                      // Tampilan mobile — full width satu-satu
                      return Column(
                        children: const [
                          ExpandedListCard(),
                          SizedBox(height: 16),
                          BarChartCard(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
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
    return Card(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppTheme.grayLight,
          width: 1.5,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Text(
              title,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w700,
                fontSize: 18, // 🔹 Ukuran font judul
              ),
            ),
            const SizedBox(height: 16),

            // Nilai utama
            Text(
              value,
              style: TextStyle(
                fontSize: 36, // 🔹 Ukuran angka utama
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
            const SizedBox(height: 6),

            // Keterangan tambahan
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13, // 🔹 Ukuran keterangan
                  color: accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ====== PIE CHART KEGIATAN PER KATEGORI ======
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final chartSize = isMobile ? 180.0 : 200.0;

    // 🔹 Data dummy kegiatan per kategori
    final Map<String, double> data = {
      'Komunitas & Sosial': 30,
      'Keamanan': 25,
      'Keagamaan': 20,
      'Pendidikan': 15,
      'Olahraga': 10,
    };

    // 🔹 Warna kategori
    final colorList = [
      AppTheme.blueMediumLight,
      AppTheme.greenMediumLight,
      AppTheme.pinkSoft,
      AppTheme.yellowMediumLight,
      AppTheme.redMediumLight,
    ];

    // 🔹 Total kegiatan
    final totalKegiatan =
        data.values.fold<double>(0, (prev, element) => prev + element);

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.grayLight,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: accent,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ====== PIE DAN LEGEND ======
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
                            chartSize / 3, // ⬅️ Buat bolong tengahnya
                        sections: data.entries.map((e) {
                          final index = data.keys.toList().indexOf(e.key);
                          return PieChartSectionData(
                            value: e.value,
                            color: colorList[index % colorList.length],
                            radius: chartSize / 6,
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
                        totalKegiatan.toStringAsFixed(0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jumlah\nKegiatan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: accent.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(child: _buildLegend(data, colorList, accent)),
            ],
          ),
        ],
      ),
    );
  }

  /// ====== LEGEND ======
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
                    fontSize: 13,
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
            fontSize: 13,
            color: AppTheme.blueDark,
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
      color: Colors.white, // 🔹 background card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppTheme.grayLight, // 🔹 border card
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👤 Penanggung Jawab Terbanyak",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.blueDark, // 🔹 warna teks judul
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.backgroundBlueWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.blueMedium.withOpacity(0.5), // 🔹 border lembut
                  width: 1,
                ),
              ),
              child: const ListTile(
                title: Text(
                  "Pak Joko",
                  style: TextStyle(
                    color: AppTheme.blueDark, // 🔹 warna teks isi
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  "1",
                  style: TextStyle(
                    color: AppTheme.blueDark, // 🔹 warna angka
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== BAR CHART HORIZONTAL MANUAL ======
class BarChartCard extends StatelessWidget {
  const BarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    // Data tetap sama
    final List<String> bulan = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      // "Okt",
      // "Nov",
      // "Des"
    ];
    // final List<double> values = [5, 3, 4, 2, 6, 1, 0, 3, 2];
    final List<double> values = [5, 3, 4, 2, 6, 1, 0, 3, 2, 4, 5, 1];

    // final chartHeight = width > 700 ? 420.0 : 360.0;
    final double maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    // Hitung tinggi otomatis berdasarkan jumlah data
    final barHeight = width > 700 ? 18.0 : 14.0;
    final barSpacing = 10.0; // jarak antar bar
    final chartHeight =
        bulan.length * (barHeight + barSpacing) + 60; // total tinggi dinamis

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.grayLight, width: 1.5),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📅 Kegiatan per Bulan (Tahun Ini)",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.blueDark,
              ),
            ),
            const SizedBox(height: 12),

            // Chart area
            SizedBox(
              height: chartHeight,
              child: Column(
                children: [
                  // Bar rows
                  Expanded(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bulan.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final value = values[index];
                        final widthFactor =
                            (maxValue == 0) ? 0.0 : (value / (maxValue + 0.0));

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width > 700 ? 72 : 56,
                              child: Text(
                                bulan[index],
                                style: TextStyle(
                                  color: AppTheme.blueDark,
                                  fontSize: width > 700 ? 13 : 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: AppTheme.blueMediumLight
                                          .withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: widthFactor.clamp(0.0, 1.0),
                                    child: Container(
                                      height: barHeight,
                                      decoration: BoxDecoration(
                                        color: AppTheme.blueDark,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 36,
                              child: Text(
                                value.toInt().toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: AppTheme.blueDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width > 700 ? 13 : 11,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // sumbu X sederhana (ticks 0..maxValue)
                  Row(
                    children: [
                      SizedBox(width: width > 700 ? 72 : 56),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final ticks = [
                              0,
                              (maxValue / 2).ceil(),
                              maxValue.toInt()
                            ];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: ticks.map((t) {
                                return Text(
                                  t.toString(),
                                  style: TextStyle(
                                    color: AppTheme.blueDark.withOpacity(0.8),
                                    fontSize: width > 700 ? 12 : 10,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
