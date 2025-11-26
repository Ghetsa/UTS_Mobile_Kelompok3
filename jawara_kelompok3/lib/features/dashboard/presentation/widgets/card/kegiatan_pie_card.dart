import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanPieCard extends StatelessWidget {
  const KegiatanPieCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> data = {
      'Komunitas & Sosial': 30,
      'Keamanan': 25,
      'Keagamaan': 20,
      'Pendidikan': 15,
      'Olahraga': 10,
    };

    final colors = [
      AppTheme.blueMediumLight,
      AppTheme.greenMediumLight,
      AppTheme.pinkSoft,
      AppTheme.yellowMediumLight,
      AppTheme.redMediumLight,
    ];

    final total = data.values.reduce((a, b) => a + b);

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
                          return PieChartSectionData(
                            value: data.values.elementAt(i),
                            color: colors[i],
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
                        total.toInt().toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const Text(
                        "Total",
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
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${data.keys.elementAt(index)} "
                      "(${data.values.elementAt(index).toStringAsFixed(0)}%)",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
