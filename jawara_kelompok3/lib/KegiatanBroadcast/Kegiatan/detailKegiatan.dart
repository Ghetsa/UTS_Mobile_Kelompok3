import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';

class DetailKegiatanPage extends StatelessWidget {
  final Map<String, String> data;

  const DetailKegiatanPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Detail Kegiatan"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nama Kegiatan:", style: theme.textTheme.titleMedium),
                Text(data["nama"] ?? "-", style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text("Kategori:", style: theme.textTheme.titleMedium),
                Text(data["kategori"] ?? "-", style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text("Penanggung Jawab:", style: theme.textTheme.titleMedium),
                Text(data["pj"] ?? "-", style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text("Tanggal:", style: theme.textTheme.titleMedium),
                Text(data["tanggal"] ?? "-", style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),

                Text("Nominal:", style: theme.textTheme.titleMedium),
                Text(data["nominal"] ?? "-", style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
