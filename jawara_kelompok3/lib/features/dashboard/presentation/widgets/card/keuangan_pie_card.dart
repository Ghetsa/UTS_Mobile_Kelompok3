import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_theme.dart';

class PieCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final List<Color>? colors;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showTotal;

  const PieCard({
    super.key,
    required this.title,
    required this.data,
    this.colors,
    this.backgroundColor,
    this.textColor,
    this.showTotal = true,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (a, b) => a + b);

    final defaultColors = colors ??
        [
          AppTheme.blueMediumLight,
          AppTheme.greenMediumLight,
          AppTheme.pinkSoft,
          AppTheme.yellowMediumLight,
          AppTheme.redMediumLight,
          AppTheme.purpleMediumLight,
          AppTheme.orangeMedium,
        ];

    final width = MediaQuery.of(context).size.width;
    final chartSize = width < 600 ? 170.0 : 200.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
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
          // ===== TITLE =====
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor ?? Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // ===== PIE CHART =====
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: chartSize,
                  width: chartSize,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: chartSize / 3,
                      sectionsSpace: 2,
                      sections: List.generate(data.length, (i) {
                        return PieChartSectionData(
                          value: data.values.elementAt(i),
                          color: defaultColors[i % defaultColors.length],
                          showTitle: false,
                        );
                      }),
                    ),
                  ),
                ),

                // ===== TOTAL DI TENGAH =====
                if (showTotal)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        total.toInt().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: textColor ?? Colors.black87,
                        ),
                      ),
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 12,
                          color: (textColor ?? Colors.black87).withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== LEGEND (%) =====
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(data.length, (i) {
              final key = data.keys.elementAt(i);
              final value = data.values.elementAt(i);

              final percent = total == 0 ? 0 : (value / total) * 100;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: defaultColors[i % defaultColors.length],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$key (${percent.toStringAsFixed(1)}%)",
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor ?? Colors.black87,
                    ),
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
