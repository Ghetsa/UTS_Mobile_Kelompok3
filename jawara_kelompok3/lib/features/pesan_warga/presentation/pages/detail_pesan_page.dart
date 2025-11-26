import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/layout/sidebar.dart';

class DetailAspirasi extends StatelessWidget {
  final Map<String, String> data;
  const DetailAspirasi({super.key, required this.data});

  // Warna berdasarkan status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return AppTheme.greenMediumDark;
      case 'Pending':
        return AppTheme.yellowMediumDark;
      case 'Ditolak':
        return AppTheme.redMedium;
      default:
        return AppTheme.hitam;
    }
  }

  // Tampilan halaman detail
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "Detail Aspirasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.putihFull,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.putihFull),
      ),

      // Card detail aspirasi
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shadowColor: AppTheme.blueExtraLight,
          color: AppTheme.putihFull,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul card
                Center(
                  child: Text(
                    "Detail Aspirasi Warga",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Data
                _buildDetailRow("Judul", data['judul']),
                const SizedBox(height: 12),

                _buildDetailRow("Deskripsi", data['deskripsi'] ?? '-'),
                const SizedBox(height: 12),

                _buildDetailRow(
                  "Status",
                  data['status'],
                  statusColor: _getStatusColor(data['status'] ?? ''),
                ),
                const SizedBox(height: 12),

                _buildDetailRow("Dibuat oleh", data['pengirim']),
                const SizedBox(height: 12),

                _buildDetailRow("Tanggal Dibuat", data['tanggalDibuat']),
                const SizedBox(height: 8),

                // Garis pemisah
                const Divider(
                  height: 30,
                  thickness: 1,
                  color: AppTheme.blueLight,
                  indent: 10,
                  endIndent: 10,
                ),

                // Catatan card bawah
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Terima kasih atas aspirasi Anda",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.blueDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu untuk menampilkan satu baris detail data
  Widget _buildDetailRow(String label, String? value, {Color? statusColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label “Judul:”, “Status:”, dll.
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 6),

        // Kotak nilai dari data
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundBlueWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.blueLight, width: 1),
          ),
          child: Text(
            value ?? '-',
            style: TextStyle(
              fontSize: 15,
              color: statusColor ?? AppTheme.hitam,
              fontWeight:
                  statusColor != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
