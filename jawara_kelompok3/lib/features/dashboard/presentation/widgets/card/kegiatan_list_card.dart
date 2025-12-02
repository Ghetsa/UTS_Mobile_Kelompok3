import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanListCard extends StatelessWidget {
  const KegiatanListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.white, // 🔹 background card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        // side: BorderSide(
        //   color: AppTheme.grayLight, // 🔹 border card
        //   width: 1.5,
        // ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Penanggung Jawab Terbanyak",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 18,
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
