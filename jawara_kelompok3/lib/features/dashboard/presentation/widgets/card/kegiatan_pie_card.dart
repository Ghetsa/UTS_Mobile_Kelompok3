import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanPieCard extends StatelessWidget {
  final Map<String, double> data;
  final int totalKegiatan;

  const KegiatanPieCard({
    super.key,
    required this.data,
    required this.totalKegiatan,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppTheme.blueMediumLight,
      AppTheme.greenMediumLight,
      AppTheme.pinkSoft,
      AppTheme.yellowMediumLight,
      AppTheme.redMediumLight,
      // kalau kategori > 5, nanti diputar lagi
    ];

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kegiatan per Kategori",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (data.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Belum ada data kategori kegiatan.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              )
            else ...[
              // ===== PIE CHART DI TENGAH CARD =====
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 190,
                      width: 190,
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: 55,
                          sectionsSpace: 2,
                          sections: List.generate(data.length, (i) {
                            final value = data.values.elementAt(i).abs();
                            return PieChartSectionData(
                              value: value <= 0 ? 0.01 : value,
                              color: colors[i % colors.length],
                              showTitle: false,
                            );
                          }),
                        ),
                      ),
                    ),

                    // ===== TEKS TOTAL DI TENGAH =====
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalKegiatan.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const Text(
                          "Kegiatan",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== LEGEND =====
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(data.length, (index) {
                  final key = data.keys.elementAt(index);
                  final value = data.values.elementAt(index);

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$key (${value.toStringAsFixed(0)}%)",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
