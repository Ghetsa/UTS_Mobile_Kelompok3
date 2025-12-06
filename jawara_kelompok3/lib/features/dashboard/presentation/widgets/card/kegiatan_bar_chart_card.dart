import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanBarChartCard extends StatelessWidget {
  final List<int> monthlyData; // panjang ideal: 12 (Jan–Des)

  const KegiatanBarChartCard({
    super.key,
    required this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];

    // Pastikan panjang data = 12
    final values = monthlyData.length == 12
        ? monthlyData
        : List<int>.filled(12, 0);

    final maxValue = values.isEmpty
        ? 0
        : values.reduce((a, b) => a > b ? a : b);

    return Container(
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
            "Kegiatan per Bulan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 14),
          if (maxValue == 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Belum ada data kegiatan per bulan.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            )
          else
            Column(
              children: List.generate(months.length, (i) {
                final double percent = maxValue == 0
                    ? 0.0
                    : (values[i] / maxValue).toDouble();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 36,
                        child: Text(months[i]),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppTheme.blueMediumLight
                                    .withOpacity(.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: percent,
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppTheme.blueDark,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(values[i].toString()),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
