import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KependudukanBarCard extends StatelessWidget {
  final String title;
  final Map<String, int> data; // contoh: { "SMA": 20, "S1": 10 }

  const KependudukanBarCard({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Kalau tidak ada data
    if (data.isEmpty) {
      return Container(
        width: double.infinity,
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
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.blueDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Belum ada data pendidikan.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Urutkan berdasarkan nilai terbesar → terkecil biar enak dilihat
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxValue = entries.first.value;

    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.blueDark,
            ),
          ),
          const SizedBox(height: 14),

          Column(
            children: entries.map((e) {
              final label = e.key;
              final value = e.value;
              final double percent =
                  maxValue == 0 ? 0.0 : (value / maxValue).toDouble();

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    // Label pendidikan (misal "SMA")
                    SizedBox(
                      width: 70,
                      child: Text(
                        label.toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),

                    // Bar
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.blueMediumLight.withOpacity(.25),
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

                    const SizedBox(width: 8),

                    // Nilai & persentase kecil
                    Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
