import 'package:flutter/material.dart';

class BarChartCard extends StatelessWidget {
  final String title;

  /// Format data: {'Jan': 120000, 'Feb': 90000}
  final Map<String, num> data;

  final Color? barColor;
  final Color backgroundBarColor;
  final Color textColor;
  final double? maxValue;

  const BarChartCard({
    super.key,
    required this.title,
    required this.data,
    this.barColor,
    this.backgroundBarColor = const Color.fromARGB(50, 150, 180, 255),
    this.textColor = Colors.black,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text("Invalid chart data");
    }

    final labels = data.keys.toList();

    // 🔧 PENTING: paksa jadi List<double> biar reduce nggak error
    final List<double> values =
        data.values.map((e) => e.toDouble()).toList();

    final double computedMax = maxValue ??
        (values.isNotEmpty
            ? values.reduce((a, b) => a > b ? a : b)
            : 1);

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
          /// ===== TITLE =====
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),

          const SizedBox(height: 14),

          /// ===== BAR LIST =====
          Column(
            children: List.generate(labels.length, (i) {
              final double percent = computedMax == 0
                  ? 0
                  : (values[i] / computedMax);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        labels[i],
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: backgroundBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: percent.clamp(0, 1),
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: barColor ?? textColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      // tampilkan angka bulat
                      values[i].toStringAsFixed(0),
                      style: TextStyle(color: textColor),
                    ),
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
