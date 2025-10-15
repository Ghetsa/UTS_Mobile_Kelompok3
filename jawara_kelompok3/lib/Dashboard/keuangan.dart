import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardKeuanganPage extends StatelessWidget {
  const DashboardKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= Header (Tahun) =======
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_month_outlined, size: 18),
                      SizedBox(width: 8),
                      Text("2025",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ======= 3 Summary Cards =======
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _SummaryCard(
                  color: Color(0xFFDBEAFE),
                  textColor: Color(0xFF1E3A8A),
                  title: "📥 Total Pemasukan",
                  value: "50 jt",
                ),
                _SummaryCard(
                  color: Color(0xFFD1FAE5),
                  textColor: Color(0xFF065F46),
                  title: "📤 Total Pengeluaran",
                  value: "2.1 rb",
                ),
                _SummaryCard(
                  color: Color(0xFFFEF9C3),
                  textColor: Color(0xFF92400E),
                  title: "📊 Jumlah Transaksi",
                  value: "4",
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ======= Grafik per bulan =======
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _BarChartCard(
                  title: "📈 Pemasukan per Bulan",
                  color: Color(0xFFF3E8FF),
                  textColor: Color(0xFF6B21A8),
                  barColor: Color(0xFF38BDF8),
                  data: [0, 45, 60],
                  labels: ["Agu", "Sep", "Okt"],
                ),
                _BarChartCard(
                  title: "📉 Pengeluaran per Bulan",
                  color: Color(0xFFFCE7F3),
                  textColor: Color(0xFF9D174D),
                  barColor: Color(0xFFF87171),
                  data: [0, 1.1, 2.1],
                  labels: ["Agu", "Sep", "Okt"],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ======= Grafik per kategori =======
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _PieChartCard(
                  title: "🧾 Pemasukan Berdasarkan Kategori",
                  color: Color(0xFFDBEAFE),
                  textColor: Color(0xFF1E3A8A),
                  sections: [
                    PieChartSectionData(
                      color: Color(0xFFF87171),
                      value: 0,
                      title: "0%",
                    ),
                    PieChartSectionData(
                      color: Color(0xFFFBBF24),
                      value: 100,
                      title: "100%",
                    ),
                  ],
                  labels: [
                    "Dana Bantuan Pemerintah",
                    "Pendapatan Lainnya",
                  ],
                ),
                _PieChartCard(
                  title: "🧾 Pengeluaran Berdasarkan Kategori",
                  color: Color(0xFFD1FAE5),
                  textColor: Color(0xFF065F46),
                  sections: [
                    PieChartSectionData(
                      color: Color(0xFFF87171),
                      value: 100,
                      title: "100%",
                    ),
                  ],
                  labels: ["Pemeliharaan Fasilitas"],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color textColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
          const SizedBox(height: 10),
          Text(value,
              style:
                  TextStyle(fontWeight: FontWeight.w900, fontSize: 32, color: textColor)),
        ],
      ),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  final String title;
  final List<double> data;
  final List<String> labels;
  final Color color;
  final Color textColor;
  final Color barColor;

  const _BarChartCard({
    required this.title,
    required this.data,
    required this.labels,
    required this.color,
    required this.textColor,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        int i = value.toInt();
                        if (i >= 0 && i < labels.length) {
                          return Text(labels[i]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                barGroups: data.asMap().entries.map((entry) {
                  return BarChartGroupData(x: entry.key, barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      color: barColor,
                      width: 30,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChartCard extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final List<PieChartSectionData> sections;
  final List<String> labels;

  const _PieChartCard({
    required this.title,
    required this.color,
    required this.textColor,
    required this.sections,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 50,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: labels.map((label) {
              final index = labels.indexOf(label);
              return Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: sections[index].color,
                  ),
                  const SizedBox(width: 6),
                  Text(label,
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
