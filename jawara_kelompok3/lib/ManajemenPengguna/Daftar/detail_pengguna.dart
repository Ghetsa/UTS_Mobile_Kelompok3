import 'package:flutter/material.dart';
import 'daftar_pengguna.dart';
import '../../main.dart';
import '../../Theme/app_theme.dart';

class DetailPenggunaPage extends StatelessWidget {
  final User user;

  const DetailPenggunaPage({super.key, required this.user});

  // Warna status berdasarkan nilai statusRegistrasi
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return AppTheme.greenMediumDark;
      case 'Pending':
        return AppTheme.yellowMediumDark;
      case 'Ditolak':
        return AppTheme.redMedium;
      default:
        return AppTheme.blueDark;
    }
  }

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
          "Detail Pengguna",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Konten body
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

                // Card detail pengguna
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
                            "Detail Pengguna",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Profil pengguna (Avatar + Nama + Role)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar pengguna
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.primaryBlue,
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Nama dan Role
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.nama,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.role,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Detail informasi pengguna
                        _buildDetailRow("NIK", user.nik),
                        _buildDetailRow("Email", user.email),
                        _buildDetailRow("Nomor HP", user.noHp),
                        _buildDetailRow("Jenis Kelamin", user.jenisKelamin),
                        _buildDetailRow(
                          "Status Registrasi",
                          user.statusRegistrasi,
                          statusColor: _getStatusColor(user.statusRegistrasi),
                        ),
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
                      "Informasi pengguna ditampilkan secara lengkap",
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
  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
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
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.blueLight, width: 1),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: statusColor != null ? FontWeight.bold : FontWeight.normal,
                color: statusColor ?? AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
