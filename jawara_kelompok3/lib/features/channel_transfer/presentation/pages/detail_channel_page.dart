import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import 'daftar_channel_page.dart';

class DetailChannelPage extends StatelessWidget {
  final Map<String, String> channel;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.putihFull),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const DaftarChannelPage()));
          },
        ),
        title: const Text(
          'Detail Transfer Channel',
          style:
              TextStyle(color: AppTheme.putihFull, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card detail channel
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
                        // Judul Card
                        Center(
                          child: Text(
                            "Detail Transfer Channel",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nama Channel
                        _buildDetailRow("Nama Channel",
                            channel['namaChannel'] ?? "QRIS Resmi RT 08"),
                        _buildDetailRow(
                            "Tipe Channel", channel['tipe'] ?? "qris"),
                        _buildDetailRow("Nama Pemilik",
                            channel['pemilik'] ?? "RW 08 Karangploso"),
                        _buildDetailRow(
                            "Catatan",
                            channel['catatan'] ??
                                "Scan QR di bawah untuk membayar. Kirim bukti setelah pembayaran."),

                        const SizedBox(height: 20),

                        // Thumbnail QRIS
                        const Text(
                          "Thumbnail QRIS:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.hitam),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              channel['thumbnail'] ??
                                  'assets/images/default.jpg',
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Bukti Identitas QR
                        const Text(
                          "Bukti Identitas QR:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.hitam),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              channel['qr'] ?? 'assets/images/default.jpg',
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Catatan informasi
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

  // Widget pembantu untuk menampilkan satu baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          // Kotak nilai
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
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
