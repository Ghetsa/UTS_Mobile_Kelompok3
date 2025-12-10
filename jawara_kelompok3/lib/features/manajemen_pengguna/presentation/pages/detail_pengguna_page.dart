import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pengguna_model.dart';

class DetailPenggunaPage extends StatelessWidget {
  final User user;

  const DetailPenggunaPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Detail Pengguna",
              showSearchBar: false,
              showFilterButton: false,
              onSearch: (_) {},
              onFilter: () {},
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Detail Pengguna",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF48B0E0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Profil Pengguna
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFF48B0E0),
                              child: user.fotoIdentitas != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        user.fotoIdentitas!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.person,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.nama,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user.role,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Detail field (read-only)
                        _buildReadOnlyField("Nama Lengkap", user.nama),
                        _buildReadOnlyField("Email", user.email),
                        _buildReadOnlyField("NIK", user.nik),
                        _buildReadOnlyField("Nomor HP", user.noHp),
                        _buildReadOnlyField("Jenis Kelamin", user.jenisKelamin),
                        _buildReadOnlyField(
                            "Status Registrasi", user.statusPengguna),
                        _buildReadOnlyField("Role", user.role),
                        const SizedBox(height: 24),
                        // Foto identitas
                        const Text(
                          "Foto Identitas:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: user.fotoIdentitas != null
                                ? Image.network(
                                    user.fotoIdentitas!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/gambar1.jpg',
                                      width: double.infinity,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/gambar1.jpg',
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tombol Kembali
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF48B0E0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            child: const Text(
                              "Kembali",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ]),
    );
  }
}
