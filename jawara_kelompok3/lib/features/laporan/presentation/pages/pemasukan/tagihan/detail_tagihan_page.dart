import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';

class DetailTagihanDialog extends StatelessWidget {
  final Map<String, dynamic> tagihan;

  const DetailTagihanDialog({super.key, required this.tagihan});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Tagihan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              "Informasi lengkap tagihan keluarga.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),

            _buildField("Nama Keluarga", tagihan['keluarga']),
            const SizedBox(height: 16),
            _buildField("Status Keluarga", tagihan['status']),
            const SizedBox(height: 16),
            _buildField("Iuran", tagihan['iuran']),
            const SizedBox(height: 16),
            _buildField("Kode Tagihan", tagihan['kode']),
            const SizedBox(height: 16),
            _buildField("Nominal", tagihan['nominal']),
            const SizedBox(height: 16),
            _buildField("Periode", tagihan['periode']),
            const SizedBox(height: 16),
            _buildField("Status Tagihan", tagihan['tagihan']),

            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Tutup",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
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
