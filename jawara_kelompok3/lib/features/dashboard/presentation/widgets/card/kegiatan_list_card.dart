import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanListCard extends StatelessWidget {
  final String nama;
  final int jumlah;

  const KegiatanListCard({
    super.key,
    required this.nama,
    required this.jumlah,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasData = jumlah > 0 && nama.isNotEmpty;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
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
            if (!hasData)
              const Text(
                "Belum ada data penanggung jawab kegiatan.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundBlueWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.blueMedium.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    nama,
                    style: const TextStyle(
                      color: AppTheme.blueDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    jumlah.toString(),
                    style: const TextStyle(
                      color: AppTheme.blueDark,
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
