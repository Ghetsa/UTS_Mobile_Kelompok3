import 'package:flutter/material.dart';
import 'daftar_pengguna.dart';
import '../../main.dart';

const Color primaryDark = Color(0xFF5C4E43);
const Color secondaryCream = Color(0xFFEDE8D2);
const Color accentGold = Color(0xFFC7B68D);

// Halaman untuk menampilkan detail lengkap satu pengguna
class DetailPenggunaPage extends StatelessWidget {
  final User user;

  const DetailPenggunaPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengguna"),
        backgroundColor: Colors.white,
        elevation: 1,
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: primaryDark),
                  label: const Text(
                    "Kembali",
                    style: TextStyle(
                      color: primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Card Detail Pengguna
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detail Pengguna",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 30),

                        // Bagian Profil (Foto dan Nama/Role)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon/Avatar Pengguna
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: primaryDark,
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: secondaryCream,
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

                        // Detail Informasi dalam format Key-Value
                        _buildDetailItem(
                          key: "NIK",
                          value: user.nik,
                          isApproved: user.nik != "Tidak Tersedia",
                        ),
                        _buildDetailItem(
                          key: "Email",
                          value: user.email,
                          isApproved: true,
                        ),
                        _buildDetailItem(
                          key: "Nomor HP",
                          value: user.noHp,
                          isApproved: user.noHp != "08XXXXXXXXXX",
                        ),
                        _buildDetailItem(
                          key: "Jenis Kelamin",
                          value: user.jenisKelamin,
                          isApproved: user.jenisKelamin != "Tidak Tersedia",
                        ),
                        // Status Registrasi
                        _buildDetailItem(
                          key: "Status Registrasi",
                          value: user.statusRegistrasi,
                          isApproved: user.statusRegistrasi == "Diterima",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk menampilkan baris detail
  Widget _buildDetailItem({
    required String key,
    required String value,
    required bool isApproved,
  }) {
    // Teks "Approved" atau penanda status
    final statusWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: value == "Diterima" ? Colors.green[100] : Colors.amber[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: value == "Diterima" ? Colors.green[700] : Colors.amber[700],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          key == "Status Registrasi"
              ? statusWidget
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
