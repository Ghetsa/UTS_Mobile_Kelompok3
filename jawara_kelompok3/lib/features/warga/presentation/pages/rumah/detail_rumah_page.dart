import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';

class DetailRumahDialog extends StatelessWidget {
  final Map<String, dynamic> rumah;

  const DetailRumahDialog({super.key, required this.rumah});

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
                "Detail Rumah",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Informasi lengkap mengenai rumah.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              /// 🔹 Field Data
              _buildField("Nomor Rumah", rumah['no'].toString()),
              const SizedBox(height: 16),
              _buildField("Alamat", rumah['alamat']),
              const SizedBox(height: 16),
              _buildField("Status", rumah['status']),
              const SizedBox(height: 16),
              _buildField("Status Kepemilikan", rumah['kepemilikan']),
              const SizedBox(height: 16),
              _buildField("Penghuni", rumah['penghuni']),

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
