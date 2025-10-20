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
            // === Baris 1: Total Pemasukan & Total Pengeluaran ===
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    title: "Total Pemasukan",
                    value: "50 jt",
                    background: AppTheme.backgroundBlueWhite,
                    textColor: AppTheme.greenDark,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Total Pengeluaran",
                    value: "2.1 rb",
                    background: AppTheme.backgroundBlueWhite,
                    textColor: AppTheme.redDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // === Baris 2: Jumlah Transaksi ===
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    title: "Jumlah Transaksi",
                    value: "5",
                    background: AppTheme.backgroundBlueWhite,
                    textColor: AppTheme.yellowDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // === Bar Chart ===
            const _BarChartCard(
              title: '📈 Pemasukan per Bulan',
              color: AppTheme.backgroundBlueWhite,
              textColor: AppTheme.greenDark,
              data: {
                'Jan': 120000,
                'Feb': 80000,
                'Mar': 160000,
                'Apr': 100000,
                'Mei': 200000,
                'Jun': 120000,
                'Jul': 80000,
                'Agu': 160000,
                'Sep': 100000,
                'Okt': 200000,
                'Nov': 160000,
                'Des': 100000,
              },
            ),

            const _BarChartCard(
              title: '📉 Pengeluaran per Bulan',
              color: AppTheme.backgroundBlueWhite,
              textColor: AppTheme.blueDark,
              data: {
                'Jan': 30000,
                'Feb': 30000,
                'Mar': 160000,
                'Apr': 100000,
                'Mei': 180000,
                'Jun': 50000,
                'Jul': 60000,
                'Agu': 150000,
                'Sep': 110000,
                'Okt': 140000,
                'Nov': 120000,
                'Des': 150000,
              },
              isRupiah: true,
            ),

            // === Pie Chart ===
            const _PieCard(
              title: '🧾 Pemasukan Berdasarkan Kategori',
              color: AppTheme.graySuperLight,
              textColor: AppTheme.grayMediumDark,
              colorType: _PieColorType.defaultColor,
              data: {'Dana Bantuan Pemerintah': 100, 'Pendapatan Lainnya': 0},
            ),
            const _PieCard(
              title: '🧾 Pengeluaran Berdasarkan Kategori',
              color: AppTheme.graySuperLight,
              textColor: AppTheme.grayMediumDark,
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
    // Jika kartu ini berisi "Jumlah Transaksi", maka center
    final bool isCenter = title == "Jumlah Transaksi";

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: AppTheme.grayExtraLight,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start, // ✅
        mainAxisAlignment:
            isCenter ? MainAxisAlignment.center : MainAxisAlignment.start, // ✅
        children: [
          Text(
            title,
            textAlign: isCenter ? TextAlign.center : TextAlign.left, // ✅
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: isCenter ? TextAlign.center : TextAlign.left, // ✅
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
    final chartSize = isMobile ? 180.0 : 200.0;

    // Warna kategori (default)
    final colorList = [
      AppTheme.yellowLight,
      AppTheme.yellowMedium,
      AppTheme.yellowMediumDark,
      AppTheme.redMedium,
      AppTheme.blueMedium,
    ];

    // Hitung total semua nilai
    final total = data.values.fold<double>(0, (sum, item) => sum + item);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.grayExtraLight,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Judul ===
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // === Layout chart + legend ===
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
                        centerSpaceRadius: chartSize / 3,
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

                  // === Teks di tengah lingkaran ===
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        total.toStringAsFixed(0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jumlah\nKategori',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
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

  // ===== LEGEND DI SAMPING =====
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

// ==================== BAR CHART HORIZONTAL ====================
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
    final width = MediaQuery.of(context).size.width;
    final chartHeight = width > 700 ? 420.0 : 360.0;

    // Ambil data dari Map dan urutkan agar tampil konsisten
    final bulan = data.keys.toList();
    final values = data.values.toList();

    // Dapatkan nilai maksimum
    final double maxValue =
        values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b).toDouble();

    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.grayExtraLight, width: 1.5),
      ),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Chart
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Area chart horizontal
            SizedBox(
              height: chartHeight,
              child: Column(
                children: [
                  // Deretan bar horizontal
                  Expanded(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bulan.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final value = values[index];
                        final widthFactor =
                            (maxValue == 0) ? 0.0 : (value / (maxValue + 0.0));
                        final barHeight = width > 700 ? 18.0 : 14.0;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Label bulan di kiri
                            SizedBox(
                              width: width > 700 ? 72 : 56,
                              child: Text(
                                bulan[index],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: width > 700 ? 13 : 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Batang nilai
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: textColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: widthFactor.clamp(0.0, 1.0),
                                    child: Container(
                                      height: barHeight,
                                      decoration: BoxDecoration(
                                        color: textColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Nilai nominal di kanan
                            SizedBox(
                              width: 56,
                              child: Text(
                                isRupiah
                                    ? "Rp${value.toStringAsFixed(0)}"
                                    : value.toStringAsFixed(1),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: textColor,
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

                  // Garis sumbu X sederhana
                  Row(
                    children: [
                      SizedBox(
                          width: width > 700 ? 72 : 56), // sejajar dengan label
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
                                  isRupiah ? "Rp$t" : t.toString(),
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.8),
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
            ),
          ],
        ),
      ),
    );
  }
}
