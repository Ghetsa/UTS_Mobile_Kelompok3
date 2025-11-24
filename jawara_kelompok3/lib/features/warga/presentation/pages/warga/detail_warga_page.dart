import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';

class DetailWargaDialog extends StatelessWidget {
  final Map<String, dynamic> warga;

  const DetailWargaDialog({super.key, required this.warga});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header
              const Text(
                "Detail Warga",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Informasi lengkap data warga.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              /// 🔹 Field Data
              _buildField("Nama", warga['nama']),
              const SizedBox(height: 16),
              _buildField("NIK", warga['nik']),
              const SizedBox(height: 16),
              _buildField("Keluarga", warga['keluarga']),
              const SizedBox(height: 16),
              _buildField("Jenis Kelamin", warga['jenisKelamin']),
              const SizedBox(height: 16),
              _buildField("Status Domisili", warga['statusDomisili']),
              const SizedBox(height: 16),
              _buildField("Status Hidup", warga['statusHidup']),

              const SizedBox(height: 24),

              /// 🔹 Tombol Tutup
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text("Tutup", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
