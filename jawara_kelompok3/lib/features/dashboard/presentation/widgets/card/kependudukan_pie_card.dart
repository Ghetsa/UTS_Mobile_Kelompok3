import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_theme.dart';

class KependudukanPieCard extends StatelessWidget {
  final String title;
  final Map<String, double> data; // persen
  final int totalCount; // 🔥 jumlah data asli (bukan persen)

  const KependudukanPieCard({
    super.key,
    required this.title,
    required this.data,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppTheme.blueMediumLight,
      AppTheme.greenMediumLight,
      AppTheme.pinkSoft,
      AppTheme.yellowMediumLight,
      AppTheme.redMediumLight,
      AppTheme.blueMedium,
      AppTheme.yellowMediumDark,
      AppTheme.pinkPinky,
    ];

    return Container(
      width: 300,
      height: 380,
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
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppTheme.blueDark,
            ),
          ),

          const SizedBox(height: 16),

          // PIE CHART CENTER
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 48,
                      sections: List.generate(data.length, (i) {
                        return PieChartSectionData(
                          value: data.values.elementAt(i),
                          showTitle: false,
                          color: colors[i % colors.length],
                        );
                      }),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔥 TAMPILKAN JUMLAH DATA DI TENGAH
                    Text(
                      totalCount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: AppTheme.blueDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.blueDark.withOpacity(0.7),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LEGEND
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(data.length, (i) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${data.keys.elementAt(i)} (${data.values.elementAt(i).toStringAsFixed(0)}%)",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
