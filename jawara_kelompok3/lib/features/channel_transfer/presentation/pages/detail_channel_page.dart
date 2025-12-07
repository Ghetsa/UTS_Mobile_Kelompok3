import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DetailChannelPage extends StatelessWidget {
  final Map<String, String?> channel;

  const DetailChannelPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Detail ${channel['namaChannel'] ?? 'Channel'}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.putihFull,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.putihFull),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                        Center(
                          child: Text(
                            "Detail Channel Transfer",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow(
                            "Nama Channel", channel['namaChannel'] ?? "-"),
                        _buildDetailRow("Tipe Channel", channel['tipe'] ?? "-"),
                        _buildDetailRow(
                            "Nama Pemilik", channel['pemilik'] ?? "-"),
                        _buildDetailRow("Catatan", channel['catatan'] ?? "-"),
                        const SizedBox(height: 24),
                        const Text(
                          "Thumbnail QRIS:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        _imageBox(channel['thumbnail']),
                        const SizedBox(height: 24),
                        const Text(
                          "Bukti Identitas QR:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        _imageBox(channel['qr']),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline,
                        color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Informasi channel ditampilkan secara lengkap",
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.lightBlue, width: 1),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: AppTheme.hitam),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBox(String? path) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey.shade200,
          child: path == null
              ? const Center(child: Text("Tidak ada gambar"))
              : Image.network(
                  path,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text("Gagal memuat gambar")),
                ),
        ),
      ),
    );
  }
}
