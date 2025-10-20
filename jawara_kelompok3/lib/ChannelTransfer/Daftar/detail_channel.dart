import 'package:flutter/material.dart';
import '../../Theme/app_theme.dart';

class Channel {
  final String namaChannel;
  final String tipeChannel;
  final String nomorRekening;
  final String namaPemilik;
  final String catatan;
  final String thumbnail; 
  final String qrCode;   

  Channel({
    required this.namaChannel,
    required this.tipeChannel,
    required this.nomorRekening,
    required this.namaPemilik,
    required this.catatan,
    required this.thumbnail,
    required this.qrCode,
  });
}

class DetailChannelPage extends StatelessWidget {
  final Channel channel;

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
        title: const Text(
          "Detail Transfer Channel",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Kembali
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
                  label: const Text(
                    "Kembali",
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Card detail channel
                Card(
                  elevation: 8,
                  shadowColor: AppTheme.blueExtraLight,
                  color: Colors.white,
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

                        // Detail informasi channel
                        _buildDetailRow("Nama Channel", channel.namaChannel),
                        _buildDetailRow("Tipe Channel", channel.tipeChannel),
                        _buildDetailRow("Nomor Rekening / Akun", channel.nomorRekening),
                        _buildDetailRow("Nama Pemilik", channel.namaPemilik),
                        _buildDetailRow("Catatan", channel.catatan),
                        const SizedBox(height: 15),

                        // Thumbnail
                        _buildImageRow("Thumbnail", channel.thumbnail),
                        const SizedBox(height: 15),

                        // QR
                        _buildImageRow("QR", channel.qrCode),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Catatan di bawah
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
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.blueLight, width: 1),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan gambar
  Widget _buildImageRow(String label, String imagePath) {
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.blueLight, width: 1),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
