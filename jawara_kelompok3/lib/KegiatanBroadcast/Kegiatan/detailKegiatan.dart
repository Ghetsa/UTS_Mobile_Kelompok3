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
            child: ListView(
              children: [
                _buildDetailItem(theme, "Nama Kegiatan", data["nama"]),
                _buildDetailItem(theme, "Kategori", data["kategori"]),
                _buildDetailItem(theme, "Penanggung Jawab", data["pj"]),
                _buildDetailItem(theme, "Tanggal Pelaksanaan", data["tanggal"]),
                _buildDetailItem(theme, "Lokasi", data["lokasi"]),
                _buildDetailItem(theme, "Deskripsi", data["deskripsi"], multiline: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(ThemeData theme, String title, String? value,
      {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value != null && value.isNotEmpty ? value : "-",
            style: theme.textTheme.bodyLarge,
            textAlign: multiline ? TextAlign.justify : TextAlign.start,
          ),
        ],
      ),
    );
  }
}
